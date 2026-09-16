// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

import 'test_utils.dart';

void testVector2OutParameters() {
  final a = Vector2(3.0, -4.0);
  final b = Vector2(-1.0, 2.0);
  final out = Vector2.zero();

  expect(identical(a.normalizeInto(out), out), isTrue);
  relativeTest(out, Vector2(0.6, -0.8));
  relativeTest(a, Vector2(3.0, -4.0));

  Vector2.zero().normalizeInto(out);
  relativeTest(out, Vector2.zero());

  expect(identical(a.copyInto(out), out), isTrue);
  relativeTest(out, a);

  Vector2.min(a, b, out);
  relativeTest(out, Vector2(-1.0, -4.0));

  Vector2.max(a, b, out);
  relativeTest(out, Vector2(3.0, 2.0));

  Vector2.mix(a, b, 0.25, out);
  relativeTest(out, Vector2(2.0, -2.5));
}

void testVector3OutParameters() {
  final a = Vector3(2.0, -3.0, 6.0);
  final b = Vector3(-1.0, 4.0, 2.0);
  final out = Vector3.zero();

  expect(identical(a.normalizeInto(out), out), isTrue);
  relativeTest(out, Vector3(2.0 / 7.0, -3.0 / 7.0, 6.0 / 7.0));
  relativeTest(a, Vector3(2.0, -3.0, 6.0));

  Vector3.zero().normalizeInto(out);
  relativeTest(out, Vector3.zero());

  expect(identical(a.copyInto(out), out), isTrue);
  relativeTest(out, a);

  Vector3.min(a, b, out);
  relativeTest(out, Vector3(-1.0, -3.0, 2.0));

  Vector3.max(a, b, out);
  relativeTest(out, Vector3(2.0, 4.0, 6.0));

  Vector3.mix(a, b, 0.5, out);
  relativeTest(out, Vector3(0.5, 0.5, 4.0));
}

void testVector4OutParameters() {
  final a = Vector4(1.0, -1.0, 1.0, -1.0);
  final b = Vector4(-2.0, 2.0, 0.0, 3.0);
  final out = Vector4.zero();

  expect(identical(a.normalizeInto(out), out), isTrue);
  relativeTest(out, Vector4(0.5, -0.5, 0.5, -0.5));
  relativeTest(a, Vector4(1.0, -1.0, 1.0, -1.0));

  Vector4.zero().normalizeInto(out);
  relativeTest(out, Vector4.zero());

  expect(identical(a.copyInto(out), out), isTrue);
  relativeTest(out, a);

  Vector4.min(a, b, out);
  relativeTest(out, Vector4(-2.0, -1.0, 0.0, -1.0));

  Vector4.max(a, b, out);
  relativeTest(out, Vector4(1.0, 2.0, 1.0, 3.0));

  Vector4.mix(a, b, 0.5, out);
  relativeTest(out, Vector4(-0.5, 0.5, 0.5, 1.0));
}

void testNormalizeIntoSelf() {
  final v2 = Vector2(3.0, -4.0);
  v2.normalizeInto(v2);
  relativeTest(v2, Vector2(0.6, -0.8));

  final v3 = Vector3(2.0, -3.0, 6.0);
  v3.normalizeInto(v3);
  relativeTest(v3, Vector3(2.0 / 7.0, -3.0 / 7.0, 6.0 / 7.0));

  final v4 = Vector4(1.0, -1.0, 1.0, -1.0);
  v4.normalizeInto(v4);
  relativeTest(v4, Vector4(0.5, -0.5, 0.5, -0.5));
}

void main() {
  group('Out parameters', () {
    test('Vector2', testVector2OutParameters);
    test('Vector3', testVector3OutParameters);
    test('Vector4', testVector4OutParameters);
    test('normalizeInto self', testNormalizeIntoSelf);
  });
}
