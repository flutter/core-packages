// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of '../../../vector_math_geometry.dart';

/// A filter that produces a transformed copy of a [MeshGeometry].
abstract class GeometryFilter {
  /// Whether this filter supports in-place modification of a mesh.
  bool get inplace => false;

  /// Vertex attributes that must be present on the input mesh.
  List<VertexAttrib> get requires => const <VertexAttrib>[];

  /// Vertex attributes that this filter guarantees on the output mesh.
  List<VertexAttrib> get generates => const <VertexAttrib>[];

  /// Returns a copy of the mesh with any filter transforms applied.
  MeshGeometry filter(MeshGeometry mesh);
}

/// A [GeometryFilter] that can apply its transformation directly to a mesh
/// in-place.
abstract class InplaceGeometryFilter extends GeometryFilter {
  @override
  bool get inplace => true;

  @override
  MeshGeometry filter(MeshGeometry mesh) {
    final output = MeshGeometry.copy(mesh);
    filterInplace(output);
    return output;
  }

  /// Applies the filter to the mesh.
  void filterInplace(MeshGeometry mesh);
}
