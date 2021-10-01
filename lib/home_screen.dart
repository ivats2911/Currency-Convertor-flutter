// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'dart:convert';

import 'package:currency_convertor/models/country.dart';
import 'package:currency_convertor/rep/convert_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Country fromCountry = datas[0];
  Country toCountry = datas[1];
  double value = 1;
  late Future<double> resFuture;
  @override
  void initState() {
    super.initState();
    _requestConvert();
  }

  _requestConvert() {
    resFuture = ConvertRepo().convert(
      fromCurr: fromCountry.currency,
      toCurr: toCountry.currency,
      value: value,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      // ignore: duplicate_ignore
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        // ignore: prefer_const_constructors
        title: Center(
          child: Text(
            'CURRENCY CONVERTER',
            // ignore: prefer_const_constructors
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildCurrencyView(fromCountry, false),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.indigo.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3))
                      ]),
                  child: Center(
                    child: Text(
                      '=',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      final temp = fromCountry;
                      fromCountry = toCountry;
                      toCountry = temp;
                      _requestConvert();
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.indigo[50],
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.indigo),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Image.asset(
                            'assests/images/switch.png',
                            height: 30,
                          ),
                          Text(
                            'Switch Currencies',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            FutureBuilder<double>(
                future: resFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _buildCurrencyView(toCountry, true,
                        res: snapshot.data);
                  }
                  return SizedBox.shrink();
                }),
          ],
        ),
      ),
    );
  }

  Container _buildCurrencyView(
      Country country, bool isDestination, double res) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.indigo.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 3))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => _buildMenuCurrency(isDestination),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      country.urlFlag,
                      height: 30,
                      width: 40,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(country.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w600)),
                        Text(country.currency,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            TextFormField(
              key: isDestination ? Key(res.toString()) : Key(value.toString()),
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              initialValue: isDestination ? res.toString() : value.toString(),
              onFieldSubmitted: (val) {
                if (double.parse(val) != null) {
                  setState(() {
                    value = double.parse(val);
                    print(value);
                    _requestConvert();
                  });
                }
              },
              decoration: InputDecoration(
                  hintText: '0.0',
                  enabled: !isDestination,
                  suffixIcon: Text(
                    country.currency,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  suffixIconConstraints:
                      BoxConstraints(minWidth: 0, minHeight: 0)),
            )
          ],
        ),
      ),
    );
  }

  _buildMenuCurrency(bool isDestination) {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => CupertinoActionSheet(
              actions: _buildListActions(
                onPressed: (index) {
                  setState(() {
                    isDestination
                        ? toCountry = datas[index]
                        : fromCountry = datas[index];
                    _requestConvert();
                    Navigator.pop(context);
                  });
                },
              ),
              cancelButton: CupertinoActionSheetAction(
                  child: Text('Cancel'),
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context)),
            ));
  }

  List<Widget> _buildListActions({Function(int)? onPressed}) {
    var listActions = <Widget>[];
    for (var i = 0; i < datas.length; i++) {
      listActions.add(CupertinoActionSheetAction(
          onPressed: () => onPressed!(i), child: Text(datas[i].name)));
    }
    return listActions;
  }
}
