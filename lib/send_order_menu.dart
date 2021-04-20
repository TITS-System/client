import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendOrderWidget extends StatefulWidget {
  @override
  _SendOrderWidgetState createState() => _SendOrderWidgetState();
}

class _SendOrderWidgetState extends State<SendOrderWidget> {
  var _controller = TextEditingController();
  var uuid = new Uuid();
  String? _sessionToken = null;
  List<dynamic> _placeList = [];

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
                print('You just selected $selection');
              },
            ),
          ),
        ],
      ),
    );
  }
}
