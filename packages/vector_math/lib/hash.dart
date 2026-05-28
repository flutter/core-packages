// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

@Deprecated('Use Object.hashAll instead')
library;

///
/// Generates a hash code for multiple [objects].
///
@Deprecated('Use Object.hashAll instead')
int hashObjects(Iterable<Object> objects) => Object.hashAll(objects);
