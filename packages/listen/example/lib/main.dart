// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'package:listen/listen.dart';

void main() {
  final counter = ValueNotifier<int>(0);

  counter.addListener(() {
    print('Counter changed to: ${counter.value}');
  });

  counter.value = 1; // Prints: Counter changed to: 1
  counter.value = 2; // Prints: Counter changed to: 2

  counter.dispose();
}
