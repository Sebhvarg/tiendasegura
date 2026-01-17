import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/auth_viewmodel.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!auth.isAuthenticated) ...[
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.person,
                        size: 48,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Contraseña'),
                      ),

                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/login');
                        },
                        child: const Text('Iniciar sesión'),
                      ),
                      const SizedBox(height: 8),

                      const Text(
                        '¿No tienes una cuenta?',
                        textAlign: TextAlign.center,
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
            ] else ...[
              Text(
                'Hola, ${auth.user?.name.isNotEmpty == true ? auth.user!.name : 'usuario'}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              if (auth.user?.userType == 'shop_owner') ...[
                const Text(
                  'Panel de Vendedor',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/registrar-producto');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Registrar nuevo producto'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implementar vista de 'Mis productos'
                    Navigator.of(context).pushNamed('/catalogo');
                  },
                  icon: const Icon(Icons.list),
                  label: const Text('Ver mis productos'),
                ),
              ] else ...[
                const Text(
                  'Panel de Cliente',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
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
              ],
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => auth.logout(),
                child: const Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ],
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
