import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/carrito_viewmodel.dart';
import '../model/producto.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> productData;
  final String shopName;
  final String shopId;

  const ProductDetailPage({
    super.key,
    required this.productData,
    required this.shopName,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    final name = productData['name'] ?? 'Producto';
    final price = (productData['price'] ?? 0).toDouble();
    final imageUrl = productData['imageUrl']?.toString() ?? '';
    final brand = productData['brand']?.toString() ?? '';
    final description = productData['description']?.toString() ?? '';
    final netContent = productData['netContent'];
    final netContentUnit = productData['netContentUnit'];

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Container(
              height: 300,
              color: Colors.white,
              child: imageUrl.startsWith('http')
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported,
                        size: 100,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(
                      Icons.shopping_bag,
                      size: 100,
                      color: Colors.grey,
                    ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop Name (Requested Feature)
                  Row(
                    children: [
                      Icon(
                        Icons.store,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        shopName,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Name & Brand
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (brand.isNotEmpty)
                    Text(
                      brand,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),

                  const SizedBox(height: 16),

                  // Price
                  Text(
                    '\$$price',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Description / Details
                  const Text(
                    "Detalles",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (netContent != null && netContentUnit != null)
                    Text("Contenido: $netContent $netContentUnit"),

                  const SizedBox(height: 8),
                  Text(
                    description.isNotEmpty
                        ? description
                        : "Sin descripción disponible.",
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 80), // Space for FAB
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final productObj = Producto(
            id: productData["_id"],
            nombre: name,
            precio: price,
            imagen: imageUrl,
            shopId: shopId,
          );
          context.read<CarritoViewModel>().agregarProducto(productObj);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$name agregado al carrito'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text("Agregar al carrito"),
      ),
    );
  }
}
