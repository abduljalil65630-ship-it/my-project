import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:muslih/core/theme/app_theme_v2.dart';
import 'package:muslih/features/auth/presentation/providers/auth_providers.dart';
import 'package:muslih/features/market/domain/entities/service_category.dart';
import 'package:muslih/features/market/presentation/providers/request_controller.dart';
import 'package:muslih/core/services/location_service.dart';
import 'package:muslih/l10n/app_localizations.dart';

// --- Request Page v2 -------------------------------------------
class RequestPageV2 extends ConsumerStatefulWidget {
  const RequestPageV2({super.key, required this.providerId});

  final String providerId;

  @override
  ConsumerState<RequestPageV2> createState() => _RequestPageV2State();
}

class _RequestPageV2State extends ConsumerState<RequestPageV2> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  String _categoryId = 'general';
  LatLng? _selectedLocation;
  bool _loading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    final LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerPage()),
    );
    if (result != null) {
      setState(() => _selectedLocation = result);
      final address = await ref.read(locationServiceProvider).getAddressFromLatLng(result);
      _cityCtrl.text = address;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(const S().requestSent)),
      );
      context.pop();
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final lang = const S();
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(lang.requestService)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _categoryId,
                decoration: InputDecoration(
                  labelText: lang.requestService,
                  prefixIcon: Icon(Icons.category, color: color),
                ),
                items: ServiceCategories.all
                    .map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _categoryId = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  labelText: lang.problemTitle,
                  prefixIcon: Icon(Icons.title, color: color),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? lang.required : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: lang.description,
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description, color: color),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? lang.required : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityCtrl,
                      decoration: InputDecoration(
                        labelText: lang.location,
                        prefixIcon: Icon(Icons.location_on, color: color),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? lang.required : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _pickLocation,
                    icon: const Icon(Icons.map),
                    tooltip: 'Pick location',
                    style: IconButton.styleFrom(
                      backgroundColor: color,
                    ),
                  ),
                ],
              ),
              if (_selectedLocation != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'تم تحديد الموقع ✅',
                    style: TextStyle(color: Colors.green[700], fontSize: 12),
                  ),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _submit,
                  icon: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  label: Text(lang.sendRequest),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}