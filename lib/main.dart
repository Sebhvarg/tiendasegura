import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// VIEWS
import 'views/catalogo.dart';
import 'views/carrito.dart';
import 'views/inicio.dart';
import 'views/inicio_sesion.dart';
import 'views/registro.dart';
import 'views/registrar_producto.dart';
import 'views/tiendas.dart';

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
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => CarritoViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tienda Segura',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es', ''), Locale('en', '')],

        initialRoute: '/home',

        routes: {
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/home': (_) => const Inicio(),
          '/tiendas': (_) => const TiendasPage(),
          '/catalogo': (_) => const CatalogoPage(),
          '/registrar-producto': (_) => const RegistrarProductoPage(),
          '/carrito': (_) => const CarritoPage(),
        },
      ),
    );
  }
}
