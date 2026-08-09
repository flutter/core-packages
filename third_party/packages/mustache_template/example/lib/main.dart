// Copyright 2026 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'package:mustache_template/mustache_template.dart';

/// The main entrypoint for the example app.
void main() {
  exampleUsage();
  nestedPaths();
  partialsExample();
  lambdasExample();
}

/// Demonstrates basic usage of mustache templates.
void exampleUsage() {
  const source = '''
    {{# names }}
            <div>{{ lastname }}, {{ firstname }}</div>
    {{/ names }}
    {{^ names }}
      <div>No names.</div>
    {{/ names }}
    {{! I am a comment. }}
  ''';

  final template = Template(source, name: 'template-filename.html');

  final String output = template.renderString(<String, dynamic>{
    'names': <Map<String, String>>[
      <String, String>{'firstname': 'Greg', 'lastname': 'Lowe'},
      <String, String>{'firstname': 'Bob', 'lastname': 'Johnson'},
    ],
  });

  print(output);
}

/// Demonstrates how to access nested map properties.
void nestedPaths() {
  final template = Template('The author is {{ author.name }}');
  final String output = template.renderString(<String, dynamic>{
    'author': <String, String>{'name': 'Greg Lowe'},
  });
  print(output);
}

/// Demonstrates the usage of partials with a custom resolver.
void partialsExample() {
  final partial = Template('{{ foo }}', name: 'partial');

  Template? resolver(String name) {
    if (name == 'partial-name') {
      // Name of partial tag.
      return partial;
    }
    return null;
  }

  final t = Template('{{> partial-name }}', partialResolver: resolver);

  final String output = t.renderString(<String, dynamic>{'foo': 'bar'});
  print(output); // bar
}

/// Demonstrates various usages of lambdas, including hidden sections and lambda contexts.
void lambdasExample() {
  // Simple lambda
  final t1 = Template('{{# foo }}inner{{/ foo }}');
  Object lambda1(Object? _) => 'bar';
  print(t1.renderString(<String, dynamic>{'foo': lambda1})); // bar

  // Lambda returning text for a hidden section
  final t2 = Template('{{# foo }}hidden{{/ foo }}');
  Object lambda2(Object? _) => 'shown';
  print(t2.renderString(<String, dynamic>{'foo': lambda2})); // shown

  // Lambda Context
  final t3 = Template('{{# foo }}oi{{/ foo }}');
  Object lambda3(LambdaContext ctx) =>
      '<b>${ctx.renderString().toUpperCase()}</b>';
  print(t3.renderString(<String, dynamic>{'foo': lambda3})); // <b>OI</b>

  // Lambda Context with variables
  final t4 = Template('{{# foo }}{{bar}}{{/ foo }}');
  Object lambda4(LambdaContext ctx) =>
      '<b>${ctx.renderString().toUpperCase()}</b>';
  print(t4.renderString(
      <String, dynamic>{'foo': lambda4, 'bar': 'pub'})); // <b>PUB</b>

  // Lambda Context re-parsing source
  final t5 = Template('{{# foo }}{{bar}}{{/ foo }}');
  Object lambda5(LambdaContext ctx) =>
      ctx.renderSource('${ctx.source} {{cmd}}');
  print(t5.renderString(<String, dynamic>{
    'foo': lambda5,
    'bar': 'pub',
    'cmd': 'build',
  })); // pub build
}
