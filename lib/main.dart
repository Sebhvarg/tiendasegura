import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// VIEWS
import 'views/catalogo.dart';
import 'views/carrito.dart';
import 'views/inicio.dart';
import 'views/inicio_sesion.dart';
import 'views/registro.dart';

// VIEWMODELS
import 'ViewModel/auth_viewmodel.dart';
import 'ViewModel/carrito_viewmodel.dart';

// THEME
import 'themes/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => CarritoViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tienda Segura',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,

        // 👉 ENTRAS DIRECTO AL CATÁLOGO
        initialRoute: '/catalogo',

        routes: {
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/home': (_) => const Inicio(),
          '/catalogo': (_) => const CatalogoPage(),
          '/carrito': (_) => const CarritoPage(),
        },
      ),
    );
  }
}
