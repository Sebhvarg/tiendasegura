import 'package:flutter/material.dart';
import '../model/API/product_repository.dart';

class RegistrarProductoPage extends StatefulWidget {
  const RegistrarProductoPage({super.key});

  @override
  State<RegistrarProductoPage> createState() => _RegistrarProductoPageState();
}

class _RegistrarProductoPageState extends State<RegistrarProductoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _netContentCtrl = TextEditingController();
  final _netUnitCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();
  bool _loading = false;

  final _repo = ProductRepository();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _brandCtrl.dispose();
    _priceCtrl.dispose();
    _netContentCtrl.dispose();
    _netUnitCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    double? price;
    if (_priceCtrl.text.trim().isNotEmpty) {
      price = double.tryParse(_priceCtrl.text.replaceAll(',', '.'));
    }

    try {
      final result = await _repo.createProduct(
        name: _nameCtrl.text.trim(),
        brand: _brandCtrl.text.trim().isEmpty ? null : _brandCtrl.text.trim(),
        price: price,
        netContent: _netContentCtrl.text.trim().isEmpty ? null : _netContentCtrl.text.trim(),
        netContentUnit: _netUnitCtrl.text.trim().isEmpty ? null : _netUnitCtrl.text.trim(),
        imageUrl: _imageUrlCtrl.text.trim().isEmpty ? null : _imageUrlCtrl.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto creado: ${result['name'] ?? result['_id'] ?? ''}')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear producto')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Producto')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingrese un nombre' : null,
                  ),
                  TextFormField(
                    controller: _brandCtrl,
                    decoration: const InputDecoration(labelText: 'Marca (opcional)'),
                  ),
                  TextFormField(
                    controller: _priceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Precio (opcional)'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _netContentCtrl,
                          decoration: const InputDecoration(labelText: 'Cantidad neta (opcional)'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 120,
                        child: TextFormField(
                          controller: _netUnitCtrl,
                          decoration: const InputDecoration(labelText: 'Unidad'),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _imageUrlCtrl,
                    decoration: const InputDecoration(labelText: 'URL imagen (opcional)'),
                  ),
                  const SizedBox(height: 20),
                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _submit,
                          child: const Text('Crear producto'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}