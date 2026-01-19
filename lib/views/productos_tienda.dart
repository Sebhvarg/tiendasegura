import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/carrito_viewmodel.dart';
import '../model/API/shop_repository.dart';
import '../model/producto.dart';
import 'carrito.dart';

class ProductosTiendaPage extends StatefulWidget {
  final String shopId;
  final String shopName;

  const ProductosTiendaPage({
    super.key,
    required this.shopId,
    required this.shopName,
  });

  @override
  State<ProductosTiendaPage> createState() => _ProductosTiendaPageState();
}

class _ProductosTiendaPageState extends State<ProductosTiendaPage> {
  String _searchQuery = "";
  List<dynamic>? _cachedProducts;

  @override
  Widget build(BuildContext context) {
    final repo = ShopRepository();
    final carrito = context.watch<CarritoViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        title: Text(widget.shopName),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CarritoPage(shopName: widget.shopName),
                  ),
                ),
              ),
              if (carrito.items.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      carrito.items.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔹 Barra de Búsqueda
          Container(
            padding: const EdgeInsets.all(12.0),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar en ${widget.shopName}...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF025E73)),
                filled: true,
                fillColor: const Color(0xFFF3F6F8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // 🔹 Lista de Productos
          Expanded(
            child: FutureBuilder(
              future: _cachedProducts == null
                  ? repo.getProductsByShop(widget.shopId)
                  : Future.value(_cachedProducts),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _cachedProducts == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                // Cache data
                if (snapshot.hasData && _cachedProducts == null) {
                  _cachedProducts = snapshot.data as List<dynamic>;
                }

                final allProducts = _cachedProducts ?? [];

                if (allProducts.isEmpty) {
                  return const Center(
                    child: Text("Esta tienda no tiene productos"),
                  );
                }

                // Filtrar productos
                final filteredProducts = allProducts.where((p) {
                  final name = (p["name"] ?? "").toString().toLowerCase();
                  return name.contains(_searchQuery);
                }).toList();

                if (filteredProducts.isEmpty) {
                  return const Center(
                    child: Text("No se encontraron productos"),
                  );
                }

                // GRID
                return GridView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.7, // Más alto para el botón mejorado
                  ),
                  itemBuilder: (context, index) {
                    final p = filteredProducts[index];

                    final producto = Producto(
                      id: p["_id"].toString(),
                      nombre: (p["name"] ?? "Sin nombre").toString(),
                      precio: (p["price"] ?? 0).toDouble(),
                      imagen: (p["imageUrl"] ?? "").toString(),
                      shopId: widget.shopId,
                    );

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(0, 4),
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Imagen
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(18),
                                      topRight: Radius.circular(18),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(18),
                                      topRight: Radius.circular(18),
                                    ),
                                    child: producto.imagen.startsWith("http")
                                        ? Image.network(
                                            producto.imagen,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Center(
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                                ),
                                          )
                                        : const Center(
                                            child: Icon(Icons.shopping_bag),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //  Info + Botón
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  producto.nombre,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "\$${producto.precio.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: Color(0xFF025E73),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // MEJORADO: Botón de agregar
                                SizedBox(
                                  width: double.infinity,
                                  height: 40,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF025E73),
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () {
                                      carrito.agregarProducto(producto);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).clearSnackBars();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "${producto.nombre} agregado",
                                          ),
                                          duration: const Duration(
                                            milliseconds: 800,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.add_shopping_cart_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Agregar",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
