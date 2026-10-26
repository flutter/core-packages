// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of '../../../vector_math_geometry.dart';

/// Generates a flat ring (annulus) or partial-ring mesh in the XZ plane,
/// centered at the origin.
class RingGenerator extends GeometryGenerator {
  late double _innerRadius;
  late double _outerRadius;
  late int _segments;
  late double _thetaStart;
  late double _thetaLength;
  late bool _stripTextureCoordinates;

  @override
  int get vertexCount => (_segments + 1) * 2;

  @override
  int get indexCount => _segments * 3 * 2;

  /// Creates a ring mesh between [innerRadius] and [outerRadius].
  ///
  /// The [segments] parameter controls how many quads are used around the
  /// ring. The [thetaStart] and [thetaLength] parameters can be used to
  /// generate only an arc of the ring, both given in radians.
  ///
  /// If [stripTextureCoordinates] is true, texture coordinates are mapped as
  /// a strip: u goes from 0.0 on the inner edge to 1.0 on the outer edge, and
  /// v goes from 0.0 to 1.0 along the ring. Otherwise, the vertex positions
  /// are projected onto the texture from above.
  ///
  /// The [flags] parameter configures which vertex attributes to generate, and
  /// [filters] specifies any mesh transformations to apply after generation.
  MeshGeometry createRing(
    double innerRadius,
    double outerRadius, {
    GeometryGeneratorFlags? flags,
    List<GeometryFilter>? filters,
    int segments = 64,
    double thetaStart = 0.0,
    double thetaLength = math.pi * 2.0,
    bool stripTextureCoordinates = true,
  }) {
    _innerRadius = innerRadius;
    _outerRadius = outerRadius;
    _segments = segments;
    _thetaStart = thetaStart;
    _thetaLength = thetaLength;
    _stripTextureCoordinates = stripTextureCoordinates;
    return createGeometry(flags: flags, filters: filters);
  }

  @override
  void generateVertexPositions(Vector3List positions, Uint16List indices) {
    final v = Vector3.zero();
    var index = 0;
    for (var i = 0; i <= _segments; i++) {
      final double percent = i / _segments;
      v
        ..x = _innerRadius * math.cos(_thetaStart + percent * _thetaLength)
        ..z = _innerRadius * math.sin(_thetaStart + percent * _thetaLength);
      positions[index] = v;
      index++;
      v
        ..x = _outerRadius * math.cos(_thetaStart + percent * _thetaLength)
        ..z = _outerRadius * math.sin(_thetaStart + percent * _thetaLength);
      positions[index] = v;
      index++;
    }
    assert(index == vertexCount);
  }

  @override
  void generateVertexTexCoords(Vector2List texCoords, Vector3List positions, Uint16List indices) {
    if (_stripTextureCoordinates) {
      final v = Vector2.zero();
      var index = 0;
      for (var i = 0; i <= _segments; i++) {
        final double percent = i / _segments;
        v
          ..x = 0.0
          ..y = percent;
        texCoords[index] = v;
        index++;
        v
          ..x = 1.0
          ..y = percent;
        texCoords[index] = v;
        index++;
      }
    } else {
      final v = Vector2.zero();
      var index = 0;
      for (var i = 0; i <= _segments; i++) {
        Vector3 position = positions[index];
        double x = (position.x / (_outerRadius + 1.0)) * 0.5;
        double y = (position.z / (_outerRadius + 1.0)) * 0.5;
        v
          ..x = x + 0.5
          ..y = y + 0.5;
        texCoords[index] = v;
        index++;
        position = positions[index];
        x = (position.x / (_outerRadius + 1.0)) * 0.5;
        y = (position.z / (_outerRadius + 1.0)) * 0.5;
        v
          ..x = x + 0.5
          ..y = y + 0.5;
        texCoords[index] = v;
        index++;
      }
      assert(index == vertexCount);
    }
  }

  @override
  void generateIndices(Uint16List indices) {
    var index = 0;
    final int length = _segments * 2;
    for (var i = 0; i < length; i += 2) {
      indices[index + 0] = i + 0;
      indices[index + 1] = i + 1;
      indices[index + 2] = i + 3;
      indices[index + 3] = i + 0;
      indices[index + 4] = i + 3;
      indices[index + 5] = i + 2;
      index += 6;
    }
    assert(index == indexCount);
  }
}
