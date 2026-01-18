import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../ViewModel/auth_viewmodel.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    // No autenticado -> Mostrar Login Form
    if (!auth.isAuthenticated) {
      return const _LoginForm();
    }

    // Vendedor
    if (auth.user?.userType == 'seller' ||
        auth.user?.userType == 'shop_owner') {
      return _SellerDashboard(auth: auth);
    }

    // Cliente (default)
    return _CustomerDashboard(auth: auth);
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Usamos read para la acción, el watch del padre se encarga de reconstruir
    final auth = context.read<AuthViewModel>();

    final ok = await auth.login(_emailCtrl.text.trim(), _passwordCtrl.text);
    if (!mounted) return;

    if (ok) {
      // No navegamos, el cambio de estado en AuthViewModel hará que Inicio se reconstruya
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Inicio de sesión exitoso')));
    } else {
      final msg = auth.error ?? 'Error al iniciar sesión';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.store, // Icono de la app
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'TiendaSegura',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Ingrese su email';
                            if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            ).hasMatch(v)) {
                              return 'Ingrese un email válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          textCapitalization: TextCapitalization.none,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Ingrese su contraseña';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: auth.isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: auth.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/register'),
                          child: const Text(
                            '¿No tienes cuenta? Registrate aquí',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _Footer(),
    );
  }
}

class _SellerDashboard extends StatelessWidget {
  final AuthViewModel auth;
  const _SellerDashboard({required this.auth});

  @override
  Widget build(BuildContext context) {
    if (!auth.hasShop) {
      return const _RegisterShopForm();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Vendedor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hola, ${auth.user?.name ?? 'Vendedor'}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Botón de Pánico
            SizedBox(
              width: 300,
              height: 70,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('¡ALERTA DE SEGURIDAD!'),
                      content: const Text('Llamando al 911...'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancelar'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.warning_amber_rounded, size: 30),
                label: const Text(
                  'BOTÓN DE PÁNICO 911',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/registrar-producto');
              },
              icon: const Icon(Icons.add),
              label: const Text('Registrar nuevo producto'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función de Pedidos próximamente'),
                  ),
                );
              },
              icon: const Icon(Icons.receipt_long),
              label: const Text('Gestionar Pedidos'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/catalogo');
              },
              icon: const Icon(Icons.list),
              label: const Text('Ver mis productos'),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () => auth.logout(),
              child: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _Footer(),
    );
  }
}

class _CustomerDashboard extends StatelessWidget {
  final AuthViewModel auth;
  const _CustomerDashboard({required this.auth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Cliente')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hola, ${auth.user?.name ?? 'Cliente'}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/catalogo');
              },
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Ver Catálogo'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/carrito');
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Mi Carrito'),
            ),

            const SizedBox(height: 32),
            TextButton(
              onPressed: () => auth.logout(),
              child: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _Footer(),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(height: 8),
          Image(
            image: AssetImage('lib/assets/imgs/logo/logo_gris.webp'),
            height: 40,
          ),
        ],
      ),
    );
  }
}

class _RegisterShopForm extends StatefulWidget {
  const _RegisterShopForm();

  @override
  State<_RegisterShopForm> createState() => _RegisterShopFormState();
}

class _RegisterShopFormState extends State<_RegisterShopForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthViewModel>();
    final success = await auth.createShop(
      _nameCtrl.text.trim(),
      _addressCtrl.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tienda registrada exitosamente')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(auth.error ?? 'Error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar mi Tienda')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Para continuar, registra los datos de tu tienda.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Tienda',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressCtrl,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: auth.isLoading ? null : _submit,
                child: auth.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Registrar Tienda'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => auth.logout(),
                child: const Text('Cancelar / Cerrar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
