import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:muslih/core/theme/app_theme_v2.dart';
import 'package:muslih/l10n/app_localizations.dart';

// --- Add Service Page (Provider) v2 -------------------------------
class AddServicePageV2 extends ConsumerStatefulWidget {
  const AddServicePageV2({super.key});

  @override
  ConsumerState<AddServicePageV2> createState() => _AddServicePageV2State();
}

class _AddServicePageV2State extends ConsumerState<AddServicePageV2> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String? _selectedCategory;
  List<Map<String, dynamic>> _categories = [];
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await Supabase.instance.client
          .from('categories')
          .select('id,name')
          .order('name');
      setState(() {
        _categories = List<Map<String, dynamic>>.from(cats);
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty || _selectedCategory == null) return;
    setState(() => _saving = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      await Supabase.instance.client.from('provider_services').insert({
        'provider_id': userId,
        'category_id': _selectedCategory,
        'name': _nameCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'price': double.tryParse(_priceCtrl.text.trim()),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تمت إضافة الخدمة بنجاح')),
        );
        _nameCtrl.clear();
        _descCtrl.clear();
        _priceCtrl.clear();
        setState(() => _selectedCategory = null);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text('إضافة خدمة جديدة')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'اسم الخدمة',
                      prefixIcon: Icon(Icons.build, color: color),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'الفئة',
                      prefixIcon: Icon(Icons.category, color: color),
                    ),
                    items: _categories.map((c) {
                      return DropdownMenuItem<String>(
                        value: c['id'].toString(),
                        child: Text(c['name'].toString()),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'وصف الخدمة',
                      prefixIcon: Icon(Icons.description, color: color),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'السعر',
                      prefixIcon: Icon(Icons.payments, color: color),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('إضافة الخدمة',
                              style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}