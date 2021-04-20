class ShopItem {
  late int _productId;
  late int _price;
  String _name;
  String _imgPath;

  int get productId => _productId;
  set productId(int val) {
    _productId = val;
  }

  int get price => _price;
  set price(int val) {
    _price = val;
  }

  String get name => _name;
  set name(String val) {
    _name = val;
  }

  String get imgPath => _imgPath;
  set imgPath(String val) {
    _imgPath = val;
  }

  ShopItem(this._productId, this._price, this._name,this._imgPath);
}
