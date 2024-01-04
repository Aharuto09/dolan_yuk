import 'package:flutter/material.dart';

import '../models/dolan.dart';

class DolanProvider extends ChangeNotifier {
  List<Dolan> dolans = [];
  get getList => dolans;
  get getLength => dolans.length;
  void addDolan(Dolan item) {
    dolans.add(item);
  }

  void clearDolan() {
    dolans.clear();
  }
}
