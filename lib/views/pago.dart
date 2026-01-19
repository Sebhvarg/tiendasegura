import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/carrito_viewmodel.dart';
import '../ViewModel/auth_viewmodel.dart';
import '../model/API/order_repository.dart';

class PagoPage extends StatefulWidget {
  const PagoPage({super.key});

  @override
  State<PagoPage> createState() => _PagoPageState();
}

class _PagoPageState extends State<PagoPage> {
  final _addressCtrl = TextEditingController(text: "Av. Principal 123, Ciudad");
  String _paymentMethod = "Efectivo"; // "Efectivo" | "Tarjeta"

  @override
  Widget build(BuildContext context) {
    final carrito = context.watch<CarritoViewModel>();

    // If cart is empty (e.g. after refresh), maybe pop or show empty state
    // But usually we arrive here with items.

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F8),
      appBar: AppBar(title: const Text("Finalizar Pedido")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📍 SECCIÓN DIRECCIÓN
            const Text(
              "Dirección de Entrega",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _addressCtrl,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: Color(0xFF025E73),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            // 🗺️ MAPA SIMULADO
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage(
                    'lib/assets/imgs/map_placeholder.png',
                  ), // Placeholder or standard map image
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 40, color: Colors.black54),
                  Text(
                    "Mapa Simulado",
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 💳 MÉTODO DE PAGO
            const Text(
              "Método de Pago",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Row(
                      children: [
                        Icon(Icons.money, color: Colors.green),
                        SizedBox(width: 10),
                        Text("Efectivo"),
                      ],
                    ),
                    value: "Efectivo",
                    groupValue: _paymentMethod,
                    onChanged: (val) => setState(() => _paymentMethod = val!),
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Row(
                      children: [
                        Icon(Icons.credit_card, color: Colors.blue),
                        SizedBox(width: 10),
                        Text("Tarjeta Crédito/Débito"),
                      ],
                    ),
                    value: "Tarjeta",
                    groupValue: _paymentMethod,
                    onChanged: (val) => setState(() => _paymentMethod = val!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🧾 RESUMEN DEL PEDIDO
            const Text(
              "Resumen del Pedido",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Lista de items compacta
                  ...carrito.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${item.cantidad}x ${item.producto.nombre}",
                              style: TextStyle(color: Colors.grey.shade800),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "\$${(item.producto.precio * item.cantidad).toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Envío", style: TextStyle(fontSize: 16)),
                      const Text("\$0.00", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${carrito.total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF025E73),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ✅ BOTÓN CONFIRMAR
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica de confirmación
                  _confirmarPedido(context, carrito);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF025E73),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Confirmar Pedido",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarPedido(
    BuildContext context,
    CarritoViewModel carrito,
  ) async {
    final auth = context.read<AuthViewModel>();

    if (!auth.isAuthenticated || auth.user == null || auth.user!.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Error: Usuario no identificado. Por favor inicie sesión nuevamente.",
          ),
        ),
      );
      return;
    }

    if (carrito.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("El carrito está vacío.")));
      return;
    }

    // Assume all items are from the same shop for now, or take the shop of the first item
    final shopId = carrito.items.first.producto.shopId;

    // Prepare products snapshot
    final productsSnapshot = carrito.items.map((item) {
      return {
        "product": item.producto.id,
        "name": item.producto.nombre,
        "price": item.producto.precio,
        "quantity": item.cantidad,
        "image": item.producto.imagen,
      };
    }).toList();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await OrderRepository().createOrder(
        token: auth.token!,
        clientId: auth.user!.id,
        shopId: shopId,
        products: productsSnapshot,
        address: _addressCtrl.text,
        paymentMethod: _paymentMethod,
        totalPrice: carrito.total,
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      // Success Dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 10),
              Text("¡Pedido Exitoso!"),
            ],
          ),
          content: const Text(
            "Tu pedido ha sido registrado y será enviado a la dirección proporcionada.",
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  carrito.limpiar(); // Clear cart
                  Navigator.of(context).pop(); // Close Dialog
                  Navigator.of(context).pop(); // Back to Carrito
                  Navigator.of(context).pop(); // Back to Shop
                },
                child: const Text("Entendido"),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al crear pedido: $e")));
    }
  }
}
