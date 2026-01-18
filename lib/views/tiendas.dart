import 'package:flutter/material.dart';
import '../model/API/shop_repository.dart';
import 'productos_tienda.dart';
import 'package:provider/provider.dart';
import '../ViewModel/carrito_viewmodel.dart';

class TiendasPage extends StatelessWidget {
  const TiendasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ShopRepository();

    return Scaffold(
      appBar: AppBar(title: const Text("Tiendas disponibles")),
      body: FutureBuilder(
        future: repo.getShops(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final shops = snapshot.data as List<dynamic>;

          if (shops.isEmpty) {
            return const Center(child: Text("No hay tiendas registradas"));
          }

          return ListView.builder(
            itemCount: shops.length,
            itemBuilder: (context, index) {
              final shop = shops[index];

              return Card(
                child: ListTile(
                  title: Text(shop["name"] ?? "Tienda sin nombre"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
