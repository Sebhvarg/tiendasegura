import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/auth_viewmodel.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _date_of_birthCtrl = TextEditingController();
  String? _selectedUserType;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _date_of_birthCtrl.dispose();
    _selectedUserType = null;
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final nameVal = _nameCtrl.text.trim();
    final lastVal = _lastNameCtrl.text.trim();

    // Genera el nombre de usuario
    final n = nameVal.replaceAll(' ', '').toLowerCase();
    final l = lastVal.replaceAll(' ', '').toLowerCase();
    final first3 = n.length >= 3 ? n.substring(0, 3) : n.padRight(3, 'X');
    final last2 = l.length >= 2 ? l.substring(0, 2) : l.padRight(2, 'X');
    final randomPart = Random().nextInt(1000).toString().padLeft(3, '0');
    final generatedUsername = '$first3$last2$randomPart';

    final auth = context.read<AuthViewModel>();
    final ok = await auth.register(
      name: nameVal,
      lastName: lastVal,
      username: generatedUsername,
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      phone: _phoneCtrl.text.isEmpty ? null : _phoneCtrl.text.trim(),
      address: _addressCtrl.text.isEmpty ? null : _addressCtrl.text.trim(),
      dateOfBirth: _date_of_birthCtrl.text.isEmpty
          ? null
          : _date_of_birthCtrl.text.trim(),
      userType: _selectedUserType!,
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registro exitoso')));
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      final msg = auth.error ?? 'Error al registrar';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[A-Za-záéíóúÁÉÍÓÚñÑ\s]'),
                  ),
                ],
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  if (!RegExp(r'^[A-Za-záéíóúÁÉÍÓÚñÑ\s]{3,20}$').hasMatch(v)) {
                    return 'Ingrese un nombre válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _lastNameCtrl,
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(20),
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[A-Za-záéíóúÁÉÍÓÚñÑ\s]'),
                  ),
                ],
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  if (!RegExp(r'^[A-Za-záéíóúÁÉÍÓÚñÑ\s]{3,20}$').hasMatch(v)) {
                    return 'Ingrese un apellido válido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 8),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),

                textCapitalization: TextCapitalization.none,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  if (!RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  ).hasMatch(v)) {
                    return 'Ingrese un email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  if (!RegExp(
                    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                  ).hasMatch(v)) {
                    return 'La contraseña debe contener al menos 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  if (!RegExp(r'^\d{10}$').hasMatch(v)) {
                    return 'Ingrese un teléfono válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _addressCtrl,
                decoration: const InputDecoration(labelText: 'Dirección'),
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[A-Za-z0-9áéíóúÁÉÍÓÚñÑ\s,#.-]'),
                  ),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  if (!RegExp(r'^[A-Za-záéíóúÁÉÍÓÚñÑ\s]{3,50}$').hasMatch(v)) {
                    return 'Ingrese una dirección válida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _date_of_birthCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Fecha de nacimiento',
                  hintText: 'YYYY-MM-DD',
                  suffixIcon: Icon(Icons.calendar_today),
                ),

                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000, 1, 1),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    locale: const Locale('es', ''), // Opcional: español
                  );
                  if (picked != null) {
                    _date_of_birthCtrl.text =
                        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                  }
                },
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedUserType,
                hint: const Text('Tipo de usuario'),
                onChanged: (value) {
                  setState(() {
                    _selectedUserType = value;
                  });
                },
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  return null;
                },
                items: const [
                  DropdownMenuItem(value: 'customer', child: Text('Cliente')),
                  DropdownMenuItem(
                    value: 'seller',
                    child: Text('Dueño de tienda'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Registrarme'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            // insterar imagen
            SizedBox(height: 8),
            Image(
              image: AssetImage('lib/assets/imgs/logo/logo_gris.webp'),
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
