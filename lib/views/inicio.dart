import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../ViewModel/auth_viewmodel.dart';
import '../ViewModel/carrito_viewmodel.dart';
import '../model/API/product_repository.dart';
import '../model/API/shop_repository.dart';
import '../model/producto.dart';
import 'productos_tienda.dart';
import 'pedidos_cliente.dart';
import 'detalle_producto.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    // No autenticado -> Mostrar Login Form
    if (!auth.isAuthenticated) {
      return const _LoginForm();
    }

    // Vendedor
    if (auth.user?.userType == 'seller' ||
        auth.user?.userType == 'shop_owner') {
      return _SellerDashboard(auth: auth);
    }

    // Cliente (default)
    return _CustomerDashboard(auth: auth);
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Usamos read para la acción, el watch del padre se encarga de reconstruir
    final auth = context.read<AuthViewModel>();

    final ok = await auth.login(_emailCtrl.text.trim(), _passwordCtrl.text);
    if (!mounted) return;

    if (ok) {
      // No navegamos, el cambio de estado en AuthViewModel hará que Inicio se reconstruya
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Inicio de sesión exitoso')));
    } else {
      final msg = auth.error ?? 'Error al iniciar sesión';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.store, // Icono de la app
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'TiendaSegura',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Ingrese su email';
                            if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            ).hasMatch(v)) {
                              return 'Ingrese un email válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          textCapitalization: TextCapitalization.none,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Ingrese su contraseña';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: auth.isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: auth.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/register'),
                          child: const Text(
                            '¿No tienes cuenta? Registrate aquí',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _Footer(),
    );
  }
}

class _SellerDashboard extends StatelessWidget {
  final AuthViewModel auth;
  const _SellerDashboard({required this.auth});

  @override
  Widget build(BuildContext context) {
    if (!auth.hasShop) {
      return const _RegisterShopForm();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Vendedor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hola, ${auth.user?.name ?? 'Vendedor'}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Botón de Pánico
            SizedBox(
              width: 300,
              height: 70,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('¡ALERTA DE SEGURIDAD!'),
                      content: const Text('Llamando al 911...'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancelar'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.warning_amber_rounded, size: 30),
                label: const Text(
                  'BOTÓN DE PÁNICO 911',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/registrar-producto');
              },
              icon: const Icon(Icons.add),
              label: const Text('Registrar nuevo producto'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Función de Pedidos próximamente'),
                  ),
                );
              },
              icon: const Icon(Icons.receipt_long),
              label: const Text('Gestionar Pedidos'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/catalogo');
              },
              icon: const Icon(Icons.list),
              label: const Text('Ver mis productos'),
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () => auth.logout(),
              child: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _Footer(),
    );
  }
}

class _CustomerDashboard extends StatefulWidget {
  final AuthViewModel auth;
  const _CustomerDashboard({required this.auth});

