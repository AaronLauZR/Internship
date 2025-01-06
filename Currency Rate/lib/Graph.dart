// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class Graph extends StatefulWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  //Loading Screen Variables
  bool isLoading = false;

  //Date Time Variables
  int? selectedYear;
  List<int> yearList = List<int>.generate(10, (i) => DateTime.now().year - i);

  //Currency List Variables
  Map<int, double> monthlyAverages = {};

  void currencyRate(int selectedYear) async {

    //Start loading screen
    setState(() {
      isLoading = true;
    });

    //Declare sessions and currencyCode
    List<String> sessions = ['0900', '1200', '1700'];
    String currencyCode = "USD";

    //Nested for loop to loop through all the months and days 
    for (int month = 1; month <= 12; month++) {
      double totalMiddleRate = 0.0;
      int dataCount = 0;

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
                  totalMiddleRate += middleRate;
                  dataCount++;
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

      //Calculate the monthly average
      double monthlyAverage = dataCount > 0 ? totalMiddleRate / dataCount : 0.0;
      monthlyAverages[month] = monthlyAverage;
    }

    //Stop loading screen
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //Top Navigation Bar
      appBar: AppBar(
        title: const Text(
          'Yearly Graph',
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
            children: [

              //Dropdown Button for year
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Column(
                  children: [

                    //Container to wrap the DropdownButton
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
                          setState(() {
                            selectedYear = newValue;
                          });
                          currencyRate(selectedYear!);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              //Show currency code "USD"
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  'Currency Code ~ USD',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              //Let graph fit the empty space in body section
              Expanded(
                //Show the graph for the monthly average
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SfCartesianChart(

                    //Declare X axis
                    primaryXAxis: NumericAxis(
                      title: AxisTitle(
                        text: 'Months',
                        textStyle: TextStyle(fontSize: 12),
                      ),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      interval: 1,
                      minimum: 1,
                      maximum: 12,
                    ),

                    //Declare Y axis
                    primaryYAxis: NumericAxis(
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      interval: 0.5,
                      minimum: 0,
                      maximum: 6.0,
                    ),

                    //Declare the series
                    series: <CartesianSeries>[
                      LineSeries<MapEntry<int, double>, int>(
                        dataSource: monthlyAverages.entries.toList(),
                        xValueMapper: (MapEntry<int, double> entry, _) =>
                            entry.key,
                        yValueMapper: (MapEntry<int, double> entry, _) =>
                            entry.value,
                      )
                    ],
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
                ): const SizedBox.shrink(),
        ],
      ),
    );
  }
}