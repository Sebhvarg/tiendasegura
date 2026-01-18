import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/carrito_viewmodel.dart';

class CarritoPage extends StatelessWidget {
  final String shopName;

  const CarritoPage({
    super.key,
    this.shopName = "Mi carrito",
  });

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
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 12,
                              offset: Offset(0, 4),
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // ✅ IMAGEN (lado izquierdo)
                            Container(
                              width: 135,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
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
                                        errorBuilder: (_, __, ___) {
                                          return const Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 35,
                                            ),
                                          );
                                        },
                                      )
                                    : Image.asset(
                                        item.producto.imagen,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) {
                                          return const Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 35,
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),

                            // ✅ INFORMACIÓN (centro)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nombre,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      "Precio unitario: \$${precioUnit.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      "Total producto: \$${totalProducto.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ✅ CONTROLES (lado derecho)
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 14,
                                top: 14,
                                bottom: 14,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // fila de cantidad + botones
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Cantidad:",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      _iconBtn(
                                        icon: Icons.remove,
                                        onTap: () {
                                          if (item.cantidad > 1) {
                                            item.cantidad--;
                                          } else {
                                            carrito.items.removeAt(index);
                                          }
                                          carrito.notifyListeners();
                                        },
                                      ),

                                      const SizedBox(width: 8),

                                      Container(
                                        width: 32,
                                        height: 32,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: const Color(0xFF025E73),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Text(
                                          "$cantidad",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      _iconBtn(
                                        icon: Icons.add,
                                        onTap: () {
                                          item.cantidad++;
                                          carrito.notifyListeners();
                                        },
                                      ),

                                      const SizedBox(width: 10),

                                      // 🗑 eliminar
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () {
                                          carrito.items.removeAt(index);
                                          carrito.notifyListeners();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ✅ TOTAL A PAGAR (abajo)
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Container(
                    height: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF025E73),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total a pagar:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "\$${carrito.total.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 22,
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

  // ✅ Botón redondito como en la imagen
  static Widget _iconBtn({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFF025E73),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}
