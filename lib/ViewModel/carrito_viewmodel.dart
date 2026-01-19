import 'package:flutter/material.dart';
import '../model/producto.dart';

// 🌟 Nuevo modelo para manejar cantidad de cada producto
class CarritoItem {
  final Producto producto;
  int cantidad;

  CarritoItem({required this.producto, this.cantidad = 1});
}

class CarritoViewModel extends ChangeNotifier {
  final List<CarritoItem> _items = [];

  List<CarritoItem> get items => _items;

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

  void limpiar() {
    _items.clear();
    notifyListeners();
  }

  double get total {
    double suma = 0;
    for (var item in _items) {
      suma += item.producto.precio * item.cantidad; // precio por cantidad
    }
    return suma;
  }

  void incrementarCantidad(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].cantidad++;
      notifyListeners();
    }
  }

  void decrementarCantidad(int index) {
    if (index >= 0 && index < _items.length) {
      if (_items[index].cantidad > 1) {
        _items[index].cantidad--;
        notifyListeners();
      } else {
        removerItem(index);
      }
    }
  }

  void removerItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }
}
