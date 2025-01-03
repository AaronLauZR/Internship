// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalendarState();
}

class _CalendarState extends State<Calender> {

  //Date and time Variables
  DateTime _dateTime = DateTime.now();
  late String chosenDateText = 'Choose Date';

  //Currency Variables
  List<double> buyingRates = List.filled(3, 0.00);
  List<double> sellingRates = List.filled(3, 0.00);
  List<double> middleRates = List.filled(3, 0.00);

  //API Variables
  late String apiLink;

  void _showDatePicker() {
    //Reset the lists
    buyingRates = List.filled(3, 0.00);
    sellingRates = List.filled(3, 0.00);
    middleRates = List.filled(3, 0.00);

    //Display Calender
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2025))
        .then(
      (value) {
        setState(
          () {
            _dateTime = value!;
            String year = _dateTime.year.toString();
            String month = _dateTime.month.toString().padLeft(2, '0');
            String day = _dateTime.day.toString().padLeft(2, '0');
            List<String> sessions = ['0900', '1200', '1700'];
            chosenDateText = '$day/$month/$year';

            // Loop through the sessions to get 3 API links
            for (int i = 0; i < sessions.length; i++) {
              String session = sessions[i];
              String apiLink =
                  "http://172.16.0.2/bnm-exchange-rate/$year/$month/$day/$session.json";
              print(apiLink);

              // Pass the index to _getCurrencyRate
              _getCurrencyRate(apiLink, i);
            }
          },
        );
      },
    );
  }

  void _getCurrencyRate(String apiLink, int index) async {

    //Declare currencyCode
    String currencyCode = "USD";

    //Make request to API
    try {
      final response = await http.get(Uri.parse(apiLink));

      if (response.statusCode == 200) {
        // Parse JSON response as a list
        List<dynamic> jsonDataList = json.decode(response.body);

        // Iterate through the list (assuming each item is a currency rate)
        for (var jsonData in jsonDataList) {
          // If the currency code is "USD"
          if (jsonData['currency_code'] == currencyCode) {
            setState(
              () {
                // Store the rates in the corresponding lists at the given index
                buyingRates[index] = jsonData['rate']['buying_rate'] ?? "null";
                sellingRates[index] = jsonData['rate']['selling_rate'] ?? "null";
                middleRates[index] = jsonData['rate']['middle_rate'] ?? "null";
              },
            );

            // Print the rates
            print('Buying Rate: ${buyingRates[index]}');
            print('Selling Rate: ${sellingRates[index]}');
            print('Middle Rate: ${middleRates[index]}');
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Top Navigation Bar
      appBar: AppBar(
        title: const Text(
          'Daily Rate',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),

      //Body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          //Date Picker Button
          Padding(
            padding: const EdgeInsets.all(25),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: MaterialButton(
                  onPressed: _showDatePicker, child: Text(chosenDateText)),
            ),

          //Show currency code "USD"
          ),
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

          //Show the buying rate, selling rate and middle rate for 3 sessions through list
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '9:00am',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Buying Rate : ${buyingRates[0].toStringAsFixed(3)}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'Selling Rate : ${sellingRates[0].toStringAsFixed(3)}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'Middle Rate : ${middleRates[0].toStringAsFixed(3)}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '12:00pm',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Buying Rate : ${buyingRates[1].toStringAsFixed(3)}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'Selling Rate : ${sellingRates[1].toStringAsFixed(3)}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'Middle Rate : ${middleRates[1].toStringAsFixed(3)}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '5:00pm',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Buying Rate : ${buyingRates[2].toStringAsFixed(3)}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'Selling Rate : ${sellingRates[2].toStringAsFixed(3)}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'Middle Rate : ${middleRates[2].toStringAsFixed(3)}',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}