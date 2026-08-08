// Copyright 2026 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This file exists solely to host compiled excerpts for README.md, and is not
// intended for use as an actual example application.

// ignore_for_file: avoid_print
// ignore_for_file: omit_local_variable_types
// ignore_for_file: strict_raw_type
// ignore_for_file: prefer_final_locals

import 'package:mustache_template/mustache_template.dart';

/// Example for basic usage of a mustache template.
void exampleUsageSnippet() {
  // #docregion example_usage
  String source = '''
    {{# names }}
            <div>{{ lastname }}, {{ firstname }}</div>
    {{/ names }}
    {{^ names }}
      <div>No names.</div>
    {{/ names }}
    {{! I am a comment. }}
  ''';

  Template template = Template(source, name: 'template-filename.html');

  String output = template.renderString(<String, dynamic>{
    'names': <Map<String, String>>[
      <String, String>{'firstname': 'Greg', 'lastname': 'Lowe'},
      <String, String>{'firstname': 'Bob', 'lastname': 'Johnson'}
    ]
  });
  // #enddocregion example_usage

  print(output);
}

/// Example for rendering nested paths in a template.
void nestedPathsSnippet() {
  // #docregion nested_paths
  Template template = Template('{{ author.name }}');
  String output = template.renderString(<String, dynamic>{
    'author': <String, String>{'name': 'Greg Lowe'}
  });
  // #enddocregion nested_paths
  print(output);
}

/// Example for using partials.
void partialsSnippet() {
  // #docregion partials
  Template partial = Template('{{ foo }}', name: 'partial');

  Template? resolver(String name) {
    if (name == 'partial-name') {
      // Name of partial tag.
      return partial;
    }
    return null;
  }

  Template t = Template('{{> partial-name }}', partialResolver: resolver);

  String output = t.renderString(<String, dynamic>{'foo': 'bar'});
  // #enddocregion partials
  print(output); // bar
}

/// Example for using lambdas in a template.
void lambdasSnippet() {
  // #docregion lambdas
  // Simple lambda
  Template t1 = Template('{{# foo }}inner{{/ foo }}');
  Object lambda1(Object? _) => 'bar';
  // #enddocregion lambdas
  print(t1.renderString(<String, dynamic>{'foo': lambda1})); // bar

  // #docregion lambdas
  // Lambda returning text for a hidden section
  Template t2 = Template('{{# foo }}hidden{{/ foo }}');
  Object lambda2(Object? _) => 'shown';
  // #enddocregion lambdas
  print(t2.renderString(<String, dynamic>{'foo': lambda2})); // shown

  // #docregion lambdas
  // Lambda Context
  Template t3 = Template('{{# foo }}oi{{/ foo }}');
  Object lambda3(LambdaContext ctx) =>
      '<b>${ctx.renderString().toUpperCase()}</b>';
  // #enddocregion lambdas
  print(t3.renderString(<String, dynamic>{'foo': lambda3})); // <b>OI</b>

  // #docregion lambdas
  // Lambda Context with variables
  Template t4 = Template('{{# foo }}{{bar}}{{/ foo }}');
  Object lambda4(LambdaContext ctx) =>
      '<b>${ctx.renderString().toUpperCase()}</b>';
  // #enddocregion lambdas
  print(t4.renderString(
      <String, dynamic>{'foo': lambda4, 'bar': 'pub'})); // <b>PUB</b>

  // #docregion lambdas
  // Lambda Context re-parsing source
  Template t5 = Template('{{# foo }}{{bar}}{{/ foo }}');
  Object lambda5(LambdaContext ctx) =>
      ctx.renderSource('${ctx.source} {{cmd}}');
  // #enddocregion lambdas
  print(t5.renderString(<String, dynamic>{
    'foo': lambda5,
    'bar': 'pub',
    'cmd': 'build'
  })); // pub build
}
