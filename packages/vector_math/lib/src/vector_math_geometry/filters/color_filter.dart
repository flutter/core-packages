// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// TODO(stuartmorgan): Remove this and fix violations. See
//  https://github.com/flutter/flutter/issues/186827
// ignore_for_file: public_member_api_docs

part of '../../../vector_math_geometry.dart';

class ColorFilter extends GeometryFilter {
  ColorFilter(this.color);
  Vector4 color;

  @override
  List<VertexAttrib> get generates => <VertexAttrib>[
    VertexAttrib('COLOR', 4, 'float'),
  ];

  @override
  MeshGeometry filter(MeshGeometry mesh) {
    MeshGeometry output;
    if (mesh.getAttrib('COLOR') == null) {
      final attributes = <VertexAttrib>[
        ...mesh.attribs,
        VertexAttrib('COLOR', 4, 'float'),
      ];
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
