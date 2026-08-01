// Copyright 2026 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// #docregion example_usage
import 'package:mustache_template/mustache_template.dart';

void main() {
  exampleUsage();
  nestedPaths();
  partialsExample();
  lambdasExample();
}

void exampleUsage() {
  final String source = '''
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
      <String, String>{'firstname': 'Bob', 'lastname': 'Johnson'}
    ]
  });

  print(output);
}
// #enddocregion example_usage

// #docregion nested_paths
void nestedPaths() {
  final Template template = Template('{{ author.name }}');
  final String output = template.renderString(<String, dynamic>{
    'author': <String, String>{'name': 'Greg Lowe'}
  });
  print(output);
}
// #enddocregion nested_paths

// #docregion partials
void partialsExample() {
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
  print(output); // bar
}
// #enddocregion partials

// #docregion lambdas
void lambdasExample() {
  // Simple lambda
  final Template t1 = Template('{{# foo }}inner{{/ foo }}');
  final dynamic lambda1 = (_) => 'bar';
  print(t1.renderString(<String, dynamic>{'foo': lambda1})); // bar

  // Lambda returning text for a hidden section
  final Template t2 = Template('{{# foo }}hidden{{/ foo }}');
  final dynamic lambda2 = (_) => 'shown';
  print(t2.renderString(<String, dynamic>{'foo': lambda2})); // shown

  // Lambda Context
  final Template t3 = Template('{{# foo }}oi{{/ foo }}');
  final dynamic lambda3 =
      (LambdaContext ctx) => '<b>${ctx.renderString().toUpperCase()}</b>';
  print(t3.renderString(<String, dynamic>{'foo': lambda3})); // <b>OI</b>

  // Lambda Context with variables
  final Template t4 = Template('{{# foo }}{{bar}}{{/ foo }}');
  final dynamic lambda4 =
      (LambdaContext ctx) => '<b>${ctx.renderString().toUpperCase()}</b>';
  print(t4.renderString(
      <String, dynamic>{'foo': lambda4, 'bar': 'pub'})); // <b>PUB</b>

  // Lambda Context re-parsing source
  final Template t5 = Template('{{# foo }}{{bar}}{{/ foo }}');
  final dynamic lambda5 =
      (LambdaContext ctx) => ctx.renderSource('${ctx.source} {{cmd}}');
  print(t5.renderString(<String, dynamic>{
    'foo': lambda5,
    'bar': 'pub',
    'cmd': 'build'
  })); // pub build
}
// #enddocregion lambdas
