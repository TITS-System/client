import 'package:client_prototype/shop_item.dart';
import 'package:flutter/material.dart';

class ShopItemWidget extends StatefulWidget {
  final ShopItem? shopItem;
  final Function? addToCart;
  const ShopItemWidget({Key? key, this.shopItem, this.addToCart})
      : super(key: key);

  @override
  _ShopItemWidgetState createState() => _ShopItemWidgetState();
}

class _ShopItemWidgetState extends State<ShopItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Color.fromARGB(255, 255, 105, 0), width: 3),
      ),
      child: Column(
        children: [
          Image.asset(
              'assets/'+widget.shopItem!.imgPath,
              width: 600.0,
              height: 240.0,
              fit: BoxFit.scaleDown,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.shopItem!.name),
              Text(widget.shopItem!.price.toString()+'₽'),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  widget.addToCart!(widget.shopItem);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
