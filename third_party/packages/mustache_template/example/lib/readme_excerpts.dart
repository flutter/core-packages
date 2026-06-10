// ignore_for_file: avoid_print

import 'package:mustache_template/mustache_template.dart';

void renderBasicTemplate() {
  // #docregion basic
  final source = '''
{{# names }}
  <div>{{ lastname }}, {{ firstname }}</div>
{{/ names }}
{{^ names }}
  <div>No names.</div>
{{/ names }}
{{! I am a comment. }}
''';
  final template = Template(source, name: 'template-filename.html');
  final output = template.renderString({
    'names': [
      {'firstname': 'Greg', 'lastname': 'Lowe'},
      {'firstname': 'Bob', 'lastname': 'Johnson'},
    ],
  });
  // #enddocregion basic
  print(output);
}

void renderNestedPaths() {
  // #docregion nested
  final template = Template('{{ author.name }}');
  final output = template.renderString({
    'author': {'name': 'Greg Lowe'},
  });
  // #enddocregion nested
  print(output);
}

void renderPartials() {
  // #docregion partials
  final partial = Template('{{ foo }}', name: 'partial');
  final resolver = (String name) {
    if (name == 'partial-name') {
      return partial;
    }
    return null;
  };
  final template = Template('{{> partial-name }}', partialResolver: resolver);
  final output = template.renderString({'foo': 'bar'}); // bar
  // #enddocregion partials
  print(output);
}

void renderLambdaRenderString() {
  // #docregion lambda-render-string
  final template = Template('{{# foo }}{{bar}}{{/ foo }}');
  final lambda = (LambdaContext ctx) => '<b>${ctx.renderString().toUpperCase()}</b>';
  final output = template.renderString({'foo': lambda, 'bar': 'pub'}); // <b>PUB</b>
  // #enddocregion lambda-render-string
  print(output);
}

void renderLambdaRenderSource() {
  // #docregion lambda-render-source
  final template = Template('{{# foo }}{{bar}}{{/ foo }}');
  final lambda = (LambdaContext ctx) => ctx.renderSource(ctx.source + ' {{cmd}}');
  final output = template.renderString({'foo': lambda, 'bar': 'pub', 'cmd': 'build'}); // pub build
  // #enddocregion lambda-render-source
  print(output);
}

void main() {
  renderBasicTemplate();
  renderNestedPaths();
  renderPartials();
  renderLambdaRenderString();
  renderLambdaRenderSource();
}
