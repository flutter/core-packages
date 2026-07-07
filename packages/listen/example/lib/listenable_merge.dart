// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'package:listen/listen.dart';

void main() {
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
