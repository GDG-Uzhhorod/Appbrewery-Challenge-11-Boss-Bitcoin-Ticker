import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bitcoin_ticker/coin_data.dart';
import 'package:flutter_bitcoin_ticker/crypto_model.dart';
import 'package:flutter_bitcoin_ticker/global/price_of_crypto_widget.dart';
import 'dart:io' show Platform;

import 'package:flutter_bitcoin_ticker/service/network_helper.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency;
  String priceBTC;
  String btcKey = 'BTC';
  bool _loadCryptodata = true;
  List<Widget> currencyList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCurrency = currenciesList.first;

    generateListOfCryptoPrice();
  }

  Future<void> getPrice(String crypto, String fiat) async {
    var btcValue = await NetworkHelper(cryptoName: btcKey, fiatName: fiat)
        .getCryptoToFiatValue();
    setState(() {
      priceBTC = btcValue['last'].toString();
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
          _loadCryptodata
              ? Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: currencyList,
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

  Future<void> loadNewOne(String selectedNewCurrency) async {
    priceBTC = '?';
    selectedCurrency = selectedNewCurrency;

    await generateListOfCryptoPrice();
  }

  Widget getPicker() {
    if (Platform.isAndroid) {
      return iOSPicker();
    } else if (Platform.isIOS) {
      return getDropDownButtons();
    }
  }

  Widget getDropDownButtons() {
    return Container(
      child: DropdownButton<String>(
        value: selectedCurrency,
        items: genereteCurrencyMenu(),
        onChanged: (value) {
          loadNewOne(value);
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
        loadNewOne(currenciesList[selectedIndex]);
      },

      children: genereteCurrencyMenuIos(),
    );
  }

  List<Widget> genereteCurrencyMenuIos() {
    List<Widget> menu = [];
    currenciesList.forEach((currency) {
      menu.add(Container(
        child: Center(
          child: Text(
            currency,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ));
    });
    return menu;
  }

  Future generateListOfCryptoPrice() async {
    setState(() {
      _loadCryptodata = true;
    });
    currencyList = [];

     cryptoList.forEach((value) async {
      var price =
          await NetworkHelper(cryptoName: value, fiatName: selectedCurrency)
              .getCryptoToFiatValue();

      CryptoPriceModel cryptoPriceModel = CryptoPriceModel(
          fiatName: selectedCurrency,
          cryptoName: value,
          priceValue: price['last'].toString());
      setState(() {
        _loadCryptodata = false;
        currencyList.add(PriceOfCryptoWidget(
          cryptoPriceModel: cryptoPriceModel,
        ));
      });

    });
  }
}
