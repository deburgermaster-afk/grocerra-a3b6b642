// Captures a true-size viewport screenshot via the Chrome DevTools Protocol.
//
// Headless Chrome clamps --window-size to a ~500px minimum, which silently
// crops narrow mobile viewports. Emulation.setDeviceMetricsOverride is the
// only reliable way to render at an exact 390x844 device size.
//
// Usage: dart run tool/capture.dart <url> <outPng> [width] [height] [scale]
import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final String url = args[0];
  final String out = args[1];
  final int width = args.length > 2 ? int.parse(args[2]) : 390;
  final int height = args.length > 3 ? int.parse(args[3]) : 844;
  final int scale = args.length > 4 ? int.parse(args[4]) : 2;
  // Ephemeral port per run so a crashed run cannot poison the next one.
  final int port = 9400 + (DateTime.now().millisecondsSinceEpoch % 500);

  final String profile =
      Directory.systemTemp.createTempSync('grocerra_cap_').path;

  final Process chrome = await Process.start(
    r'C:\Program Files\Google\Chrome\Application\chrome.exe',
    <String>[
      '--headless=new',
      '--disable-gpu',
      '--hide-scrollbars',
      '--no-first-run',
      '--no-default-browser-check',
      '--remote-debugging-port=$port',
      '--user-data-dir=$profile',
      'about:blank',
    ],
  );

  try {
    final String wsUrl = await _waitForTarget(port);
    stdout.writeln('  [diag] target: ${wsUrl.substring(0, 40)}...');
    final WebSocket ws = await WebSocket.connect(wsUrl);
    final _Cd cdp = _Cd(ws);
    stdout.writeln('  [diag] ws connected');

    await cdp.send('Emulation.setDeviceMetricsOverride', <String, dynamic>{
      'width': width,
      'height': height,
      'deviceScaleFactor': scale,
      'mobile': true,
    });
    stdout.writeln('  [diag] metrics set');
    await cdp.send('Page.enable');
    stdout.writeln('  [diag] page enabled');
    await cdp.send('Page.navigate', <String, dynamic>{'url': url});
    stdout.writeln('  [diag] navigated');

    // Wait for the document to actually finish loading before asking for a
    // frame; otherwise captureScreenshot blocks indefinitely.
    await cdp.send('Runtime.enable');
    for (int i = 0; i < 40; i++) {
      final Map<String, dynamic> r = await cdp.send('Runtime.evaluate', <String, dynamic>{
        'expression': 'document.readyState + "|" + (document.getElementsByTagName("canvas").length) + "|" + document.title',
        'returnByValue': true,
      });
      final Map<String, dynamic>? val = r['result'] as Map<String, dynamic>?;
      final String s = '${val?['value']}';
      stdout.writeln('  [diag] state($i): $s');
      if (s.startsWith('complete')) break;
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    await Future<void>.delayed(const Duration(seconds: 2));

    final Map<String, dynamic> shot = await cdp.send(
      'Page.captureScreenshot',
      <String, dynamic>{'format': 'png', 'captureBeyondViewport': false},
    );
    File(out).writeAsBytesSync(base64Decode(shot['data'] as String));
    stdout.writeln(
      'saved $out (${width}x$height @${scale}x) from $url',
    );
    await cdp.close();
  } finally {
    chrome.kill(ProcessSignal.sigterm);
    try {
      Directory(profile).deleteSync(recursive: true);
    } catch (_) {
      // Chrome may hold the profile briefly; temp cleanup is best effort.
    }
  }
}

/// Polls the debugging endpoint until a page target is available.
Future<String> _waitForTarget(int port) async {
  final HttpClient client = HttpClient();
  for (int i = 0; i < 60; i++) {
    try {
      final HttpClientRequest req =
          await client.getUrl(Uri.parse('http://127.0.0.1:$port/json/list'));
      final HttpClientResponse res = await req.close();
      final String body = await res.transform(utf8.decoder).join();
      final List<dynamic> list = jsonDecode(body) as List<dynamic>;
      for (final dynamic t in list) {
        if (t is Map && t['type'] == 'page' && t['webSocketDebuggerUrl'] != null) {
          return t['webSocketDebuggerUrl'] as String;
        }
      }
    } catch (_) {
      // Not up yet.
    }
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
  throw StateError('Chrome DevTools endpoint never became ready');
}

/// Minimal request/response wrapper around a CDP WebSocket.
class _Cd {
  _Cd(this._ws) {
    _ws.listen((dynamic message) {
      final Map<String, dynamic> m = jsonDecode(message as String);
      final int? id = m['id'];
      if (id == null) return;
      final _Pending? p = _pending.remove(id);
      if (p == null) return;
      if (m['error'] != null) {
        p.completer.completeError(StateError('${m['error']}'));
      } else {
        p.completer.complete(m['result'] as Map<String, dynamic>? ?? {});
      }
    });
  }

  final WebSocket _ws;
  final Map<int, _Pending> _pending = <int, _Pending>{};
  int _next = 0;

  Future<Map<String, dynamic>> send(
    String method, [
    Map<String, dynamic> params = const <String, dynamic>{},
  ]) async {
    final int id = ++_next;
    final completer = Completer<Map<String, dynamic>>();
    _pending[id] = _Pending(completer);
    _ws.add(jsonEncode(<String, dynamic>{
      'id': id,
      'method': method,
      'params': params,
    }));
    return completer.future.timeout(const Duration(seconds: 90));
  }

  Future<void> close() => _ws.close();
}

class _Pending {
  _Pending(this.completer);
  final Completer<Map<String, dynamic>> completer;
}
