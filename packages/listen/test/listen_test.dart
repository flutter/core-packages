// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:listen/listen.dart';
import 'package:test/test.dart';

class TestNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }

  bool get isListenedTo => hasListeners;
}

class HasListenersTester<T> extends ValueNotifier<T> {
  HasListenersTester(super.value);
  bool get testHasListeners => hasListeners;
}

class A {
  bool result = false;
  void test() {
    result = true;
  }
}

class B extends A with ChangeNotifier {
  @override
  void test() {
    notifyListeners();
    super.test();
  }
}

class Counter with ChangeNotifier {
  Counter() {
    ChangeNotifier.maybeDispatchObjectCreation(this);
  }

  int get value => _value;
  int _value = 0;
  set value(int value) {
    if (_value != value) {
      _value = value;
      notifyListeners();
    }
  }

  void notify() {
    notifyListeners();
  }
}

void main() {
  final ErrorCallback originalOnError = Listenable.onError;
  Object? lastError;
  ErrorContext? lastContext;

  setUp(() {
    lastError = null;
    lastContext = null;
    Listenable.onError = (Object error, StackTrace? stackTrace, ErrorContext context) {
      lastError = error;
      lastContext = context;
    };
  });
  tearDown(() {
    Listenable.onError = originalOnError;
    if (lastError != null) {
      throw StateError('Unexpected error in test: $lastError');
    }
  });

  test('ChangeNotifier can not dispose in callback', () async {
    final test = TestNotifier();
    var callbackDidFinish = false;
    void foo() {
      test.dispose();
      callbackDidFinish = true;
    }

    test.addListener(foo);

    test.notify();

    expect(lastError, isA<AssertionError>());
    expect(lastContext, ErrorContext.listener);
    expect(lastError.toString(), contains('dispose()'));
    // Make sure it crashes during dispose call.
    expect(callbackDidFinish, isFalse);
    test.dispose();
    lastError = null;
  });

  test('ChangeNotifier', () {
    final log = <String>[];
    void listener() {
      log.add('listener');
    }

    void listener1() {
      log.add('listener1');
    }

    void listener2() {
      log.add('listener2');
    }

    void badListener() {
      log.add('badListener');
      throw ArgumentError();
    }

    final test = TestNotifier();

    final ErrorCallback original = Listenable.onError;
    final List<Object> errors = [];
    Listenable.onError = (Object error, StackTrace? stackTrace, ErrorContext context) {
      errors.add(error);
    };
    addTearDown(() {
      Listenable.onError = original;
    });

    test.addListener(listener);
    test.addListener(listener);
    test.notify();
    expect(log, <String>['listener', 'listener']);
    log.clear();

    test.removeListener(listener);
    test.notify();
    expect(log, <String>['listener']);
    log.clear();

    test.removeListener(listener);
    test.notify();
    expect(log, <String>[]);
    log.clear();

    test.removeListener(listener);
    test.notify();
    expect(log, <String>[]);
    log.clear();

    test.addListener(listener);
    test.notify();
    expect(log, <String>['listener']);
    log.clear();

    test.addListener(listener1);
    test.notify();
    expect(log, <String>['listener', 'listener1']);
    log.clear();

    test.addListener(listener2);
    test.notify();
    expect(log, <String>['listener', 'listener1', 'listener2']);
    log.clear();

    test.removeListener(listener1);
    test.notify();
    expect(log, <String>['listener', 'listener2']);
    log.clear();

    test.addListener(listener1);
    test.notify();
    expect(log, <String>['listener', 'listener2', 'listener1']);
    log.clear();

    test.addListener(badListener);
    test.notify();
    expect(log, <String>['listener', 'listener2', 'listener1', 'badListener']);
    expect(errors.removeAt(0), isA<ArgumentError>());
    log.clear();

    test.addListener(listener1);
    test.removeListener(listener);
    test.removeListener(listener1);
    test.removeListener(listener2);
    test.addListener(listener2);
    test.notify();
    expect(log, <String>['badListener', 'listener1', 'listener2']);
    expect(errors.removeAt(0), isA<ArgumentError>());
    log.clear();
    test.dispose();
  });

  test('Listenable.onError preserves runtime exception types', () {
    final List<Object> errors = [];
    final ErrorCallback original = Listenable.onError;
    Listenable.onError = (Object error, StackTrace? stackTrace, ErrorContext context) {
      errors.add(error);
    };
    addTearDown(() {
      Listenable.onError = original;
    });

    final notifier = TestNotifier();
    notifier.addListener(() {
      throw const FormatException('custom exception');
    });
    notifier.notify();

    expect(errors.single, isA<FormatException>());
    expect((errors.single as FormatException).message, 'custom exception');
  });

  test('Listenable.onError default implementation rethrows and preserves StackTrace', () {
    final stack = StackTrace.fromString('test_stack_trace_marker');
    try {
      originalOnError(const FormatException('bad format'), stack, ErrorContext.listener);
      fail('Expected originalOnError to throw');
    } catch (e, s) {
      expect(e, isA<FormatException>());
      expect(s.toString(), 'test_stack_trace_marker');
    }
  });

  test('Listenable.onError reports correct ErrorContext across all failure types', () {
    final List<ErrorContext?> contexts = [];
    final ErrorCallback original = Listenable.onError;
    Listenable.onError = (Object error, StackTrace? stackTrace, ErrorContext context) {
      contexts.add(context);
    };
    addTearDown(() {
      Listenable.onError = original;
    });

    final notifier = TestNotifier();
    notifier.addListener(() {
      throw Exception('listener exception');
    });
    notifier.notify();
    expect(contexts.single, ErrorContext.listener);
    contexts.clear();

    notifier.dispose();

    notifier.dispose();
    expect(contexts.single, ErrorContext.assertion);
    contexts.clear();

    notifier.notify();
    expect(contexts.single, ErrorContext.assertion);
    contexts.clear();

    notifier.addListener(() {});
    expect(contexts.single, ErrorContext.assertion);
    contexts.clear();

    ChangeNotifier.debugAssertNotDisposed(notifier);
    expect(contexts.single, ErrorContext.assertion);
    contexts.clear();
  });

  test('ChangeNotifier with mutating listener', () {
    final test = TestNotifier();
    final log = <String>[];

    void listener1() {
      log.add('listener1');
    }

    void listener3() {
      log.add('listener3');
    }

    void listener4() {
      log.add('listener4');
    }

    void listener2() {
      log.add('listener2');
      test.removeListener(listener1);
      test.removeListener(listener3);
      test.addListener(listener4);
    }

    test.addListener(listener1);
    test.addListener(listener2);
    test.addListener(listener3);
    test.notify();
    expect(log, <String>['listener1', 'listener2']);
    log.clear();

    test.notify();
    expect(log, <String>['listener2', 'listener4']);
    log.clear();

    test.notify();
    expect(log, <String>['listener2', 'listener4', 'listener4']);
    log.clear();
  });

  test('During notifyListeners, a listener was added and removed immediately', () {
    final source = TestNotifier();
    final log = <String>[];

    void listener3() {
      log.add('listener3');
    }

    void listener2() {
      log.add('listener2');
    }

    void listener1() {
      log.add('listener1');
      source.addListener(listener2);
      source.removeListener(listener2);
      source.addListener(listener3);
    }

    source.addListener(listener1);

    source.notify();

    expect(log, <String>['listener1']);
  });

  test('If a listener in the middle of the list of listeners removes itself, '
      'notifyListeners still notifies all listeners', () {
    final source = TestNotifier();
    final log = <String>[];

    void selfRemovingListener() {
      log.add('selfRemovingListener');
      source.removeListener(selfRemovingListener);
    }

    void listener1() {
      log.add('listener1');
    }

    source.addListener(listener1);
    source.addListener(selfRemovingListener);
    source.addListener(listener1);

    source.notify();

    expect(log, <String>['listener1', 'selfRemovingListener', 'listener1']);
  });

  test('If the first listener removes itself, notifyListeners still notify all listeners', () {
    final source = TestNotifier();
    final log = <String>[];

    void selfRemovingListener() {
      log.add('selfRemovingListener');
      source.removeListener(selfRemovingListener);
    }

    void listener1() {
      log.add('listener1');
    }

    source.addListener(selfRemovingListener);
    source.addListener(listener1);

    source.notifyListeners();

    expect(log, <String>['selfRemovingListener', 'listener1']);
  });

  test('Merging change notifiers', () {
    final source1 = TestNotifier();
    final source2 = TestNotifier();
    final source3 = TestNotifier();
    final log = <String>[];

    final merged = Listenable.merge(<Listenable>[source1, source2]);
    void listener1() {
      log.add('listener1');
    }

    void listener2() {
      log.add('listener2');
    }

    merged.addListener(listener1);
    source1.notify();
    source2.notify();
    source3.notify();
    expect(log, <String>['listener1', 'listener1']);
    log.clear();

    merged.removeListener(listener1);
    source1.notify();
    source2.notify();
    source3.notify();
    expect(log, isEmpty);
    log.clear();

    merged.addListener(listener1);
    merged.addListener(listener2);
    source1.notify();
    source2.notify();
    source3.notify();
    expect(log, <String>['listener1', 'listener2', 'listener1', 'listener2']);
    log.clear();
  });

  test('Merging change notifiers supports any iterable', () {
    final source1 = TestNotifier();
    final source2 = TestNotifier();
    final log = <String>[];

    final merged = Listenable.merge(<Listenable?>{source1, source2});
    void listener() => log.add('listener');

    merged.addListener(listener);
    source1.notify();
    source2.notify();
    expect(log, <String>['listener', 'listener']);
    log.clear();
  });

  test('Merging change notifiers ignores null', () {
    final source1 = TestNotifier();
    final source2 = TestNotifier();
    final log = <String>[];

    final merged = Listenable.merge(<Listenable?>[null, source1, null, source2, null]);
    void listener() {
      log.add('listener');
    }

    merged.addListener(listener);
    source1.notify();
    source2.notify();
    expect(log, <String>['listener', 'listener']);
    log.clear();
  });

  test('Can remove from merged notifier', () {
    final source1 = TestNotifier();
    final source2 = TestNotifier();
    final log = <String>[];

    final merged = Listenable.merge(<Listenable>[source1, source2]);
    void listener() {
      log.add('listener');
    }

    merged.addListener(listener);
    source1.notify();
    source2.notify();
    expect(log, <String>['listener', 'listener']);
    log.clear();

    merged.removeListener(listener);
    source1.notify();
    source2.notify();
    expect(log, isEmpty);
  });

  test('Cannot use a disposed ChangeNotifier except for remove listener', () {
    final source = TestNotifier();
    source.dispose();

    source.addListener(() {});
    expect(lastError.toString(), contains('TestNotifier was used after being disposed.'));
    lastError = null;

    source.dispose();
    expect(lastError.toString(), contains('TestNotifier was used after being disposed.'));
    lastError = null;

    source.notify();
    expect(lastError.toString(), contains('TestNotifier was used after being disposed.'));
    lastError = null;
  });

  test('Can remove listener on a disposed ChangeNotifier', () {
    final source = TestNotifier();
    source.dispose();
    source.removeListener(() {});
  });

  test('Can check hasListener on a disposed ChangeNotifier', () {
    final source = HasListenersTester<int>(0);
    source.addListener(() {});
    expect(source.testHasListeners, isTrue);
    source.dispose();
    expect(source.testHasListeners, isFalse);
  });

  test('Value notifier', () {
    final notifier = ValueNotifier<double>(2.0);

    final log = <double>[];
    void listener() {
      log.add(notifier.value);
    }

    notifier.addListener(listener);
    notifier.value = 3.0;

    expect(log, equals(<double>[3.0]));
    log.clear();

    notifier.value = 3.0;
    expect(log, isEmpty);
  });

  test('Listenable.merge toString', () {
    final source1 = TestNotifier();
    final source2 = TestNotifier();

    var listenableUnderTest = Listenable.merge(<Listenable>[]);
    expect(listenableUnderTest.toString(), 'Listenable.merge([])');

    listenableUnderTest = Listenable.merge(<Listenable?>[null]);
    expect(listenableUnderTest.toString(), 'Listenable.merge([null])');

    listenableUnderTest = Listenable.merge(<Listenable>[source1]);
    expect(listenableUnderTest.toString(), "Listenable.merge([Instance of 'TestNotifier'])");

    listenableUnderTest = Listenable.merge(<Listenable>[source1, source2]);
    expect(
      listenableUnderTest.toString(),
      "Listenable.merge([Instance of 'TestNotifier', Instance of 'TestNotifier'])",
    );

    listenableUnderTest = Listenable.merge(<Listenable?>[null, source2]);
    expect(listenableUnderTest.toString(), "Listenable.merge([null, Instance of 'TestNotifier'])");
  });

  test('Listenable.merge does not leak', () {
    // Regression test for https://github.com/flutter/flutter/issues/25163.

    final source1 = TestNotifier();
    final source2 = TestNotifier();
    void fakeListener() {}

    final listenableUnderTest = Listenable.merge(<Listenable>[source1, source2]);
    expect(source1.isListenedTo, isFalse);
    expect(source2.isListenedTo, isFalse);
    listenableUnderTest.addListener(fakeListener);
    expect(source1.isListenedTo, isTrue);
    expect(source2.isListenedTo, isTrue);

    listenableUnderTest.removeListener(fakeListener);
    expect(source1.isListenedTo, isFalse);
    expect(source2.isListenedTo, isFalse);
  });

  test('hasListeners', () {
    final notifier = HasListenersTester<bool>(true);
    expect(notifier.testHasListeners, isFalse);
    void test1() {}
    void test2() {}
    notifier.addListener(test1);
    expect(notifier.testHasListeners, isTrue);
    notifier.addListener(test1);
    expect(notifier.testHasListeners, isTrue);
    notifier.removeListener(test1);
    expect(notifier.testHasListeners, isTrue);
    notifier.removeListener(test1);
    expect(notifier.testHasListeners, isFalse);
    notifier.addListener(test1);
    expect(notifier.testHasListeners, isTrue);
    notifier.addListener(test2);
    expect(notifier.testHasListeners, isTrue);
    notifier.removeListener(test1);
    expect(notifier.testHasListeners, isTrue);
    notifier.removeListener(test2);
    expect(notifier.testHasListeners, isFalse);
  });

  test('ChangeNotifier as a mixin', () {
    // We document that this is a valid way to use this class.
    final b = B();
    var notifications = 0;
    b.addListener(() {
      notifications += 1;
    });
    expect(b.result, isFalse);
    expect(notifications, 0);
    b.test();
    expect(b.result, isTrue);
    expect(notifications, 1);
  });

  test('Throws FlutterError when disposed and called', () {
    final testNotifier = TestNotifier();
    testNotifier.dispose();

    testNotifier.dispose();

    expect(lastError.toString(), contains('TestNotifier was used after being disposed.'));
    lastError = null;
  });

  test('Calling debugAssertNotDisposed works as intended', () {
    final testNotifier = TestNotifier();
    expect(ChangeNotifier.debugAssertNotDisposed(testNotifier), isTrue);
    testNotifier.dispose();

    ChangeNotifier.debugAssertNotDisposed(testNotifier);

    expect(lastError.toString(), contains('TestNotifier was used after being disposed.'));
    lastError = null;
  });

  test('notifyListener can be called recursively', () {
    final counter = Counter();
    final log = <String>[];

    void listener1() {
      log.add('listener1');
      if (counter.value < 0) {
        counter.value = 0;
      }
    }

    counter.addListener(listener1);
    counter.notify();
    expect(log, <String>['listener1']);
    log.clear();

    counter.value = 3;
    expect(log, <String>['listener1']);
    log.clear();

    counter.value = -2;
    expect(log, <String>['listener1', 'listener1']);
    log.clear();
  });

  test('Remove Listeners while notifying on a list which will not resize', () {
    final test = TestNotifier();
    final log = <String>[];
    final listeners = <VoidCallback>[];

    void autoRemove() {
      // We remove 4 listeners.
      // We will end up with (13-4 = 9) listeners.
      test.removeListener(listeners[1]);
      test.removeListener(listeners[3]);
      test.removeListener(listeners[4]);
      test.removeListener(autoRemove);
    }

    test.addListener(autoRemove);

    // We add 12 more listeners.
    for (var i = 0; i < 12; i++) {
      void listener() {
        log.add('listener$i');
      }

      listeners.add(listener);
      test.addListener(listener);
    }

    final remainingListenerIndexes = <int>[0, 2, 5, 6, 7, 8, 9, 10, 11];
    final List<String> expectedLog = remainingListenerIndexes.map((int i) => 'listener$i').toList();

    test.notify();
    expect(log, expectedLog);

    log.clear();
    // We expect to have the same result after the removal of previous listeners.
    test.notify();
    expect(log, expectedLog);

    // We remove all other listeners.
    for (var i = 0; i < remainingListenerIndexes.length; i++) {
      test.removeListener(listeners[remainingListenerIndexes[i]]);
    }

    log.clear();
    test.notify();
    expect(log, <String>[]);
  });
}
