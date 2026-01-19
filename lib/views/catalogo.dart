import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/producto.dart';
import '../ViewModel/carrito_viewmodel.dart';
import '../ViewModel/auth_viewmodel.dart';
import '../model/API/shop_repository.dart';
import '../model/API/product_repository.dart';
import 'registrar_producto.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  String _searchQuery = '';
  // Cache products to avoid refetching on every rebuild/search
  List<Producto>? _allProducts;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Defer loading until context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  Future<void> _loadProducts() async {
    final auth = context.read<AuthViewModel>();
    // Ensure we have the user's shops
    // If not authenticated or no shops, handle gracefully
    if (!auth.isAuthenticated) {
      setState(() {
        _isLoading = false;
        _error = "No estás autenticado";
      });
      return;
    }

    // Attempt to refresh shop list if empty (optional, but good safety)
    if (auth.shops.isEmpty) {
      await auth.checkSellerStatus();
    }

    if (auth.shops.isEmpty) {
      setState(() {
        _isLoading = false;
        _error = "No tienes una tienda registrada.";
      });
      return;
    }

    // Assuming we fetch products for the FIRST shop in the list for now
    // If multiple shops are supported in UI, we'd need a shop selector.
    // For now, take the first one.
    final shopId = auth.shops.first['_id'];

    if (shopId == null) {
      setState(() {
        _isLoading = false;
        _error = "Error: ID de tienda no encontrado";
      });
      return;
    }

    try {
      final repo = ShopRepository();
      final productsData = await repo.getProductsByShop(shopId);

      // Convert dynamic list to List<Producto>
      final loadedProducts = productsData.map((p) {
        return Producto(
          id: p["_id"]?.toString() ?? '',
          nombre: (p["name"] ?? "Sin nombre").toString(),
          precio: (p["price"] ?? 0).toDouble(),
          imagen: (p["imageUrl"] ?? "").toString(),
        );
      }).toList();

      if (mounted) {
        setState(() {
          _allProducts = loadedProducts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final carrito = context.read<CarritoViewModel>();
    final auth = context.read<AuthViewModel>();

    // Filter Logic
    /*
    List<Producto> filteredProducts = [];
    if (_allProducts != null) {
      if (_searchQuery.isEmpty) {
        filteredProducts = _allProducts!;
      } else {
        filteredProducts = _allProducts!
            .where(
              (p) =>
                  p.nombre.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();
      }
    }
    */

    // Get Shop Name (Assuming first shop for now)
    final shopName = auth.shops.isNotEmpty
        ? (auth.shops.first['name'] ?? 'Mi Tienda')
        : 'Mi Tienda';

    // Grouping logic (Optional) - Backend might not return categories yet.
    // Existing code simulated categories. We can group by a 'category' field if it exists,
    // but for now, let's display them in a single "General" or similar block,
    // OR just a grid if no category field is standard.
    // Since `Producto` model doesn't strictly have 'category', let's use a single list for now to match `ProductosTiendaPage` style but keep the Search layout.

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    'lib/assets/imgs/logo/isologo.webp', // tu logo
                    width: 25,
                    height: 25,
                    errorBuilder: (c, e, s) => const Icon(Icons.store),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Tienda: $shopName",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_box),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/registrar-producto',
                      ).then((_) => _loadProducts()); // Reload on return
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

            // 🔹 Contenido Principal
            Expanded(child: _buildContent(carrito)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(CarritoViewModel carrito) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error: $_error", textAlign: TextAlign.center),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadProducts,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_allProducts == null || _allProducts!.isEmpty) {
      return const Center(child: Text("Tu tienda no tiene productos aún."));
    }

    // Apply filter
    final displayList = _searchQuery.isEmpty
        ? _allProducts!
        : _allProducts!
              .where(
                (p) =>
                    p.nombre.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();

    if (displayList.isEmpty) {
      return const Center(child: Text("No se encontraron productos."));
    }

    // Grid de productos
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: displayList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final producto = displayList[index];
        return Card(
          elevation: 3,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: producto.imagen.startsWith("http")
                        ? Image.network(
                            producto.imagen,
                            fit: BoxFit.cover,
                            errorBuilder: (c, o, s) =>
                                const Icon(Icons.image_not_supported, size: 50),
                          )
                        : Image.asset(
                            producto.imagen,
                            fit: BoxFit.contain,
                            errorBuilder: (c, o, s) =>
                                const Icon(Icons.image_not_supported, size: 50),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      producto.nombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${producto.precio.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Edit Button
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RegistrarProductoPage(producto: producto),
                              ),
                            ).then((_) => _loadProducts());
                          },
                        ),
                        // Delete Button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Confirmar eliminar'),
                                content: Text(
                                  '¿Estás seguro de eliminar "${producto.nombre}"?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true && mounted) {
                              try {
                                final auth = context.read<AuthViewModel>();
                                if (auth.token == null) return;

                                await ProductRepository().deleteProduct(
                                  token: auth.token!,
                                  id: producto.id,
                                );

                                _loadProducts(); // Refresh
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
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
    );
  }
}
