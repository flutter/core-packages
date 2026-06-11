// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:listen_example/counter.dart' as counter;
import 'package:listen_example/list_notifier.dart' as list_notifier;
import 'package:listen_example/listenable_merge.dart' as listenable_merge;
import 'package:listen_example/main.dart' as basic_main;
import 'package:listen_example/readme_excerpts.dart' as readme_excerpts;
import 'package:listen_example/value_notifier.dart' as value_notifier;
import 'package:test/test.dart';

void main() {
  test('counter example runs without error', () {
    expect(counter.main, returnsNormally);
  });

  test('list notifier example runs without error', () {
    expect(list_notifier.main, returnsNormally);
  });

  test('listenable merge example runs without error', () {
    expect(listenable_merge.main, returnsNormally);
  });

  test('value notifier example runs without error', () {
    expect(value_notifier.main, returnsNormally);
  });

  test('basic main example runs without error', () {
    expect(basic_main.main, returnsNormally);
  });

  group('readme excerpts', () {
    test('valueNotifierExample runs without error', () {
      expect(readme_excerpts.valueNotifierExample, returnsNormally);
    });

    test('changeNotifierExample runs without error', () {
      expect(readme_excerpts.changeNotifierExample, returnsNormally);
    });

    test('mergeExample runs without error', () {
      expect(readme_excerpts.mergeExample, returnsNormally);
    });
  });
}
