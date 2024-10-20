import 'dart:async';
import 'package:flutter/material.dart';

class Transmitter {
  static final List<Widget> _cards = [];
  static Function? _setState;

  static void getSetState(Function func) {
    _setState = func;
  }

  static void addCommand(String? cmd) {
    if(cmd == null) {
      return;
    }

    // TODO process the cmd and add corresponding widget to widget lists.
    _cards.add(Text(cmd));
  }

  static List<Widget> getWidgets() => _cards;
}
