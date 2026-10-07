import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/services/session_store.dart';
import '../../shell/presentation/home_shell.dart';
import 'delivery_address_screen.dart';

/// Blueprint `Location Permission`.
///
/// Controls, exactly as wired:
///   * `Use current location`   -> requests permission, sets GPS coordinates
///   * `Enter address manually` -> opens `Delivery Address`
class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  static const String routeName = '/location-permission';

  @override
  State<LocationPermissionScreen> createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool _busy = false;
  String? _error;

  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const HomeShell()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are turned off. Enable them in system settings.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied. You can enter your address instead.');
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permission is blocked for this app. Enable it in settings, '
          'or enter your address instead.',
        );
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      await SessionStore.saveCurrentLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      if (!mounted) return;
      _goHome();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: <Widget>[
              const Spacer(flex: 3),
              Container(
                width: 104,
                height: 104,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F1F3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  size: 46,
                  color: Color(0xFF111114),
                ),
              ),
              const SizedBox(height: 36),
              const Text(
                'Set your delivery location',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF111114),
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Allow location for accurate delivery estimates. '
                'We only use it to show stores that deliver to you.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Color(0xFF8A8A93), height: 1.45),
              ),
              if (_error != null) ...<Widget>[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDECEC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: Color(0xFFB91C1C)),
                  ),
                ),
              ],
              const Spacer(flex: 3),
              FilledButton(
                onPressed: _busy ? null : _useCurrentLocation,
                child: _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Use current location'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _busy
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const DeliveryAddressScreen(),
                          ),
                        );
                      },
                child: const Text(
                  'Enter address manually',
                  style: TextStyle(
                    color: Color(0xFF111114),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
