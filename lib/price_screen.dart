import 'dart:core';
import 'dart:io';

import 'package:bitcoin_ticker/CoinAPIService.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList[19];
  int selectedCurrencyIndex = 19;
  List<Padding> exchangeRates = [
    Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 BTC = ? USD',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    )
  ];
  @override
  void initState() {
    super.initState();
    setExchangeRates('USD');
  }

  setExchangeRates(String quoteCurrency) async {
    var data = await CoinAPIService.getExchangeRate('BTC', quoteCurrency);
    if (data != null) {
      setState(() {
        exchangeRates = [
          getSingleExchangeRate(
            data['asset_id_base'],
            data['asset_id_quote'],
            (data['rate']).toStringAsFixed(0),
          )
        ];
      });
    }
  }

  Padding getSingleExchangeRate(
          String baseCurrency, String quoteCurrency, String rate) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $baseCurrency = $rate $quoteCurrency',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          /* spread operator:
          add all the exchangeRates elements into this list
           */
          ...exchangeRates,
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIOSPicker() : getPicker(),
          ),
        ],
      ),
    );
  }

  List<Widget> getCurrencyPickerItems() {
    List<Widget> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Center(
        child: Text(currency),
      ));
    }
    return pickerItems;
  }

  List<DropdownMenuItem<String>> getCurrencyListItems() {
    List<DropdownMenuItem<String>> currencyListItems = [];
    for (String currency in currenciesList) {
      currencyListItems.add(DropdownMenuItem(
        key: Key(currency),
        value: currency,
        child: Text(currency),
      ));
    }
    return currencyListItems;
  }

  CupertinoPicker getIOSPicker() => CupertinoPicker(
        itemExtent: 45,
        onSelectedItemChanged: (int selectedIndex) {
          setState(() {
            selectedCurrencyIndex = selectedIndex;
          });
          print(currenciesList[selectedIndex]);
        },
        children: getCurrencyPickerItems(),
      );

  DropdownButton<String> getPicker() => DropdownButton<String>(
        value: selectedCurrency,
        items: getCurrencyListItems(),
        onChanged: (String? value) {
          setState(() {
            selectedCurrency = value!;
          });
          setExchangeRates(value!);
        },
      );
}
