import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/auth_viewmodel.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Tienda Segura')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenido a Tienda Segura'),
            const SizedBox(height: 24),
            if (!auth.isAuthenticated) ...[
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text('Registrarme'),
              ),
            ] else ...[
              Text(
                'Hola, ${auth.user?.name.isNotEmpty == true ? auth.user!.name : 'usuario'}',
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => auth.logout(),
                child: const Text('Cerrar sesión'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
