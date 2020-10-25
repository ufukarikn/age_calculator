import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.brown),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  int selectedDay, selectedMonth, selectedYear;
  int showDay, showMonth, showYear=0;
  Animation yearAnimation;
  Animation monthAnimation;
  Animation dayAnimation;
  AnimationController yearAnimationController;
  AnimationController monthAnimationController;
  AnimationController dayAnimationController;

  @override
  void initState() {
    super.initState();
    //year Animation
    yearAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds:4000));
    yearAnimation = yearAnimationController;
    //month Animation
    monthAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds:4000));
    monthAnimation = monthAnimationController;
    //day Animation
    dayAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds:4000));
    dayAnimation = dayAnimationController;
  }

  @override
  void dispose() {
    yearAnimationController.dispose();
    monthAnimationController.dispose();
    dayAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Age Calculator"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlineButton(
              child: Text("Select your year of birth"),
              borderSide: BorderSide(color: Colors.black, width: 3.0),
              color: Colors.white,
              onPressed: () {
                showPicker();
              },
            ),
            Padding(
              padding: EdgeInsets.all(20),
            ),
            //Text(
               // "${yearAnimation.value.toStringAsFixed(0)} Year ${monthAnimation.value.toStringAsFixed(0)} Month ${dayAnimation.value.toStringAsFixed(0)} Day "),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "${yearAnimation.value.toStringAsFixed(0)} Year ",style: TextStyle(fontWeight: FontWeight.bold) ),
                Text(
                    "${monthAnimation.value.toStringAsFixed(0)} Month ",style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    "${dayAnimation.value.toStringAsFixed(0)} Day ",style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Future showPicker() async {
    DateTime selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    setState(() {
      selectedDay = int.parse(selectedDate.day.toString());
      selectedMonth = int.parse(selectedDate.month.toString());
      selectedYear = int.parse(selectedDate.year.toString());

      int nowDay = int.parse((DateTime.now().day.toString()));
      int nowMonth = int.parse((DateTime.now().month.toString()));
      int nowYear = int.parse((DateTime.now().year.toString()));

      int dayOfMonth = findDays(nowMonth, nowYear);

      if (nowDay - selectedDay >= 0) {
        showDay = (nowDay - selectedDay);
      } else {
        showDay = (nowDay + dayOfMonth - selectedDay);
        nowMonth = nowMonth - 1;
      }

      if (nowMonth - selectedMonth >= 0) {
        showMonth = (nowMonth - selectedMonth);
      } else {
        showMonth = (nowMonth + 12 - selectedMonth);
        nowYear = nowYear - 1;
      }
      showYear = (nowYear - selectedYear);

      yearAnimation =
          Tween<double>(begin: yearAnimation.value, end: showYear.toDouble())
              .animate(CurvedAnimation(
                  curve: Curves.fastOutSlowIn,
                  parent: yearAnimationController));

      monthAnimation =
          Tween<double>(begin: monthAnimation.value, end: showMonth.toDouble())
              .animate(CurvedAnimation(
                  curve: Curves.fastOutSlowIn,
                  parent: monthAnimationController));

      dayAnimation =
          Tween<double>(begin: dayAnimation.value, end: showDay.toDouble())
              .animate(CurvedAnimation(
                  curve: Curves.fastOutSlowIn, parent: dayAnimationController));
    });

    yearAnimation.addListener(() {
      setState(() {});
    });

    yearAnimationController.forward();
    monthAnimation.addListener(() {
      setState(() {});
    });
    monthAnimationController.forward();

    dayAnimation.addListener(() {
      setState(() {});
    });
    dayAnimationController.forward();

  }

  int findDays(int nowMonth, int nowYear) {
    int dayOfMonth;
    if (nowMonth == 1 ||
        nowMonth == 3 ||
        nowMonth == 5 ||
        nowMonth == 7 ||
        nowMonth == 8 ||
        nowMonth == 10 ||
        nowMonth == 12) {
      dayOfMonth = 31;
    } else if (nowMonth == 4 ||
        nowMonth == 6 ||
        nowMonth == 9 ||
        nowMonth == 11) {
      dayOfMonth = 30;
    } else {
      if (nowYear % 4 == 0)
        dayOfMonth = 29;
      else
        dayOfMonth = 28;
    }
    return dayOfMonth;
  }

}
