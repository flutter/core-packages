// ignore_for_file: avoid_print

import 'package:mustache_template/mustache_template.dart';

void _basicUsage() {
  // #docregion BasicUsage
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

  final String output = template.renderString(<String, Object>{
    'names': <Map<String, String>>[
      <String, String>{'firstname': 'Greg', 'lastname': 'Lowe'},
      <String, String>{'firstname': 'Bob', 'lastname': 'Johnson'},
    ],
  });
  // #enddocregion BasicUsage
  print(output);
}

void _nestedPaths() {
  // #docregion NestedPaths
  final template = Template('{{ author.name }}');
  final String output = template.renderString(<String, Object>{
    'author': <String, String>{'name': 'Greg Lowe'},
  });
  // #enddocregion NestedPaths
  print(output);
}

void _partials() {
  // #docregion Partials
  final partial = Template('{{ foo }}', name: 'partial');

  Template? resolver(String name) {
    if (name == 'partial-name') {
      // Name of partial tag.
      return partial;
    }
    return null;
  }

  final template = Template('{{> partial-name }}', partialResolver: resolver);

  final String output = template.renderString(<String, String>{'foo': 'bar'}); // bar
  // #enddocregion Partials
  print(output);
}

void _lambdaReturningValue() {
  // #docregion LambdaReturningValue
  final template = Template('{{# foo }}inner{{/ foo }}');
  Object lambda(Object? _) => 'bar';
  final String output = template.renderString(<String, Object>{'foo': lambda}); // bar
  // #enddocregion LambdaReturningValue
  print(output);
}

void _lambdaHidingSection() {
  // #docregion LambdaHidingSection
  final template = Template('{{# foo }}hidden{{/ foo }}');
  Object lambda(Object? _) => 'shown';
  final String output = template.renderString(<String, Object>{'foo': lambda}); // shown
  // #enddocregion LambdaHidingSection
  print(output);
}

void _lambdaWithContext() {
  // #docregion LambdaWithContext
  final template = Template('{{# foo }}oi{{/ foo }}');
  Object lambda(LambdaContext ctx) => '<b>${ctx.renderString().toUpperCase()}</b>';
  final String output = template.renderString(<String, Object>{'foo': lambda}); // <b>OI</b>
  // #enddocregion LambdaWithContext
  print(output);
}

void _lambdaWithContextAndVariables() {
  // #docregion LambdaWithContextAndVariables
  final template = Template('{{# foo }}{{bar}}{{/ foo }}');
  Object lambda(LambdaContext ctx) => '<b>${ctx.renderString().toUpperCase()}</b>';
  final String output = template.renderString(<String, Object>{
    'foo': lambda,
    'bar': 'pub',
  }); // <b>PUB</b>
  // #enddocregion LambdaWithContextAndVariables
  print(output);
}

void _lambdaReparsingSource() {
  // #docregion LambdaReparsingSource
  final template = Template('{{# foo }}{{bar}}{{/ foo }}');
  Object lambda(LambdaContext ctx) => ctx.renderSource('${ctx.source} {{cmd}}');
  final String output = template.renderString(<String, Object>{
    'foo': lambda,
    'bar': 'pub',
    'cmd': 'build',
  }); // pub build
  // #enddocregion LambdaReparsingSource
  print(output);
}

void main() {
  _basicUsage();
  _nestedPaths();
  _partials();
  _lambdaReturningValue();
  _lambdaHidingSection();
  _lambdaWithContext();
  _lambdaWithContextAndVariables();
  _lambdaReparsingSource();
}
