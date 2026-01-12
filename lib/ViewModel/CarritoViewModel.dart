import 'package:flutter/material.dart';
import '../model/producto.dart';

/// 🌟 Clase para almacenar un producto con su cantidad en el carrito
class CarritoItem {
  final Producto producto;
  int cantidad;

  CarritoItem({required this.producto, this.cantidad = 1});
}

/// 🌟 ViewModel del carrito
class CarritoViewModel extends ChangeNotifier {
  final List<CarritoItem> _items = [];

  /// Lista de productos en el carrito con su cantidad
  List<CarritoItem> get items => _items;

  /// Agrega un producto al carrito
  void agregarProducto(Producto producto) {
    // Revisar si el producto ya existe en el carrito
    final index = _items.indexWhere((item) => item.producto.id == producto.id);
    if (index >= 0) {
      _items[index].cantidad++; // aumentar cantidad
    } else {
      _items.add(CarritoItem(producto: producto, cantidad: 1));
    }
    notifyListeners();
  }

  /// Limpiar el carrito
  void limpiar() {
    _items.clear();
    notifyListeners();
  }

  /// Total del carrito (precio * cantidad)
  double get total {
    double suma = 0;
    for (var item in _items) {
      suma += item.producto.precio * item.cantidad;
    }
    return suma;
  }
}
