import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/BlocObserver.dart';

import 'layout/home.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
