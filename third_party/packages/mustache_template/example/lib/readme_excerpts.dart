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

  print(output);
  // #enddocregion example_usage
}

void nestedPathsSnippet() {
  // #docregion nested_paths
  Template template = Template('{{ author.name }}');
  String output = template.renderString(<String, dynamic>{
    'author': <String, String>{'name': 'Greg Lowe'}
  });
  print(output);
  // #enddocregion nested_paths
}

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
  print(output); // bar
  // #enddocregion partials
}

void lambdasSnippet() {
  // #docregion lambdas
  // Simple lambda
  Template t1 = Template('{{# foo }}inner{{/ foo }}');
  Object lambda1(Object? _) => 'bar';
  print(t1.renderString(<String, dynamic>{'foo': lambda1})); // bar

  // Lambda returning text for a hidden section
  Template t2 = Template('{{# foo }}hidden{{/ foo }}');
  Object lambda2(Object? _) => 'shown';
  print(t2.renderString(<String, dynamic>{'foo': lambda2})); // shown

  // Lambda Context
  Template t3 = Template('{{# foo }}oi{{/ foo }}');
  Object lambda3(LambdaContext ctx) => '<b>${ctx.renderString().toUpperCase()}</b>';
  print(t3.renderString(<String, dynamic>{'foo': lambda3})); // <b>OI</b>

  // Lambda Context with variables
  Template t4 = Template('{{# foo }}{{bar}}{{/ foo }}');
  Object lambda4(LambdaContext ctx) => '<b>${ctx.renderString().toUpperCase()}</b>';
  print(t4.renderString(<String, dynamic>{'foo': lambda4, 'bar': 'pub'})); // <b>PUB</b>
  
  // Lambda Context re-parsing source
  Template t5 = Template('{{# foo }}{{bar}}{{/ foo }}');
  Object lambda5(LambdaContext ctx) => ctx.renderSource('${ctx.source} {{cmd}}');
  print(t5.renderString(<String, dynamic>{'foo': lambda5, 'bar': 'pub', 'cmd': 'build'})); // pub build
  // #enddocregion lambdas
}
