import 'package:client_prototype/order_model.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendOrderWidget extends StatefulWidget {
  final String? orderStr;

  const SendOrderWidget({Key? key, this.orderStr})
      : super(key: key);

  @override
  _SendOrderWidgetState createState() => _SendOrderWidgetState();
}

class _SendOrderWidgetState extends State<SendOrderWidget> {
  var _controller = TextEditingController();
  var uuid = new Uuid();
  String? _sessionToken = null;
  List<dynamic> _placeList = [];
  final addressAdditionalController = TextEditingController();
  int restaurantId = 1;
  String addressStr = "";

  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  void _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getLocationResults(_controller.text);
  }

  void getLocationResults(String input) async {
    String kPLACES_API_KEY = "AIzaSyC1OPHCFm8_Uty6HKqNTCiZyl0rPOUyZRE";
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }


  sendOrder() async {
    setState(() {
      _sessionToken = null;
    });
    final query = addressStr;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    LatLngDto LLd = LatLngDto(
        Lat: first.coordinates.latitude, Lng: first.coordinates.longitude);
    CreateOrderDto COd = CreateOrderDto(
      RestaurantId: restaurantId,
      Content: widget.orderStr!,
      AddressString: addressStr,
      AddressAdditional: addressAdditionalController.text,
      Destination: LLd,
    );

    makeOrder(COd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RichText(
              text: TextSpan(
                  text: 'Enter address:',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 105, 0), fontSize: 30))),
          Container(
            padding: EdgeInsets.all(3),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Color.fromARGB(0, 255, 105, 0),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border:
                  Border.all(color: Color.fromARGB(255, 255, 105, 0), width: 3),
            ),
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                getLocationResults(textEditingValue.text);
                return _placeList.map((e) => e["description"]);
              },
              onSelected: (String selection) {
                setState(() {
                  addressStr = selection;
                });
              },
            ),
          ),
          RichText(
              text: TextSpan(
                  text: 'Address info:',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 105, 0), fontSize: 30))),
          Container(
            padding: EdgeInsets.all(3),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Color.fromARGB(0, 255, 105, 0),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border:
                  Border.all(color: Color.fromARGB(255, 255, 105, 0), width: 3),
            ),
            child: TextField(
              controller: addressAdditionalController,
              decoration: InputDecoration(
                hintText: "Enter",
                border: InputBorder.none,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              sendOrder();
            },
            child: RichText(
                text: TextSpan(
                    text: 'send', style: TextStyle(color: Colors.white))),
          ),
        ],
      ),
    );
  }
}
