// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:hooks/hooks.dart';

import 'config.dart';

/// A [ProtocolExtension] that supplies Flutter-specific configuration to build
/// and link hooks.
///
/// This is constructed by the Flutter SDK (`flutter_tools`) and passed to the
/// hook runner alongside the other protocol extensions. Hook authors consume
/// the data it injects via [HookConfigFlutterConfig.flutter] rather than using
/// this class directly.
final class FlutterExtension extends ProtocolExtension {
  /// Creates a [FlutterExtension].
  ///
  /// [engineVersion] is an opaque identifier that must change whenever any of
  /// the exposed engine artifacts can change (typically the Flutter engine
  /// revision; a stable identifier for the local engine output directory under
  /// `--local-engine`). It is what causes hook caches to invalidate when the
  /// Flutter SDK is upgraded.
  ///
  /// [impellerc] and [libtessellator] must be absolute file URIs pointing at
  /// the corresponding engine host tools.
  FlutterExtension({
    required this.engineVersion,
    required this.impellerc,
    required this.libtessellator,
  });

  /// An opaque identifier for the Flutter engine the invoking SDK targets.
  final String engineVersion;

  /// The absolute path to the `impellerc` offline shader compiler.
  final Uri impellerc;

  /// The absolute path to the `libtessellator` dynamic library.
  final Uri libtessellator;

  void _setup(HookConfigBuilder config) => config.setupFlutter(
    engineVersion: engineVersion,
    impellerc: impellerc,
    libtessellator: libtessellator,
  );

  @override
  void setupBuildInput(BuildInputBuilder input) => _setup(input.config);

  @override
  void setupLinkInput(LinkInputBuilder input) => _setup(input.config);
}
