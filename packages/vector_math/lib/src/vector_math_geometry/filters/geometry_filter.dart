// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// TODO(stuartmorgan): Remove this and fix violations. See
//  https://github.com/flutter/flutter/issues/186827
// ignore_for_file: public_member_api_docs

part of '../../../vector_math_geometry.dart';

abstract class GeometryFilter {
  bool get inplace => false;
  List<VertexAttrib> get requires => <VertexAttrib>[];
  List<VertexAttrib> get generates => <VertexAttrib>[];

  /// Returns a copy of the mesh with any filter transforms applied.
  MeshGeometry filter(MeshGeometry mesh);
}

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
