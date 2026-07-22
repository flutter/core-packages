// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'package:listen/listen.dart';

/// A simple counter that extends [ChangeNotifier] to notify listeners
/// whenever its value changes.
class Counter extends ChangeNotifier {
  int _count = 0;

  /// The current count value.
  int get count => _count;

  /// Increments the count by one and notifies listeners.
  void increment() {
    _count++;
    notifyListeners();
  }
}

void main() {
  final counter = Counter();

  counter.addListener(() {
    print('Counter value changed to: ${counter.count}');
  });

  counter.increment(); // Prints: Counter value changed to: 1
  counter.increment(); // Prints: Counter value changed to: 2

  counter.dispose();
}
