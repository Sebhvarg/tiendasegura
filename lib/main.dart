import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/inicio.dart';
import 'views/inicio_sesion.dart';
import 'views/registro.dart';
import 'ViewModel/auth_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()..loadToken()),
      ],
      child: MaterialApp(
        title: 'Tienda Segura',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 220, 179),
          ),
        ),
        routes: {
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/home': (_) => const Inicio(),
        },
        home: const Inicio(),
      ),
    );
  }
}
