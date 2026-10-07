// Minimal static server for the Flutter web build, with index.html fallback
// so deep links (/auth, /home, ...) resolve. Dev tooling only - not shipped.
import 'dart:io';

Future<void> main(List<String> args) async {
  final int port = args.isNotEmpty ? int.parse(args[0]) : 8787;
  final Directory root = Directory('build${Platform.pathSeparator}web');

  final HttpServer server =
      await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  stdout.writeln('Serving ${root.path} at http://127.0.0.1:$port/');

  await for (final HttpRequest request in server) {
    try {
      final String path = request.uri.path;
      final String relative = path == '/'
          ? 'index.html'
          : path.replaceAll('/', Platform.pathSeparator);
      File file = File('${root.path}${Platform.pathSeparator}$relative');

      if (await file.exists()) {
        await _send(request, file);
      } else {
        // SPA fallback: unknown path -> index.html (Flutter reads the path).
        final File index =
            File('${root.path}${Platform.pathSeparator}index.html');
        await _send(request, index);
      }
    } catch (_) {
      request.response.statusCode = HttpStatus.internalServerError;
      await request.response.close();
    }
  }
}

Future<void> _send(HttpRequest request, File file) async {
  final List<int> bytes = await file.readAsBytes();
  request.response.statusCode = HttpStatus.ok;
  request.response.headers.contentType = _contentType(file.path);
  request.response.headers.contentLength = bytes.length;
  request.response.add(bytes);
  await request.response.close();
}

ContentType _contentType(String path) {
  if (path.endsWith('.html')) return ContentType.html;
  if (path.endsWith('.js')) return ContentType('application', 'javascript', charset: 'utf-8');
  if (path.endsWith('.json')) return ContentType.json;
  if (path.endsWith('.png')) return ContentType('image', 'png');
  if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return ContentType('image', 'jpeg');
  if (path.endsWith('.svg')) return ContentType('image', 'svg+xml');
  if (path.endsWith('.css')) return ContentType('text', 'css', charset: 'utf-8');
  if (path.endsWith('.woff2')) return ContentType('font', 'woff2');
  return ContentType.binary;
}
