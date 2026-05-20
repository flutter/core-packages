// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// TODO(stuartmorgan): Remove this and fix violations. See
//  https://github.com/flutter/flutter/issues/186827
// ignore_for_file: public_member_api_docs

part of '../../../vector_math_geometry.dart';

class InvertFilter extends InplaceGeometryFilter {
  @override
  void filterInplace(MeshGeometry mesh) {
    // TODO: Do the tangents need to be inverted? Maybe just the W component?
    // TODO: Should modify in-place be allowed, or should it be required
    // to return a new geometry?

    // Swap all the triangle indices
    final Uint16List indicies = mesh.indices!;

    for (var i = 0; i < indicies.length; i += 3) {
      final int tmp = indicies[i];
      indicies[i] = indicies[i + 2];
      indicies[i + 2] = tmp;
    }

    final VectorList<Vector>? normals = mesh.getViewForAttrib('NORMAL');
    if (normals is Vector3List) {
      for (var i = 0; i < normals.length; ++i) {
        normals[i] = -normals[i];
      }
    }
  }
}
