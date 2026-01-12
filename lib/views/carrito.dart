import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/carrito_viewmodel.dart';

class CarritoPage extends StatelessWidget {
  const CarritoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carrito = context.watch<CarritoViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            // Logo de la app
            Image.asset(
              'lib/assets/imgs/logo/logo.webp', // <-- cambia por tu logo real
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text(
              'Tiendasegura',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: carrito.items.isEmpty
          ? const Center(
              child: Text('El carrito está vacío'),
            )
          : Column(
              children: [
                // 🧾 LISTA DE PRODUCTOS
                Expanded(
                  child: ListView.builder(
                    itemCount: carrito.items.length,
                    itemBuilder: (context, index) {
                      final carritoItem = carrito.items[index];
                      return ListTile(
                        leading: Image.asset(
                          carritoItem.producto.imagen,
                          width: 50,
                        ),
                        title: Text(carritoItem.producto.nombre),
                        subtitle: Text(
                          'Cantidad: ${carritoItem.cantidad}\n\$${(carritoItem.producto.precio * carritoItem.cantidad).toStringAsFixed(2)}'
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (carritoItem.cantidad > 1) {
                                  carritoItem.cantidad--;
                                } else {
                                  carrito.items.removeAt(index);
                                }
                                carrito.notifyListeners();
                              },
                            ),
                            Text('${carritoItem.cantidad}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                carritoItem.cantidad++;
                                carrito.notifyListeners();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // 💰 BOTÓN GRANDE DE PAGO
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      backgroundColor: const Color(0xFF025E73), // color que pediste
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Por ahora no hace nada
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total a pagar:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '\$${carrito.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
