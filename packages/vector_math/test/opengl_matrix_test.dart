// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';
import 'package:test/test.dart';

import 'package:vector_math/vector_math.dart';

import 'test_utils.dart';

void testUnproject() {
  final position = Vector3(0.0, 0.0, 0.0);
  final focusPosition = Vector3(0.0, 0.0, -1.0);
  final upDirection = Vector3(0.0, 1.0, 0.0);
  final Matrix4 lookat = makeViewMatrix(position, focusPosition, upDirection);
  const n = 0.1;
  const f = 1000.0;
  const l = -10.0;
  const r = 10.0;
  const b = -10.0;
  const t = 10.0;
  final Matrix4 frustum = makeFrustumMatrix(l, r, b, t, n, f);
  final C = frustum * lookat as Matrix4;
  final re = Vector3.zero();
  unproject(C, 0.0, 100.0, 0.0, 100.0, 50.0, 50.0, 1.0, re);
}

void testLookAt() {
  final eyePosition = Vector3(0.0, 0.0, 0.0);
  final lookAtPosition = Vector3(0.0, 0.0, -1.0);
  final upDirection = Vector3(0.0, 1.0, 0.0);

  final Matrix4 lookat = makeViewMatrix(
    eyePosition,
    lookAtPosition,
    upDirection,
  );
  assert(lookat.getColumn(0).w == 0.0);
  assert(lookat.getColumn(1).w == 0.0);
  assert(lookat.getColumn(2).w == 0.0);
  assert(lookat.getColumn(3).w == 1.0);

  relativeTest(lookat.getColumn(0), Vector4(1.0, 0.0, 0.0, 0.0));
  relativeTest(lookat.getColumn(1), Vector4(0.0, 1.0, 0.0, 0.0));
  relativeTest(lookat.getColumn(2), Vector4(0.0, 0.0, 1.0, 0.0));
}

void testFrustumMatrix() {
  const n = 0.1;
  const f = 1000.0;
  const l = -1.0;
  const r = 1.0;
  const b = -1.0;
  const t = 1.0;
  final Matrix4 frustum = makeFrustumMatrix(l, r, b, t, n, f);
  relativeTest(frustum.getColumn(0), Vector4(2 * n / (r - l), 0.0, 0.0, 0.0));
  relativeTest(frustum.getColumn(1), Vector4(0.0, 2 * n / (t - b), 0.0, 0.0));
  relativeTest(
    frustum.getColumn(2),
    Vector4((r + l) / (r - l), (t + b) / (t - b), -(f + n) / (f - n), -1.0),
  );
  relativeTest(
    frustum.getColumn(3),
    Vector4(0.0, 0.0, -2.0 * f * n / (f - n), 0.0),
  );
}

void testPerspectiveMatrix() {
  const double fov = pi / 2;
  const aspectRatio = 2.0;
  const zNear = 1.0;
  const zFar = 100.0;

  final Matrix4 perspective = makePerspectiveMatrix(
    fov,
    aspectRatio,
    zNear,
    zFar,
  );
  relativeTest(perspective.getColumn(0), Vector4(0.5, 0.0, 0.0, 0.0));
  relativeTest(perspective.getColumn(1), Vector4(0.0, 1.0, 0.0, 0.0));
  relativeTest(
    perspective.getColumn(2),
    Vector4(0.0, 0.0, -101.0 / 99.0, -1.0),
  );
  relativeTest(perspective.getColumn(3), Vector4(0.0, 0.0, -200.0 / 99.0, 0.0));
}

void testInfiniteMatrix() {
  const double fov = pi / 2;
  const aspectRatio = 2.0;
  const zNear = 1.0;

  final Matrix4 infinite = makeInfiniteMatrix(fov, aspectRatio, zNear);
  relativeTest(infinite.getColumn(0), Vector4(0.5, 0.0, 0.0, 0.0));
  relativeTest(infinite.getColumn(1), Vector4(0.0, 1.0, 0.0, 0.0));
  relativeTest(infinite.getColumn(2), Vector4(0.0, 0.0, -1.0, -1.0));
  relativeTest(infinite.getColumn(3), Vector4(0.0, 0.0, -2.0, 0.0));
}

void testOrthographicMatrix() {
  const n = 0.1;
  const f = 1000.0;
  const l = -1.0;
  const r = 1.0;
  const b = -1.0;
  const t = 1.0;
  final Matrix4 ortho = makeOrthographicMatrix(l, r, b, t, n, f);
  relativeTest(ortho.getColumn(0), Vector4(2 / (r - l), 0.0, 0.0, 0.0));
  relativeTest(ortho.getColumn(1), Vector4(0.0, 2 / (t - b), 0.0, 0.0));
  relativeTest(ortho.getColumn(2), Vector4(0.0, 0.0, -2 / (f - n), 0.0));
  relativeTest(
    ortho.getColumn(3),
    Vector4(-(r + l) / (r - l), -(t + b) / (t - b), -(f + n) / (f - n), 1.0),
  );
}

void testModelMatrix() {
  final view = Matrix4.zero();
  final position = Vector3(1.0, 1.0, 1.0);
  final focus = Vector3(0.0, 0.0, -1.0);
  final up = Vector3(0.0, 1.0, 0.0);

  setViewMatrix(view, position, focus, up);

  final model = Matrix4.zero();

  final Vector3 forward = focus.clone();
  forward.sub(position);
  forward.normalize();

  final Vector3 right = forward.cross(up).normalized();
  final Vector3 u = right.cross(forward).normalized();

  setModelMatrix(model, forward, u, position.x, position.y, position.z);

  final Matrix4 result1 = view.clone();
  result1.multiply(model);

  relativeTest(result1, Matrix4.identity());
}

void main() {
  group('OpenGL', () {
    test('LookAt', testLookAt);
    test('Unproject', testUnproject);
    test('Frustum', testFrustumMatrix);
    test('Perspective', testPerspectiveMatrix);
    test('Infinite', testInfiniteMatrix);
    test('Orthographic', testOrthographicMatrix);
    test('ModelMatrix', testModelMatrix);
  });
}
