// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This file exists solely to host compiled excerpts for README.md, and is not
// intended for use as an actual example application.

// ignore_for_file: avoid_print

import 'package:listen/listen.dart';

/// Demonstrates [ValueNotifier] usage for README.
// #docregion ValueNotifier
void valueNotifierExample() {
  final counter = ValueNotifier<int>(0);

  counter.addListener(() {
    print('Value changed: ${counter.value}');
  });

  counter.value = 5; // Prints: Value changed: 5
  counter.value = 10; // Prints: Value changed: 10
  counter.value = 10; // Does not print because the value is == 10

  counter.dispose();
}

// #enddocregion ValueNotifier

// #docregion ChangeNotifierClass
/// A [ChangeNotifier] subclass that encapsulates a list of items and notifies
/// listeners whenever items are added or removed.
class ItemListNotifier extends ChangeNotifier {
  final List<String> _items = <String>[];

  /// The unmodifiable list of current items.
  List<String> get items => List<String>.unmodifiable(_items);

  /// Adds an [item] to the list and notifies listeners.
  void addItem(String item) {
    _items.add(item);
    notifyListeners();
  }

  /// Removes an [item] from the list and notifies listeners if it was present.
  void removeItem(String item) {
    if (_items.remove(item)) {
      notifyListeners();
    }
  }
}

// #enddocregion ChangeNotifierClass

/// Demonstrates [ChangeNotifier] usage for README.
// #docregion ChangeNotifierUsage
void changeNotifierExample() {
  final listNotifier = ItemListNotifier();

  listNotifier.addListener(() {
    print('Current items: ${listNotifier.items}');
  });

  listNotifier.addItem('Apple'); // Prints: Current items: [Apple]
  listNotifier.addItem('Banana'); // Prints: Current items: [Apple, Banana]
  listNotifier.removeItem('Apple'); // Prints: Current items: [Banana]

  listNotifier.dispose();
}

// #enddocregion ChangeNotifierUsage

/// Demonstrates [Listenable.merge] usage for README.
// #docregion Merge
void mergeExample() {
  final first = ValueNotifier<String>('Hello');
  final second = ValueNotifier<String>('World');

  final merged = Listenable.merge(<Listenable>[first, second]);

  merged.addListener(() {
    print('Merged listenable triggered: ${first.value} ${second.value}');
  });

  first.value = 'Hi'; // Prints: Merged listenable triggered: Hi World
  second.value = 'Dart'; // Prints: Merged listenable triggered: Hi Dart

  first.dispose();
  second.dispose();
}
// #enddocregion Merge
