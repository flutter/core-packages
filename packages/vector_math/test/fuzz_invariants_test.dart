// Fuzz-check basic mathematical invariants across vector_math's core
// operations, looking for a genuine correctness bug (not covered by the
// existing hand-written unit tests).
import 'dart:math' as math;

import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

final math.Random rng = math.Random(42);

double rd() => (rng.nextDouble() - 0.5) * 20;

Vector2 randV2() => Vector2(rd(), rd());
Vector3 randV3() => Vector3(rd(), rd(), rd());
Vector4 randV4() => Vector4(rd(), rd(), rd(), rd());

Matrix2 randM2() => Matrix2(rd(), rd(), rd(), rd());
Matrix3 randM3() => Matrix3(rd(), rd(), rd(), rd(), rd(), rd(), rd(), rd(), rd());
Matrix4 randM4() => Matrix4(
  rd(),
  rd(),
  rd(),
  rd(),
  rd(),
  rd(),
  rd(),
  rd(),
  rd(),
  rd(),
  rd(),
  rd(),
  rd(),
  rd(),
  rd(),
  rd(),
);

Quaternion randQuat() {
  final q = Quaternion(rd(), rd(), rd(), rd());
  q.normalize();
  return q;
}

void main() {
  const n = 300;
  const eps = 1e-8;

  test('Vector2/3/4 normalize produces unit length (unless zero)', () {
    for (var i = 0; i < n; i++) {
      final Vector2 v2 = randV2();
      if (v2.length >= 1e-6) {
        final Vector2 copy2 = v2.clone()..normalize();
        expect(copy2.length, closeTo(1.0, 1e-6), reason: 'v2=$v2');
      }
      final Vector3 v3 = randV3();
      if (v3.length >= 1e-6) {
        final Vector3 copy3 = v3.clone()..normalize();
        expect(copy3.length, closeTo(1.0, 1e-6), reason: 'v3=$v3');
      }
      final Vector4 v4 = randV4();
      if (v4.length >= 1e-6) {
        final Vector4 copy4 = v4.clone()..normalize();
        expect(copy4.length, closeTo(1.0, 1e-6), reason: 'v4=$v4');
      }
    }
  });

  test('normalizeInto matches normalize on a copy', () {
    for (var i = 0; i < n; i++) {
      final Vector3 v3 = randV3();
      if (v3.length >= 1e-6) {
        final Vector3 viaCopy = v3.clone()..normalize();
        final out = Vector3.zero();
        v3.normalizeInto(out);
        expect(out.x, closeTo(viaCopy.x, eps), reason: 'v3=$v3');
        expect(out.y, closeTo(viaCopy.y, eps), reason: 'v3=$v3');
        expect(out.z, closeTo(viaCopy.z, eps), reason: 'v3=$v3');
      }

      final Vector4 v4 = randV4();
      if (v4.length >= 1e-6) {
        final Vector4 viaCopy4 = v4.clone()..normalize();
        final out4 = Vector4.zero();
        v4.normalizeInto(out4);
        expect(out4.x, closeTo(viaCopy4.x, eps));
        expect(out4.y, closeTo(viaCopy4.y, eps));
        expect(out4.z, closeTo(viaCopy4.z, eps));
        expect(out4.w, closeTo(viaCopy4.w, eps));
      }
    }
  });

  test('Vector3.min/max/mix match componentwise reference impl', () {
    for (var i = 0; i < n; i++) {
      final Vector3 a = randV3();
      final Vector3 b = randV3();
      final out = Vector3.zero();

      Vector3.min(a, b, out);
      expect(out.x, math.min(a.x, b.x));
      expect(out.y, math.min(a.y, b.y));
      expect(out.z, math.min(a.z, b.z));

      Vector3.max(a, b, out);
      expect(out.x, math.max(a.x, b.x));
      expect(out.y, math.max(a.y, b.y));
      expect(out.z, math.max(a.z, b.z));

      final double t = rng.nextDouble();
      Vector3.mix(a, b, t, out);
      expect(out.x, closeTo(a.x + (b.x - a.x) * t, eps));
      expect(out.y, closeTo(a.y + (b.y - a.y) * t, eps));
      expect(out.z, closeTo(a.z + (b.z - a.z) * t, eps));
    }
  });

  test('Matrix4 * Matrix4.inverted() ~= identity', () {
    for (var i = 0; i < n; i++) {
      final Matrix4 m = randM4();
      if (m.determinant().abs() < 1e-6) {
        continue;
      }
      final inv = Matrix4.copy(m)..invert();
      final product = (m * inv) as Matrix4;
      final identity = Matrix4.identity();
      for (var r = 0; r < 4; r++) {
        for (var c = 0; c < 4; c++) {
          expect(product.entry(r, c), closeTo(identity.entry(r, c), 1e-4), reason: 'm=$m');
        }
      }
    }
  });

  test('Matrix3 * Matrix3.inverted() ~= identity', () {
    for (var i = 0; i < n; i++) {
      final Matrix3 m = randM3();
      if (m.determinant().abs() < 1e-6) {
        continue;
      }
      final inv = Matrix3.copy(m)..invert();
      final product = (m * inv) as Matrix3;
      final identity = Matrix3.identity();
      for (var r = 0; r < 3; r++) {
        for (var c = 0; c < 3; c++) {
          expect(product.entry(r, c), closeTo(identity.entry(r, c), 1e-4), reason: 'm=$m');
        }
      }
    }
  });

  test('Quaternion * its inverse ~= identity rotation', () {
    for (var i = 0; i < n; i++) {
      final Quaternion q = randQuat();
      final Quaternion inv = q.inverted();
      final Quaternion product = q * inv;
      expect(product.x, closeTo(0.0, 1e-6));
      expect(product.y, closeTo(0.0, 1e-6));
      expect(product.z, closeTo(0.0, 1e-6));
      expect(product.w.abs(), closeTo(1.0, 1e-6));
    }
  });

  test('Quaternion.asRotationMatrix rotates vectors the same as direct quat rotation', () {
    for (var i = 0; i < n; i++) {
      final Quaternion q = randQuat();
      final Vector3 v = randV3();
      final Vector3 viaQuat = q.rotated(v);
      final Matrix3 m = q.asRotationMatrix();
      final Vector3 viaMatrix = m.transformed(v.clone());
      expect(viaMatrix.x, closeTo(viaQuat.x, 1e-6), reason: 'q=$q v=$v');
      expect(viaMatrix.y, closeTo(viaQuat.y, 1e-6), reason: 'q=$q v=$v');
      expect(viaMatrix.z, closeTo(viaQuat.z, 1e-6), reason: 'q=$q v=$v');
    }
  });

  test('cross product is orthogonal to both operands', () {
    for (var i = 0; i < n; i++) {
      final Vector3 a = randV3();
      final Vector3 b = randV3();
      final Vector3 c = a.cross(b);
      expect(c.dot(a), closeTo(0.0, 1e-6), reason: 'a=$a b=$b');
      expect(c.dot(b), closeTo(0.0, 1e-6), reason: 'a=$a b=$b');
    }
  });

  test('Matrix2 * Matrix2.inverted() ~= identity', () {
    for (var i = 0; i < n; i++) {
      final Matrix2 m = randM2();
      if (m.determinant().abs() < 1e-6) {
        continue;
      }
      final inv = Matrix2.copy(m)..invert();
      final product = (m * inv) as Matrix2;
      final identity = Matrix2.identity();
      for (var r = 0; r < 2; r++) {
        for (var c = 0; c < 2; c++) {
          expect(product.entry(r, c), closeTo(identity.entry(r, c), 1e-4), reason: 'm=$m');
        }
      }
    }
  });
}
