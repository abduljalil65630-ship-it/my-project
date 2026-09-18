import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:muslih/features/auth/presentation/providers/auth_providers.dart';
import 'package:muslih/features/market/domain/entities/service_category.dart';
import 'package:muslih/features/market/presentation/providers/request_controller.dart';
import 'package:muslih/core/widgets/location_picker.dart';
import 'package:muslih/core/config/supabase_config.dart';

/// صفحة تقديم طلب خدمة من العميل إلى المزوّد.
class RequestPage extends ConsumerStatefulWidget {
  const RequestPage({super.key, required this.providerId});

  final String providerId;

  @override
  ConsumerState<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends ConsumerState<RequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  String _categoryId = 'general';
  LatLng? _selectedLocation;

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
      
      // محاولة جلب اسم العنوان تلقائياً
      final address = await ref.read(locationServiceProvider).getAddressFromLatLng(result);
      _cityCtrl.text = address;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final authState = ref.read(authControllerProvider);
    final user = authState.valueOrNull;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('سجّل الدخول أولاً')),
      );
      return;
    }

    await ref.read(requestControllerProvider.notifier).submit(
          customerId: user.id,
          providerId: widget.providerId,
          categoryId: _categoryId,
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          city: _cityCtrl.text.trim(),
          latitude: _selectedLocation?.latitude,
          longitude: _selectedLocation?.longitude,
        );

    if (!mounted) return;
    final state = ref.read(requestControllerProvider);
    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error.toString())),
      );
    } else if (state.hasValue && state.value != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال الطلب بنجاح!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reqState = ref.watch(requestControllerProvider);
    final isLoading = reqState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('طلب خدمة')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _categoryId,
                decoration: const InputDecoration(
                  labelText: 'نوع الخدمة',
                  prefixIcon: Icon(Icons.category),
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
                decoration: const InputDecoration(
                  labelText: 'عنوان المشكلة',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'اذكر عنوان المشكلة' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'وصف المشكلة',
                  alignLabelWithHint: true,
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'اكتب وصفاً مختصراً' : null,
              ),
              const SizedBox(height: 16),
              
              // حقل الموقع مع زر الخريطة
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityCtrl,
                      decoration: const InputDecoration(
                        labelText: 'العنوان / الحي',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'حدّد موقعك' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _pickLocation,
                    icon: const Icon(Icons.map),
                    tooltip: 'تحديد من الخريطة',
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF1E6B5A),
                    ),
                  ),
                ],
              ),
              
              if (_selectedLocation != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'تم تحديد الإحداثيات بنجاح ✅',
                    style: TextStyle(color: Colors.green[700], fontSize: 12),
                  ),
                ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _submit,
                  icon: const Icon(Icons.send),
                  label: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('إرسال الطلب'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
