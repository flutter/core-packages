// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'package:listen/listen.dart';

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

void main() {
  final listNotifier = ItemListNotifier();

  listNotifier.addListener(() {
    print('Current items: ${listNotifier.items}');
  });

  listNotifier.addItem('Apple'); // Prints: Current items: [Apple]
  listNotifier.addItem('Banana'); // Prints: Current items: [Apple, Banana]
  listNotifier.removeItem('Apple'); // Prints: Current items: [Banana]

  listNotifier.dispose();
}
