import 'package:mustache_template/mustache_template.dart';
import 'package:test/test.dart';

void main() {
  test('renders basic list template', () {
    final source = '''
{{# names }}
  <div>{{ lastname }}, {{ firstname }}</div>
{{/ names }}
{{^ names }}
  <div>No names.</div>
{{/ names }}
''';
    final template = Template(source, name: 'template-filename.html');
    final output = template.renderString({
      'names': [
        {'firstname': 'Greg', 'lastname': 'Lowe'},
        {'firstname': 'Bob', 'lastname': 'Johnson'},
      ],
    });
    expect(output, contains('Lowe, Greg'));
    expect(output, contains('Johnson, Bob'));
  });

  test('renders nested paths', () {
    final template = Template('{{ author.name }}');
    final output = template.renderString({
      'author': {'name': 'Greg Lowe'},
    });
    expect(output, equals('Greg Lowe'));
  });

  test('renders partials', () {
    final partial = Template('{{ foo }}', name: 'partial');
    final resolver = (String name) {
      if (name == 'partial-name') {
        return partial;
      }
      return null;
    };
    final template = Template('{{> partial-name }}', partialResolver: resolver);
    final output = template.renderString({'foo': 'bar'});
    expect(output, equals('bar'));
  });

  test('renders lambda using renderString', () {
    final template = Template('{{# foo }}{{bar}}{{/ foo }}');
    final lambda = (LambdaContext ctx) => '<b>${ctx.renderString().toUpperCase()}</b>';
    final output = template.renderString({'foo': lambda, 'bar': 'pub'});
    expect(output, equals('<b>PUB</b>'));
  });

  test('renders lambda using renderSource', () {
    final template = Template('{{# foo }}{{bar}}{{/ foo }}');
    final lambda = (LambdaContext ctx) => ctx.renderSource(ctx.source + ' {{cmd}}');
    final output = template.renderString({'foo': lambda, 'bar': 'pub', 'cmd': 'build'});
    expect(output, equals('pub build'));
  });
}
