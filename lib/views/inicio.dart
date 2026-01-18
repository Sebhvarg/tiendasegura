import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/auth_viewmodel.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    // No autenticado
    if (!auth.isAuthenticated) {
      return const _UnauthenticatedView();
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

class _UnauthenticatedView extends StatelessWidget {
  const _UnauthenticatedView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.person,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bienvenido a TiendaSegura',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: const Text('Iniciar sesión'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  child: const Text('Registrarse'),
                ),
              ],
            ),
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
              width: 200,
              height: 50,
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
