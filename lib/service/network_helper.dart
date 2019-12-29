import 'dart:convert';

import 'package:flutter_bitcoin_ticker/global/constant.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  NetworkHelper({this.cryptoName, this.fiatName});

  final String fiatName;
  final String cryptoName;

  String url;

  Future getCryptoToFiatValue() async {
    url = kBaseCryptoUrl + '$cryptoName$fiatName';
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var decodedData = response.body;

      return jsonDecode(decodedData);
    } else {
      print(response.statusCode);
    }
  }
}
