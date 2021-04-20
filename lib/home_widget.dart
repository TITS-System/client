import 'package:client_prototype/order_item.dart';
import 'package:client_prototype/order_item_widget.dart';
import 'package:client_prototype/send_order_menu.dart';
import 'package:client_prototype/shop_item.dart';
import 'package:client_prototype/shop_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final LatLng _center = const LatLng(53.25209, 34.37167);
  String pageType = "menu";
  String summStr = "0";

  late List<ShopItem> _shopItems;
  List<ShopItemWidget> _shopItemWidgets = [];

  List<OrderItem> _orders = [];
  List<OrderItemWidget> _orderItemWidgets = [];

  _setShopWidgets() {
    setState(() {
      _shopItemWidgets.clear();
      for (var item in _shopItems) {
        _shopItemWidgets.add(ShopItemWidget(
          key: UniqueKey(),
          shopItem: item,
          addToCart: _addOneToOrder,
        ));
      }
    });
  }

  _setOrderWidgets() {
    setState(() {
      _orderItemWidgets.clear();
      for (var item in _orders) {
        _orderItemWidgets.add(OrderItemWidget(
          key: UniqueKey(),
          orderItem: item,
          removeOrderItem: _removeOrderItem,
          updSumm: _updateSumm,
        ));
      }
    });
    int summ = 0;
    _orders.forEach((element) {
      summ += element.shopItem.price * element.quantity;
    });

    _updateSumm();
    return summ;
  }

  OrderItem _getInvalidOrdedrItem() {
    return OrderItem(ShopItem(-1, -1, '-1', '-1'), -1);
  }

  _addOneToOrder(ShopItem shopItem) {
    print(shopItem.productId);

    var tItem = _orders.firstWhere(
        (e) => e.shopItem.productId == shopItem.productId,
        orElse: _getInvalidOrdedrItem);

    print(tItem.runtimeType);

    if (tItem.shopItem.productId == -1) {
      print('null');
      _orders.add(OrderItem(shopItem, 1));
    } else {
      tItem.quantity += 1;
    }

    _setOrderWidgets();
  }

  _removeOrderItem(OrderItem orderItem) {
    _orders.remove(orderItem);
    _setOrderWidgets();
  }

  _openSendOrderMenu() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SendOrderWidget()));
  }

  _updateSumm() {
    int summ = 0;
    _orders.forEach((element) {
      summ += element.shopItem.price * element.quantity;
    });
    print(summ);
    setState(() {
      summStr = summ.toString();
    });
  }

  @override
  void initState() {
    _shopItems = [
      ShopItem(1, 450, 'Pizza', 'pizza.jpeg'),
      ShopItem(2, 60, 'Coke', 'coke.jpg'),
      ShopItem(3, 160, 'Dodster', 'dodster.jpg'),
    ];

    _setShopWidgets();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: (() {
          switch (pageType) {
            case "menu":
              return <Widget>[
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[] + _shopItemWidgets,
                  ),
                ),
              ];
            case "cart":
              return <Widget>[
                Column(
                  children: <Widget>[] +
                      _orderItemWidgets +
                      <Widget>[
                        RichText(
                            text: TextSpan(
                                text: 'summ:' + summStr + '₽',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 105, 0),
                                    fontSize: 30))),
                        Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: _openSendOrderMenu,
                            child: Text('order'),
                          ),
                        ),
                      ],
                ),
              ];
            default:
              return <Widget>[];
          }
        }()),
      ),
      bottomNavigationBar: new BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.white,
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.restaurant_menu),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  color: (() {
                    if (pageType == "menu") {
                      return Color.fromARGB(255, 255, 105, 0);
                    }
                    return Color.fromARGB(155, 255, 105, 0);
                  }()),
                  onPressed: () {
                    setState(() {
                      pageType = "menu";
                    });
                  },
                ),
                IconButton(
                  iconSize: 30,
                  icon: Icon(Icons.shopping_bag),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  color: (() {
                    if (pageType == "cart") {
                      return Color.fromARGB(255, 255, 105, 0);
                    }
                    return Color.fromARGB(155, 255, 105, 0);
                  }()),
                  onPressed: () {
                    setState(() {
                      pageType = "cart";
                    });
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            )),
      ),
    );
  }
}
