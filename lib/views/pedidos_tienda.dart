import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/auth_viewmodel.dart';
import '../model/API/order_repository.dart';

class PedidosTiendaPage extends StatefulWidget {
  final String shopId;
  const PedidosTiendaPage({super.key, required this.shopId});

  @override
  State<PedidosTiendaPage> createState() => _PedidosTiendaPageState();
}

class _PedidosTiendaPageState extends State<PedidosTiendaPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final OrderRepository _orderRepo = OrderRepository();
  List<dynamic> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    if (auth.token == null) return;

    try {
      final orders = await _orderRepo.getOrdersByShop(
        widget.shopId,
        auth.token!,
      );
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cargar pedidos: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateStatus(String orderId, String newStatus) async {
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    try {
      await _orderRepo.updateOrderStatus(orderId, newStatus, auth.token!);
      _fetchOrders(); // Refresh list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pedido actualizado a $newStatus')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  List<dynamic> _filterOrders(String status) {
    return _orders.where((o) => o['status'] == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Pedidos"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pendientes"),
            Tab(text: "Despachados"),
            Tab(text: "Rechazados"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList("Pending", true),
                _buildOrderList(
                  "Shipped",
                  false,
                ), // Assuming 'Shipped' is Dispatched
                _buildOrderList(
                  "Cancelled",
                  false,
                ), // Assuming 'Cancelled' is Rejected
              ],
            ),
    );
  }

  Widget _buildOrderList(String status, bool showActions) {
    final filtered = _filterOrders(status);

    if (filtered.isEmpty) {
      return const Center(child: Text("No hay pedidos en esta categoría"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final order = filtered[index];
        final products = order['products'] as List;
        final client = order['client'];
        final address = order['address'];
        final total = order['totalPrice'];

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pedido #${order['_id'].substring(order['_id'].length - 6)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Cliente: ${client != null ? client['name'] : 'Desconocido'}",
                ),
                Text("Dirección: $address"),
                const Divider(),
                ...products.map(
                  (p) => Text("- ${p['name']} x${p['quantity']}"),
                ),
                const Divider(),
                Text(
                  "Total: \$${total?.toStringAsFixed(2) ?? '0.00'}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                if (showActions) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text("Despachar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () => _updateStatus(order['_id'], "Shipped"),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.close, color: Colors.white),
                        label: const Text("Rechazar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () =>
                            _updateStatus(order['_id'], "Cancelled"),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
