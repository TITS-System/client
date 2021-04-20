import 'package:client_prototype/order_item.dart';
import 'package:flutter/material.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem? orderItem;
  final Function? removeOrderItem;
  final Function? updSumm;
  const OrderItemWidget({Key? key, this.orderItem, this.removeOrderItem,this.updSumm})
      : super(key: key);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  int _getSumm() {
    return widget.orderItem!.shopItem.price * widget.orderItem!.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Color.fromARGB(255, 255, 105, 0), width: 3),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.orderItem!.shopItem.name),
              Text(widget.orderItem!.quantity.toString()),
              RichText(
                  text: TextSpan(
                      text:  _getSumm().toString() + '₽',
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 105, 0)))),
              IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: () {
                  setState(() {
                    if (widget.orderItem!.quantity == 1) {
                      widget.removeOrderItem!(widget.orderItem!);
                    } else {
                      widget.orderItem!.quantity -= 1;
                      widget.updSumm!();
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  setState(() {
                    widget.orderItem!.quantity += 1;
                    widget.updSumm!();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
