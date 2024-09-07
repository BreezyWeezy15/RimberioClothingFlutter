import 'package:flutter/material.dart';

import '../others/utils.dart';

class QuantityPriceWidget extends StatefulWidget {
  final double price;
  final Function(int, double) onQuantityChanged;

  const QuantityPriceWidget({required this.price, required this.onQuantityChanged, Key? key}) : super(key: key);

  @override
  _QuantityPriceWidgetState createState() => _QuantityPriceWidgetState();
}

class _QuantityPriceWidgetState extends State<QuantityPriceWidget> {
  int quantity = 0;
  double totalPrice = 0.0;

  void _increaseQuantity() {
    setState(() {
      quantity++;
      totalPrice = widget.price * quantity;
    });
    widget.onQuantityChanged(quantity, totalPrice);
  }

  void _decreaseQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
        totalPrice = widget.price * quantity;
      });
      widget.onQuantityChanged(quantity, totalPrice);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: _increaseQuantity,
          icon: const Icon(Icons.add, size: 30, color: Colors.white),
        ),
        Text(quantity.toString(), style: Utils.getBold().copyWith(fontSize: 25, color: Colors.white)),
        IconButton(
          onPressed: _decreaseQuantity,
          icon: const Icon(Icons.remove, size: 30, color: Colors.white),
        ),
        const Spacer(),
        Text('Total: \$${totalPrice.toStringAsFixed(2)}', style: Utils.getBold().copyWith(fontSize: 20, color: Colors.white)),
        const SizedBox(width: 20),
      ],
    );
  }
}
