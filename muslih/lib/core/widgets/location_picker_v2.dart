import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:muslih/core/theme/app_theme_v2.dart';
import 'package:muslih/core/services/location_service.dart';
import 'package:muslih/core/config/supabase_config.dart';
import 'package:muslih/l10n/app_localizations.dart';

// --- Location Picker v2 -------------------------------
class LocationPickerPageV2 extends ConsumerStatefulWidget {
  const LocationPickerPageV2({super.key});

  @override
  ConsumerState<LocationPickerPageV2> createState() => _LocationPickerPageV2State();
}

class _LocationPickerPageV2State extends ConsumerState<LocationPickerPageV2> {
  LatLng? _selectedPosition;
  GoogleMapController? _mapController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    final locationService = ref.read(locationServiceProvider);
    final position = await locationService.getCurrentLocation();

    if (position != null) {
      setState(() {
        _selectedPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } else {
      setState(() {
        _selectedPosition = const LatLng(15.3694, 44.1910);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = const S();
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('حدّد موقع الخدمة'),
        actions: [
          if (_selectedPosition != null)
            TextButton(
              onPressed: () => Navigator.pop(context, _selectedPosition),
              child: Text('تأكيد', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedPosition!,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  onTap: (position) {
                    setState(() => _selectedPosition = position);
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedPosition!,
                    ),
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('اضغط على الخريطة لتحديد الموقع بدقة',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, _selectedPosition),
                            child: Text('تأكيد الموقع المختار'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}