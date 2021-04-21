import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;

@JsonSerializable()
class LatLngDto {
  LatLngDto({required this.Lat, required this.Lng});

  factory LatLngDto.fromJson(Map<String, dynamic> json) {
    return LatLngDto(
        Lat: (json['Lat'] as num).toDouble(),
        Lng: (json['Lng'] as num).toDouble());
  }

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'Lat': this.Lat, 'Lng': this.Lng};

  final double Lat;
  final double Lng;
}

@JsonSerializable()
class CreateOrderDto {
  CreateOrderDto(
      {required this.RestaurantId,
      required this.Content,
      required this.AddressString,
      required this.AddressAdditional,
      required this.Destination});

  factory CreateOrderDto.fromJson(Map<String, dynamic> json) {
    return CreateOrderDto(
        RestaurantId: json['RestaurantId'] as int,
        Content: json['Content'] as String,
        AddressString: json['AddressString'] as String,
        AddressAdditional: json['AddressAdditional'] as String,
        Destination:
            LatLngDto.fromJson(json['Destination'] as Map<String, dynamic>));
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'RestaurantId': this.RestaurantId,
        'Content': this.Content.toString(),
        'AddressString': this.AddressString,
        'AddressAdditional': this.AddressAdditional,
        'Destination': this.Destination,
      };

  final int RestaurantId;
  final String Content;
  final String AddressString;
  final String AddressAdditional;
  final LatLngDto Destination;
}

Future<void> makeOrder(CreateOrderDto orderDto) async {
  bool trustSelfSigned = true;
  HttpClient httpClient = new HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => trustSelfSigned);
  IOClient ioClient = new IOClient(httpClient);

  print('object test1');
  final response =
      await ioClient.post(Uri.parse('https://192.168.21.102:8443/api/order/create'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: json.encode(orderDto));

  print(response.statusCode);
  print(response.body);

  print('object test2');
}
