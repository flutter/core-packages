// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of '../../../vector_math_geometry.dart';

class TransformFilter extends InplaceGeometryFilter {

  TransformFilter(this.transform);
  Matrix4 transform;

  @override
  List<VertexAttrib> get requires => <VertexAttrib>[
    VertexAttrib('POSITION', 3, 'float'),
  ];

  @override
  void filterInplace(MeshGeometry mesh) {
    final VectorList<Vector>? position = mesh.getViewForAttrib('POSITION');
    if (position is Vector3List) {
      for (var i = 0; i < position.length; ++i) {
        // multiplication always returns Vector3 here
        // ignore: invalid_assignment
        position[i] = transform * position[i];
      }
    }
  }
}
