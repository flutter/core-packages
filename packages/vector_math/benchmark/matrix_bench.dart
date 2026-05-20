// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:vector_math/vector_math.dart';
import 'package:vector_math/vector_math_operations.dart';

class MatrixMultiplyBenchmark extends BenchmarkBase {
  MatrixMultiplyBenchmark() : super('MatrixMultiply');
  final A = Float32List(16);
  final B = Float32List(16);
  final C = Float32List(16);

  static void main() {
    MatrixMultiplyBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 200; i++) {
      Matrix44Operations.multiply(C, 0, A, 0, B, 0);
    }
  }
}

class SIMDMatrixMultiplyBenchmark extends BenchmarkBase {
  SIMDMatrixMultiplyBenchmark() : super('SIMDMatrixMultiply');
  final A = Float32x4List(4);
  final B = Float32x4List(4);
  final C = Float32x4List(4);

  static void main() {
    SIMDMatrixMultiplyBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 200; i++) {
      Matrix44SIMDOperations.multiply(C, 0, A, 0, B, 0);
    }
  }
}

class VectorTransformBenchmark extends BenchmarkBase {
  VectorTransformBenchmark() : super('VectorTransform');
  final A = Float32List(16);
  final B = Float32List(4);
  final C = Float32List(4);

  static void main() {
    VectorTransformBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 200; i++) {
      Matrix44Operations.transform4(C, 0, A, 0, B, 0);
    }
  }
}

class SIMDVectorTransformBenchmark extends BenchmarkBase {
  SIMDVectorTransformBenchmark() : super('SIMDVectorTransform');
  final A = Float32x4List(4);
  final B = Float32x4List(1);
  final C = Float32x4List(1);

  static void main() {
    SIMDVectorTransformBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 200; i++) {
      Matrix44SIMDOperations.transform4(C, 0, A, 0, B, 0);
    }
  }
}

class ViewMatrixBenchmark extends BenchmarkBase {
  ViewMatrixBenchmark() : super('setViewMatrix');

  final M = Matrix4.zero();
  final P = Vector3.zero();
  final F = Vector3.zero();
  final U = Vector3.zero();

  static void main() {
    ViewMatrixBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      setViewMatrix(M, P, F, U);
    }
  }
}

class Aabb2TransformBenchmark extends BenchmarkBase {
  Aabb2TransformBenchmark() : super('aabb2Transform');

  static final m = Matrix3.rotationZ(math.pi / 4);
  static final p1 = Vector2(10.0, 10.0);
  static final p2 = Vector2(20.0, 30.0);
  static final p3 = Vector2(100.0, 50.0);
  static final b1 = Aabb2.minMax(p1, p2);
  static final b2 = Aabb2.minMax(p1, p3);
  static final b3 = Aabb2.minMax(p2, p3);
  static final temp = Aabb2();

  static void main() {
    Aabb2TransformBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.copyFrom(b1);
      temp.transform(m);
      temp.copyFrom(b2);
      temp.transform(m);
      temp.copyFrom(b3);
      temp.transform(m);
    }
  }
}

class Aabb2RotateBenchmark extends BenchmarkBase {
  Aabb2RotateBenchmark() : super('aabb2Rotate');

  static final m = Matrix3.rotationZ(math.pi / 4);
  static final p1 = Vector2(10.0, 10.0);
  static final p2 = Vector2(20.0, 30.0);
  static final p3 = Vector2(100.0, 50.0);
  static final b1 = Aabb2.minMax(p1, p2);
  static final b2 = Aabb2.minMax(p1, p3);
  static final b3 = Aabb2.minMax(p2, p3);
  static final temp = Aabb2();

  static void main() {
    Aabb2RotateBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.copyFrom(b1);
      temp.rotate(m);
      temp.copyFrom(b2);
      temp.rotate(m);
      temp.copyFrom(b3);
      temp.rotate(m);
    }
  }
}

class Aabb3TransformBenchmark extends BenchmarkBase {
  Aabb3TransformBenchmark() : super('aabb3Transform');

  static final m = Matrix4.rotationZ(math.pi / 4);
  static final p1 = Vector3(10.0, 10.0, 0.0);
  static final p2 = Vector3(20.0, 30.0, 1.0);
  static final p3 = Vector3(100.0, 50.0, 10.0);
  static final b1 = Aabb3.minMax(p1, p2);
  static final b2 = Aabb3.minMax(p1, p3);
  static final b3 = Aabb3.minMax(p2, p3);
  static final temp = Aabb3();

