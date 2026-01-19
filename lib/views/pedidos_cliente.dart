import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/auth_viewmodel.dart';
import '../model/API/order_repository.dart';

class PedidosClientePage extends StatefulWidget {
  const PedidosClientePage({super.key});

  @override
  State<PedidosClientePage> createState() => _PedidosClientePageState();
}

class _PedidosClientePageState extends State<PedidosClientePage> {
  final OrderRepository _orderRepo = OrderRepository();
  List<dynamic> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    if (auth.token == null || auth.user?.clientId == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final orders = await _orderRepo.getOrdersByClient(
        auth.user!.clientId!,
        auth.token!,
      );
      // Sort by date descending
      orders.sort((a, b) {
        final da = DateTime.tryParse(a['createdAt'] ?? '') ?? DateTime(0);
        final db = DateTime.tryParse(b['createdAt'] ?? '') ?? DateTime(0);
        return db.compareTo(da);
      });

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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Shipped':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'Pending':
        return 'Pendiente';
      case 'Shipped':
        return 'Enviado';
      case 'Cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(title: const Text("Mis Pedidos")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
          ? const Center(child: Text("No tienes pedidos realizados."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                final products = order['products'] as List;
                final total = order['totalPrice'];
                final status = order['status'] ?? 'Pending';
                final date = order['createdAt'] != null
                    ? order['createdAt'].toString().substring(0, 10)
                    : '';

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Pedido #${order['_id'].substring(order['_id'].length - 6)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getStatusColor(status),
                                ),
                              ),
                              child: Text(
                                _translateStatus(status),
                                style: TextStyle(
                                  color: _getStatusColor(status),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Fecha: $date",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const Divider(),
                        ...products.map(
                          (p) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Text(
                                  "- ${p['name']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                Text("x${p['quantity']}"),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "\$${total?.toStringAsFixed(2) ?? '0.00'}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
