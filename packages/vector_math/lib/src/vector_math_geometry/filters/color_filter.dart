// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of '../../../vector_math_geometry.dart';

/// Assigns a single color to every vertex in a mesh.
class ColorFilter extends GeometryFilter {
  /// Creates a filter that writes [color] into the mesh `COLOR` attribute.
  ColorFilter(this.color);

  /// The color written to each output vertex.
  Vector4 color;

  @override
  List<VertexAttrib> get generates => <VertexAttrib>[VertexAttrib('COLOR', 4, 'float')];

  @override
  MeshGeometry filter(MeshGeometry mesh) {
    MeshGeometry output;
    if (mesh.getAttrib('COLOR') == null) {
      final attributes = <VertexAttrib>[...mesh.attribs, VertexAttrib('COLOR', 4, 'float')];
      output = MeshGeometry.resetAttribs(mesh, attributes);
    } else {
      output = MeshGeometry.copy(mesh);
    }

    final VectorList<Vector>? colors = output.getViewForAttrib('COLOR');
    if (colors is Vector4List) {
      for (var i = 0; i < colors.length; ++i) {
        colors[i] = color;
      }
      return output;
    } else {
      throw UnimplementedError();
    }
  }
}