  static void main() {
    Aabb3TransformBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.copyFrom(b1);
      temp.transform(m);
      temp.copyFrom(b2);
      temp.transform(m);
      temp.copyFrom(b3);
      temp.transform(m);
    }
  }
}

class Aabb3RotateBenchmark extends BenchmarkBase {
  Aabb3RotateBenchmark() : super('aabb3Rotate');

  static final m = Matrix4.rotationZ(math.pi / 4);
  static final p1 = Vector3(10.0, 10.0, 0.0);
  static final p2 = Vector3(20.0, 30.0, 1.0);
  static final p3 = Vector3(100.0, 50.0, 10.0);
  static final b1 = Aabb3.minMax(p1, p2);
  static final b2 = Aabb3.minMax(p1, p3);
  static final b3 = Aabb3.minMax(p2, p3);
  static final temp = Aabb3();

  static void main() {
    Aabb3RotateBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.copyFrom(b1);
      temp.rotate(m);
      temp.copyFrom(b2);
      temp.rotate(m);
      temp.copyFrom(b3);
      temp.rotate(m);
    }
  }
}

class Matrix3DeterminantBenchmark extends BenchmarkBase {
  Matrix3DeterminantBenchmark() : super('Matrix3.determinant');

  final mx = Matrix3.rotationX(math.pi / 4);
  final my = Matrix3.rotationY(math.pi / 4);
  final mz = Matrix3.rotationZ(math.pi / 4);

  static void main() {
    Matrix3DeterminantBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 800; i++) {
      mx.determinant();
      my.determinant();
      mz.determinant();
    }
  }
}

class Matrix3TransformVector3Benchmark extends BenchmarkBase {
  Matrix3TransformVector3Benchmark() : super('Matrix3.transform(Vector3)');

  final mx = Matrix3.rotationX(math.pi / 4);
  final my = Matrix3.rotationY(math.pi / 4);
  final mz = Matrix3.rotationZ(math.pi / 4);
  final v1 = Vector3(10.0, 20.0, 1.0);
  final v2 = Vector3(-10.0, 20.0, 1.0);
  final v3 = Vector3(10.0, -20.0, 1.0);

  static void main() {
    Matrix3TransformVector3Benchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 800; i++) {
      mx.transform(v1);
      mx.transform(v2);
      mx.transform(v3);
      my.transform(v1);
      my.transform(v2);
      my.transform(v3);
      mz.transform(v1);
      mz.transform(v2);
      mz.transform(v3);
    }
  }
}

class Matrix3TransformVector2Benchmark extends BenchmarkBase {
  Matrix3TransformVector2Benchmark() : super('Matrix3.transform(Vector2)');

  final mx = Matrix3.rotationX(math.pi / 4);
  final my = Matrix3.rotationY(math.pi / 4);
  final mz = Matrix3.rotationZ(math.pi / 4);
  final v1 = Vector2(10.0, 20.0);
  final v2 = Vector2(-10.0, 20.0);
  final v3 = Vector2(10.0, -20.0);

  static void main() {
    Matrix3TransformVector2Benchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 800; i++) {
      mx.transform2(v1);
      mx.transform2(v2);
      mx.transform2(v3);
      my.transform2(v1);
      my.transform2(v2);
      my.transform2(v3);
      mz.transform2(v1);
      mz.transform2(v2);
      mz.transform2(v3);
    }
  }
}

class Matrix3TransposeMultiplyBenchmark extends BenchmarkBase {
  Matrix3TransposeMultiplyBenchmark() : super('Matrix3.transposeMultiply');

  final mx = Matrix3.rotationX(math.pi / 4);
  final my = Matrix3.rotationY(math.pi / 4);
  final mz = Matrix3.rotationZ(math.pi / 4);
  final temp = Matrix3.zero();

  static void main() {
    Matrix3TransposeMultiplyBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.setIdentity();
      temp.transposeMultiply(mx);
      temp.transposeMultiply(my);
      temp.transposeMultiply(mz);
    }
  }
}

class Matrix4TranslateByDoubleGenericBenchmark extends BenchmarkBase {
  Matrix4TranslateByDoubleGenericBenchmark()
    : super('Matrix4.translateByDoubleGeneric');

  final temp = Matrix4.zero()..setIdentity();

  static void main() {
    Matrix4TranslateByDoubleGenericBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.translate(10.0, 20.0, 30.0);
    }
  }
}

