import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/carrito_viewmodel.dart';
import 'pago.dart';

class CarritoPage extends StatelessWidget {
  final String shopName;

  const CarritoPage({super.key, this.shopName = "Mi carrito"});

  @override
  Widget build(BuildContext context) {
    final carrito = context.watch<CarritoViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        title: Text(shopName),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: carrito.items.isEmpty
                ? null
                : () {
                    carrito.limpiar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Carrito limpiado ✅")),
                    );
                  },
          ),
        ],
      ),
      body: carrito.items.isEmpty
          ? const Center(child: Text("El carrito está vacío"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: carrito.items.length,
                    itemBuilder: (context, index) {
                      final item = carrito.items[index];

                      final nombre = item.producto.nombre;
                      final precioUnit = item.producto.precio;
                      final cantidad = item.cantidad;
                      final totalProducto = precioUnit * cantidad;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                              color: Colors.black.withOpacity(0.05),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ IMAGEN (lado izquierdo)
                            Container(
                              width: 100,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                child: item.producto.imagen.startsWith("http")
                                    ? Image.network(
                                        item.producto.imagen,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 30,
                                              ),
                                            ),
                                      )
                                    : Image.asset(
                                        item.producto.imagen,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 30,
                                              ),
                                            ),
                                      ),
                              ),
                            ),

                            // ✅ INFORMACIÓN + CONTROLES (Columna Derecha)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Fila Superior: Nombre + Borrar
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            nombre,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            carrito.removerItem(index);
                                          },
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.delete_outline,
                                              color: Colors.redAccent,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 4),
                                    Text(
                                      "\$${precioUnit.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // Fila Inferior: Total + Controles Cantidad
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "\$${totalProducto.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF025E73),
                                          ),
                                        ),

                                        // Controles Cantidad Compactos
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF025E73,
                                            ).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              _qtyBtn(
                                                icon: Icons.remove,
                                                onTap: () {
                                                  carrito.decrementarCantidad(
                                                    index,
                                                  );
                                                },
                                              ),
                                              Container(
                                                width: 32,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "$cantidad",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF025E73),
                                                  ),
                                                ),
                                              ),
                                              _qtyBtn(
                                                icon: Icons.add,
                                                onTap: () {
                                                  carrito.incrementarCantidad(
                                                    index,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ✅ TOTAL A PAGAR (abajo)
                // ✅ TOTAL A PAGAR (abajo)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total a pagar:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "\$${carrito.total.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF025E73),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              if (carrito.items.isEmpty) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PagoPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF025E73),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              "Proceder al Pago",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
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

  // ✅ Botón redondito como en la imagen
  Widget _qtyBtn({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 18, color: const Color(0xFF025E73)),
      ),
    );
  }
}
