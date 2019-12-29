import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bitcoin_ticker/coin_data.dart';
import 'dart:io' show Platform;

import 'package:flutter_bitcoin_ticker/service/network_helper.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency;
  String price;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCurrency = 'USD';
    price = '?';
    getBTCPrice();
  }

  Future<void> getBTCPrice() async {
    var btcValue = await NetworkHelper(cryptoName: 'BTC', fiatName: 'USD')
        .getCryptoToFiatValue();
    setState(() {
      price = btcValue['last'].toString();
      print(price);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $price $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: getPicker()),
        ],
      ),
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else if (Platform.isAndroid) {
      return getDropDownButtons();
    }
  }

  Widget getDropDownButtons() {
    return Container(
      child: DropdownButton<String>(
        value: selectedCurrency,
        items: genereteCurrencyMenu(),
        onChanged: (value) {
          setState(() {
            selectedCurrency = value;
          });
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> genereteCurrencyMenu() {
    List<DropdownMenuItem<String>> menu = [];
    currenciesList.forEach((currency) {
      menu.add(DropdownMenuItem(
        child: Text(currency),
        value: currency,
      ));
    });
    return menu;
  }

  CupertinoPicker iOSPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.blue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
      },
      children: genereteCurrencyMenuIos(),
    );
  }

  List<Widget> genereteCurrencyMenuIos() {
    List<Widget> menu = [];
    currenciesList.forEach((currency) {
      menu.add(Container(
        child: Text(
          currency,
          style: TextStyle(color: Colors.white),
        ),
      ));
    });
    return menu;
  }
}
