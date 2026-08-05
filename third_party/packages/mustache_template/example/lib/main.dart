// Copyright 2026 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

// #docregion example_usage
import 'package:mustache_template/mustache_template.dart';
// #enddocregion example_usage

/// The main entrypoint for the example app.
void main() {
  exampleUsage();
  nestedPaths();
  partialsExample();
  lambdasExample();
}

/// Demonstrates basic usage of mustache templates.
void exampleUsage() {
  // #docregion example_usage
  const String source = '''
    {{# names }}
            <div>{{ lastname }}, {{ firstname }}</div>
    {{/ names }}
    {{^ names }}
      <div>No names.</div>
    {{/ names }}
    {{! I am a comment. }}
  ''';

  final Template template = Template(source, name: 'template-filename.html');

  final String output = template.renderString(<String, dynamic>{
    'names': <Map<String, String>>[
      <String, String>{'firstname': 'Greg', 'lastname': 'Lowe'},
      <String, String>{'firstname': 'Bob', 'lastname': 'Johnson'},
    ],
  });
  // #enddocregion example_usage

  print(output);
}

/// Demonstrates how to access nested map properties.
void nestedPaths() {
  // #docregion nested_paths
  final Template template = Template('The author is {{ author.name }}');
  final String output = template.renderString(<String, dynamic>{
    'author': <String, String>{'name': 'Greg Lowe'},
  });
  // #enddocregion nested_paths
  print(output);
}

/// Demonstrates the usage of partials with a custom resolver.
void partialsExample() {
  // #docregion partials
  final Template partial = Template('{{ foo }}', name: 'partial');

  Template? resolver(String name) {
    if (name == 'partial-name') {
      // Name of partial tag.
      return partial;
    }
    return null;
  }

  final Template t = Template('{{> partial-name }}', partialResolver: resolver);

  final String output = t.renderString(<String, dynamic>{'foo': 'bar'});
  // #enddocregion partials
  print(output); // bar
}

/// Demonstrates various usages of lambdas, including hidden sections and lambda contexts.
void lambdasExample() {
  // #docregion lambdas
  // Simple lambda
  final Template t1 = Template('{{# foo }}inner{{/ foo }}');
  Object lambda1(Object? _) => 'bar';
  // #enddocregion lambdas
  print(t1.renderString(<String, dynamic>{'foo': lambda1})); // bar

  // #docregion lambdas
  // Lambda returning text for a hidden section
  final Template t2 = Template('{{# foo }}hidden{{/ foo }}');
  Object lambda2(Object? _) => 'shown';
  // #enddocregion lambdas
  print(t2.renderString(<String, dynamic>{'foo': lambda2})); // shown

  // #docregion lambdas
  // Lambda Context
  final Template t3 = Template('{{# foo }}oi{{/ foo }}');
  Object lambda3(LambdaContext ctx) =>
      '<b>${ctx.renderString().toUpperCase()}</b>';
  // #enddocregion lambdas
  print(t3.renderString(<String, dynamic>{'foo': lambda3})); // <b>OI</b>

  // #docregion lambdas
  // Lambda Context with variables
  final Template t4 = Template('{{# foo }}{{bar}}{{/ foo }}');
  Object lambda4(LambdaContext ctx) =>
      '<b>${ctx.renderString().toUpperCase()}</b>';
  // #enddocregion lambdas
  print(t4.renderString(
      <String, dynamic>{'foo': lambda4, 'bar': 'pub'})); // <b>PUB</b>

  // #docregion lambdas
  // Lambda Context re-parsing source
  final Template t5 = Template('{{# foo }}{{bar}}{{/ foo }}');
  Object lambda5(LambdaContext ctx) =>
      ctx.renderSource('${ctx.source} {{cmd}}');
  // #enddocregion lambdas
  print(t5.renderString(<String, dynamic>{
    'foo': lambda5,
    'bar': 'pub',
    'cmd': 'build',
  })); // pub build
}

