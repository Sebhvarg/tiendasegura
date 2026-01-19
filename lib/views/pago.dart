import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/carrito_viewmodel.dart';

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

  void _confirmarPedido(BuildContext context, CarritoViewModel carrito) {
    // Aquí iría la llamada al backend para crear la orden

    // Simulación de éxito
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                carrito.limpiar(); // Limpiar carrito
                Navigator.of(context).pop(); // Cerrar Dialog
                Navigator.of(
                  context,
                ).pop(); // Volver al carrito (que ahora estará vacío)
                Navigator.of(context).pop(); // O volver a la tienda directly
                // O mejor: Navigator.popUntil(context, ModalRoute.withName('/home'));
              },
              child: const Text("Entendido"),
            ),
          ),
        ],
      ),
    );
  }
}
