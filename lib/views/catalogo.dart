import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/producto.dart';
import '../ViewModel/carrito_viewmodel.dart';

class CatalogoPage extends StatelessWidget {
  const CatalogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carrito = context.read<CarritoViewModel>();

    // 🔹 Productos organizados por categoría
    final Map<String, List<Producto>> categorias = {
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
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Tiendasegura',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  // Botón para registrar nuevo producto (temporal)
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
                ],
              ),
            ),

            const Divider(thickness: 2),

            // 🔹 Catálogo por categorías
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: categorias.entries.map((entry) {
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
