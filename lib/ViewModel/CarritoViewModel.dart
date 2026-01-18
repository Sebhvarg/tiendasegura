import 'package:flutter/material.dart';
import '../model/producto.dart';

class CarritoItem {
  final Producto producto;
  int cantidad;

  CarritoItem({required this.producto, this.cantidad = 1});
}

class CarritoViewModel extends ChangeNotifier {
  final List<CarritoItem> _items = [];

  List<CarritoItem> get items => _items;

  void agregarProducto(Producto producto) {
    final index = _items.indexWhere((item) => item.producto.id == producto.id);
    if (index >= 0) {
      _items[index].cantidad++; 
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
      suma += item.producto.precio * item.cantidad;
    }
    return suma;
  }
}