class Matrix4TranslateByVector3GenericBenchmark extends BenchmarkBase {
  Matrix4TranslateByVector3GenericBenchmark()
    : super('Matrix4.translateByVector3Generic');

  final temp = Matrix4.zero()..setIdentity();
  final vec = Vector3(10.0, 20.0, 30.0);

  static void main() {
    Matrix4TranslateByVector3GenericBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.translate(vec);
    }
  }
}

class Matrix4TranslateByVector4GenericBenchmark extends BenchmarkBase {
  Matrix4TranslateByVector4GenericBenchmark()
    : super('Matrix4.translateByVector4Generic');

  final temp = Matrix4.zero()..setIdentity();
  final vec = Vector4(10.0, 20.0, 30.0, 40.0);

  static void main() {
    Matrix4TranslateByVector4GenericBenchmark().report();
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.translate(vec);
    }
  }
}

class Matrix4TranslateByDoubleBenchmark extends BenchmarkBase {
  Matrix4TranslateByDoubleBenchmark() : super('Matrix4.translateByDouble');

  final temp = Matrix4.zero()..setIdentity();

  static void main() {
    Matrix4TranslateByDoubleBenchmark().report();
  }

  // Call the benchmarked method with random arguments to make sure TFA won't
  // specialize it based on the arguments passed and wasm-opt won't inline it,
  // for fair comparison with the generic case.
  @override
  void setup() {
    for (var i = 0; i < 10; i++) {
      temp.translateByDouble(
        i.toDouble(),
        (i * 10).toDouble(),
        (i * 5).toDouble(),
        1.0,
      );
    }
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.translateByDouble(10.0, 20.0, 30.0, 1.0);
    }
  }
}

class Matrix4TranslateByVector3Benchmark extends BenchmarkBase {
  Matrix4TranslateByVector3Benchmark() : super('Matrix4.translateByVector3');

  final temp = Matrix4.zero()..setIdentity();
  final vec = Vector3(10.0, 20.0, 30.0);

  static void main() {
    Matrix4TranslateByVector3Benchmark().report();
  }

  // Call the benchmarked method with random arguments to make sure TFA won't
  // specialize it based on the arguments passed and wasm-opt won't inline it,
  // for fair comparison with the generic case.
  @override
  void setup() {
    for (var i = 0; i < 10; i++) {
      temp.translateByVector3(
        Vector3(i.toDouble(), (i * 10).toDouble(), (i * 5).toDouble()),
      );
    }
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.translateByVector3(vec);
    }
  }
}

class Matrix4TranslateByVector4Benchmark extends BenchmarkBase {
  Matrix4TranslateByVector4Benchmark() : super('Matrix4.translateByVector4');

  final temp = Matrix4.zero()..setIdentity();
  final vec = Vector4(10.0, 20.0, 30.0, 40.0);

  static void main() {
    Matrix4TranslateByVector4Benchmark().report();
  }

  // Call the benchmarked method with random arguments to make sure TFA won't
  // specialize it based on the arguments passed and wasm-opt won't inline it,
  // for fair comparison with the generic case.
  @override
  void setup() {
    for (var i = 0; i < 10; i++) {
      temp.translateByVector4(
        Vector4(
          i.toDouble(),
          (i * 10).toDouble(),
          (i * 5).toDouble(),
          (i * 20).toDouble(),
        ),
      );
    }
  }

  @override
  void run() {
    for (var i = 0; i < 100; i++) {
      temp.translateByVector4(vec);
    }
  }
}

void main() {
  MatrixMultiplyBenchmark.main();
  SIMDMatrixMultiplyBenchmark.main();
  VectorTransformBenchmark.main();
  SIMDVectorTransformBenchmark.main();
  ViewMatrixBenchmark.main();
  Aabb2TransformBenchmark.main();
  Aabb2RotateBenchmark.main();
  Aabb3TransformBenchmark.main();
  Aabb3RotateBenchmark.main();
  Matrix3DeterminantBenchmark.main();
  Matrix3TransformVector3Benchmark.main();
  Matrix3TransformVector2Benchmark.main();
  Matrix3TransposeMultiplyBenchmark.main();
  Matrix4TranslateByDoubleGenericBenchmark.main();
  Matrix4TranslateByVector3GenericBenchmark.main();
  Matrix4TranslateByVector4GenericBenchmark.main();
  Matrix4TranslateByDoubleBenchmark.main();
  Matrix4TranslateByVector3Benchmark.main();
  Matrix4TranslateByVector4Benchmark.main();
}
