import 'package:flutter/material.dart';
import 'package:flutter_bitcoin_ticker/crypto_model.dart';

class PriceOfCryptoWidget extends StatelessWidget {
  const PriceOfCryptoWidget({
    Key key,
    @required this.cryptoPriceModel,
  }) : super(key: key);

  final CryptoPriceModel cryptoPriceModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            '1 ${cryptoPriceModel.cryptoName} = ${cryptoPriceModel.priceValue} ${cryptoPriceModel.fiatName}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
