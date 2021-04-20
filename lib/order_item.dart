import 'package:client_prototype/shop_item.dart';

class OrderItem {
  late ShopItem _shopItem;
  late int _quantity;

  ShopItem get shopItem => _shopItem;
  set shopItem(ShopItem val) {
    _shopItem = val;
  }

  int get quantity => _quantity;
  set quantity(int val) {
    _quantity = val;
  }

  OrderItem(this._shopItem, this._quantity);
}
