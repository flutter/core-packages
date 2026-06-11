// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'package:listen/listen.dart';

void main() {
  final counter = ValueNotifier<int>(0);

  counter.addListener(() {
    print('Value changed: ${counter.value}');
  });

  counter.value = 5; // Prints: Value changed: 5
  counter.value = 10; // Prints: Value changed: 10
  counter.value = 10; // Does not print because the value is == 10

  counter.dispose();
}