  @override
  State<_CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<_CustomerDashboard> {
  final _productRepo = ProductRepository();
  final _shopRepo = ShopRepository();
  String _searchQuery = "";
  Future<List<dynamic>>? _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productRepo.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(
        title: Text(
          'Hola, ${widget.auth.user?.name ?? 'Cliente'}',
          style: const TextStyle(fontSize: 18),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/carrito'),
            icon: const Icon(Icons.shopping_cart),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'orders') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PedidosClientePage()),
                );
              } else if (value == 'logout') {
                widget.auth.logout();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'orders',
                  child: Row(
                    children: [
                      Icon(Icons.receipt_long, color: Colors.black54),
                      SizedBox(width: 8),
                      Text('Mis Pedidos'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Cerrar Sesión',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Search Bar
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: TextField(
                decoration: InputDecoration(
                  hintText: '¿Qué estás buscando hoy?',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF025E73),
                  ),
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
                onChanged: (val) =>
                    setState(() => _searchQuery = val.toLowerCase()),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Shops Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                "Tiendas Cercanas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 140, // Height for shop cards
              child: FutureBuilder(
                future: _shopRepo.getShops(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final shops = snapshot.data ?? [];
                  if (shops.isEmpty) {
                    return const Center(
                      child: Text("No hay tiendas disponibles"),
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: shops.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      final shop = shops[index];
                      return Container(
                        width: 120, // Card width
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () {
                            if (!mounted) return;
                            context.read<CarritoViewModel>().limpiar();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductosTiendaPage(
                                  shopId: shop["_id"],
                                  shopName: shop["name"] ?? "Tienda",
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).primaryColorLight,
                                    child: const Icon(
                                      Icons.store,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    shop["name"] ?? "Tienda",
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Suggestions Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                "Sugerencias para ti",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            FutureBuilder(
              future: _productsFuture ??= _productRepo.getAllProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  debugPrint("Error fetching products: ${snapshot.error}");
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final allProducts = (snapshot.data as List<dynamic>?) ?? [];
                debugPrint("All products fetched: ${allProducts.length}");

                // Filter by search
                final filtered = allProducts.where((p) {
                  final name = (p['name'] ?? '').toString().toLowerCase();
                  return name.contains(_searchQuery);
                }).toList();

                debugPrint(
                  "Filtered products: ${filtered.length} (Query: '$_searchQuery')",
                );

                if (filtered.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("No se encontraron productos"),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(14),
                  itemCount: filtered.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final p = filtered[index];
                    // Handle shop reference safely
                    final shopRef = p["shop"];
                    final shopId = (shopRef is Map) ? shopRef["_id"] : shopRef;
                    final shopName = (shopRef is Map)
                        ? (shopRef["name"] ?? "Tienda")
                        : "Tienda";

                    // We display the product even if shop is missing, but disable "Add"
                    final hasShop = shopId != null;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                              productData: p,
                              shopName: shopName,
                              shopId: shopId ?? '',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              color: Colors.black12,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child:
                                    (p["imageUrl"] ?? "").toString().startsWith(
                                      "http",
                                    )
                                    ? Image.network(
                                        p["imageUrl"],
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                              Icons.image_not_supported,
                                            ),
                                      )
                                    : const Center(
                                        child: Icon(
                                          Icons.shopping_bag,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p["name"] ?? "Producto",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "\$${(p["price"] ?? 0)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Add to Cart Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 30,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        backgroundColor: Theme.of(
                                          context,
                                        ).primaryColor,
                                      ),
                                      onPressed: () {
                                        final productObj = Producto(
                                          id: p["_id"],
                                          nombre: p["name"] ?? "",
                                          precio: (p["price"] ?? 0).toDouble(),
                                          imagen: (p["imageUrl"] ?? "")
                                              .toString(),
                                          shopId: shopId ?? "",
                                        );
                                        context
                                            .read<CarritoViewModel>()
                                            .agregarProducto(productObj);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${p["name"]} agregado',
                                            ),
                                            duration: const Duration(
                                              seconds: 1,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Agregar",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 80), // Space for footer/fab
          ],
        ),
      ),
      bottomNavigationBar: const _Footer(),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(height: 8),
          Image(
            image: AssetImage('lib/assets/imgs/logo/logo_gris.webp'),
            height: 40,
          ),
        ],
      ),
    );
  }
}

class _RegisterShopForm extends StatefulWidget {
  const _RegisterShopForm();

  @override
  State<_RegisterShopForm> createState() => _RegisterShopFormState();
}

class _RegisterShopFormState extends State<_RegisterShopForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthViewModel>();
    final success = await auth.createShop(
      _nameCtrl.text.trim(),
      _addressCtrl.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tienda registrada exitosamente')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(auth.error ?? 'Error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar mi Tienda')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Para continuar, registra los datos de tu tienda.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Tienda',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressCtrl,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: auth.isLoading ? null : _submit,
                child: auth.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Registrar Tienda'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => auth.logout(),
                child: const Text('Cancelar / Cerrar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
