import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/producto.dart';
import '../ViewModel/carrito_viewmodel.dart';
import '../ViewModel/auth_viewmodel.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final carrito = context.read<CarritoViewModel>();
    final auth = context.read<AuthViewModel>();

    // 🔹 Productos organizados por categoría (Simulados)
    // En una app real esto vendría del ViewModel/API
    final Map<String, List<Producto>> allCategorias = {
      'Bebidas': [
        Producto(
          id: '1',
          nombre: 'Coca Cola',
          precio: 1.25,
          imagen: 'lib/assets/imgs/coca.png',
        ),
        Producto(
          id: '4',
          nombre: 'Agua',
          precio: 0.60,
          imagen: 'lib/assets/imgs/agua.png',
        ),
      ],
      'Snacks': [
        Producto(
          id: '2',
          nombre: 'Ruffles',
          precio: 0.75,
          imagen: 'lib/assets/imgs/ruffles.png',
        ),
        Producto(
          id: '3',
          nombre: 'Salticas',
          precio: 0.50,
          imagen: 'lib/assets/imgs/salticas.png',
        ),
      ],
    };

    // Lógica de filtrado
    Map<String, List<Producto>> filteredCategorias = {};
    if (_searchQuery.isEmpty) {
      filteredCategorias = allCategorias;
    } else {
      allCategorias.forEach((key, value) {
        final filteredProds = value
            .where(
              (p) =>
                  p.nombre.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();
        if (filteredProds.isNotEmpty) {
          filteredCategorias[key] = filteredProds;
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Logo y título
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Image.asset(
                    'lib/assets/imgs/logo/isologo.webp', // tu logo
                    width: 25,
                    height: 25,
                    errorBuilder: (c, e, s) => const Icon(Icons.store),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Tiendasegura',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  // Botón para registrar nuevo producto (temporal/demo)
                  IconButton(
                    icon: const Icon(Icons.add_box),
                    onPressed: () {
                      Navigator.pushNamed(context, '/registrar-producto');
                    },
                  ),
                  // Botón carrito en el AppBar estilo
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.pushNamed(context, '/carrito');
                    },
                  ),
                  // Botón Cerrar Sesión
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    tooltip: 'Cerrar Sesión',
                    onPressed: () {
                      auth.logout();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),

            // 🔹 Barra de Búsqueda
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar productos...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            const Divider(thickness: 2),

            // 🔹 Catálogo por categorías
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: filteredCategorias.entries.map((entry) {
                  final categoria = entry.key;
                  final productos = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre de la categoría
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          categoria,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Grid de productos de esa categoría
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: productos.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                        itemBuilder: (context, index) {
                          final producto = productos[index];
                          return Card(
                            elevation: 3,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    producto.imagen,
                                    fit: BoxFit.contain,
                                    errorBuilder: (c, o, s) => const Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        producto.nombre,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${producto.precio.toStringAsFixed(2)}',
                                      ),
                                      const SizedBox(height: 6),
                                      ElevatedButton(
                                        onPressed: () {
                                          carrito.agregarProducto(producto);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Producto agregado al carrito',
                                              ),
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                        child: const Text('Agregar'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
