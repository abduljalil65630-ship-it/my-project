import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProviderServicesPage extends StatefulWidget {
  const ProviderServicesPage({super.key});

  @override
  State<ProviderServicesPage> createState() => _ProviderServicesPageState();
}

class _ProviderServicesPageState extends State<ProviderServicesPage> {
  final supabase = Supabase.instance.client;

  final _nameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  String? selectedCategory;
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> services = [];

  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final cats = await supabase
          .from('categories')
          .select('id,name')
          .order('name');

      final userId = supabase.auth.currentUser!.id;

      final data = await supabase
          .from('provider_services')
          .select('id,name,description,price,category_id,categories(name)')
          .eq('provider_id', userId)
          .order('created_at', ascending: false);

      setState(() {
        categories = List<Map<String, dynamic>>.from(cats);
        services = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      _message('حدث خطأ: $e');
    }
  }

  Future<void> _addService() async {
    if (_nameCtrl.text.trim().isEmpty || selectedCategory == null) {
      _message('أدخل اسم الخدمة واختر الفئة');
      return;
    }

    setState(() => saving = true);

    try {
      final userId = supabase.auth.currentUser!.id;

      await supabase.from('provider_services').insert({
        'provider_id': userId,
        'category_id': selectedCategory,
        'name': _nameCtrl.text.trim(),
        'description': _descriptionCtrl.text.trim(),
        'price': double.tryParse(_priceCtrl.text.trim()),
      });

      _nameCtrl.clear();
      _descriptionCtrl.clear();
      _priceCtrl.clear();

      setState(() {
        selectedCategory = null;
        saving = false;
      });

      await _loadData();

      _message('تمت إضافة الخدمة بنجاح');
    } catch (e) {
      setState(() => saving = false);
      _message('تعذر إضافة الخدمة: $e');
    }
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خدماتي'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'إضافة خدمة جديدة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'اسم الخدمة',
              prefixIcon: Icon(Icons.build),
            ),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: const InputDecoration(
              labelText: 'الفئة',
              prefixIcon: Icon(Icons.category),
            ),
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category['id'].toString(),
                child: Text(category['name'].toString()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => selectedCategory = value);
            },
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _descriptionCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'وصف الخدمة',
              prefixIcon: Icon(Icons.description),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _priceCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'السعر',
              prefixIcon: Icon(Icons.payments),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: saving ? null : _addService,
              child: saving
                  ? const CircularProgressIndicator()
                  : const Text('إضافة الخدمة'),
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'خدماتي الحالية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          if (services.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Text('لم تضف أي خدمة بعد'),
              ),
            ),

          ...services.map(
                (service) => Card(
              child: ListTile(
                leading: const Icon(Icons.build),
                title: Text(service['name'] ?? ''),
                subtitle: Text(
                  '${service['categories']?['name'] ?? ''}\n'
                      '${service['description'] ?? ''}',
                ),
                trailing: Text(
                  service['price'] != null
                      ? '${service['price']}'
                      : 'حسب الاتفاق',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}