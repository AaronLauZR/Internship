// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyRate extends StatefulWidget {
  const CurrencyRate({Key? key}) : super(key: key);

  @override
  State<CurrencyRate> createState() => _CurrencyRateState();
}

class _CurrencyRateState extends State<CurrencyRate> {

  //Date Time Variables
  int? selectedYear;
  List<int> yearList = List<int>.generate(10, (i) => DateTime.now().year - i);

  //Currency Variables
  List<double> middleRates = [];
  double highestRate = 0.0;
  double lowestRate = 0.0;
  double averageRate = 0.0;

  //Loading Screen Variables
  bool isLoading = false;

  void currencyRate(int selectedYear) async {

    //Start loading screen
    setState(() {
      isLoading = true;
    });

    //Reset middleRates list
    middleRates.clear();

    //Define sessions and currencyCode
    List<String> sessions = ['0900', '1200', '1700'];
    String currencyCode = "USD";

    //Nested for loop to loop through all the months and days
    for (int month = 1; month <= 12; month++) {
      for (int day = 1; day <= 31; day++) {
        for (int i = 0; i < sessions.length; i++) {
          String session = sessions[i];
          String formattedMonth = month.toString().padLeft(2, '0');
          String formattedDay = day.toString().padLeft(2, '0');
          String apiLink =
              "http://172.16.0.2/bnm-exchange-rate/$selectedYear/$formattedMonth/$formattedDay/$session.json";
          print(apiLink);

          //Make request to API
          try {
            final response = await http.get(Uri.parse(apiLink));
            if (response.statusCode == 200) {
              var jsonData = jsonDecode(response.body);
              for (var item in jsonData) {
                if (item['currency_code'] == currencyCode) {
                  var middleRate = item['rate']['middle_rate'] ?? 0.0;
                  middleRates.add(middleRate);
                  print('Middle Rate: $middleRate');
                }
              }
            } else {
              print('Failed to load data');
            }
          } catch (e) {
            print('Error: $e');
          }
        }
      }
    }

    print('All Middle Rates: $middleRates');

    //End loading screen
    setState(() {
      isLoading = false;
    });

    calculateStatistics();
  }

  void calculateStatistics() {
    if (middleRates.isNotEmpty) {

      //Calculate highest, lowest and average rate with middleRates list
      double highestRate =
          middleRates.reduce((curr, next) => curr > next ? curr : next);
      double lowestRate =
          middleRates.reduce((curr, next) => curr < next ? curr : next);
      double averageRate =
          middleRates.reduce((a, b) => a + b) / middleRates.length;

      //Set state to update the UI
      setState(
        () {
          this.highestRate = highestRate;
          this.lowestRate = lowestRate;
          this.averageRate = averageRate;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Top Navigation Bar
      appBar: AppBar(
        title: const Text(
          'Average Rate',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),

      //Body
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              //DropdownButton for year
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 25),

                //Container to wrap the DropdownButton
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black, width: 2),
                      ),

                      //DropdownButton function to select year
                      child: DropdownButton<int>(
                        value: selectedYear,
                        hint: Text(
                          'Select a Year',
                          style: TextStyle(fontSize: 14),
                        ),
                        underline: Container(),
                        items: yearList.map<DropdownMenuItem<int>>(
                          (int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString(),
                                  style: TextStyle(fontSize: 14)),
                            );
                          },
                        ).toList(),
                        onChanged: (int? newValue) {
                          setState(
                            () {
                              selectedYear = newValue;
                            },
                          );
                          currencyRate(selectedYear!);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              //Show currency code "USD"
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  'Currency Code ~ USD',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              //Show highest, lowest and average rate
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overview',
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Highest Middle Rate : ${highestRate.toStringAsFixed(4)}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        Text(
                          'Lowest  Middle Rate : ${lowestRate.toStringAsFixed(4)}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        Text(
                          'Average Middle Rate : ${averageRate.toStringAsFixed(4)}',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Show loading screen if isLoading is true
          isLoading
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
                 // Show nothing when not loading
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}