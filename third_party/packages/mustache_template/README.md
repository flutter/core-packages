# Mustache templates

A Dart library to parse and render [mustache templates](https://mustache.github.io/).

See the [mustache manual](https://mustache.github.io/mustache.5.html) for detailed usage information.

This library passes all [mustache specification](https://github.com/mustache/spec/tree/master/specs) tests.

## Example usage

<?code-excerpt "main.dart (example_usage)"?>
```dart
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
```

A template is parsed when it is created, after parsing it can be rendered any number of times with different values. A TemplateException is thrown if there is a problem parsing or rendering the template.

The Template constructor allows passing a name, this name will be used in error messages. When working with a number of templates, it is important to pass a name so that the error messages specify which template caused the error.

By default all output from `{{variable}}` tags is html escaped, this behaviour can be changed by passing htmlEscapeValues : false to the Template constructor. You can also use a `{{{triple mustache}}}` tag, or a unescaped variable tag `{{&unescaped}}`, the output from these tags is not escaped.

## Differences between strict mode and lenient mode.

### Strict mode (default)

* Tag names may only contain the characters a-z, A-Z, 0-9, underscore, period and minus. Other characters in tags will cause a TemplateException to be thrown during parsing.

* During rendering, if no map key or object member which matches the tag name is found, then a TemplateException will be thrown.

### Lenient mode

* Tag names may use any characters.
* During rendering, if no map key or object member which matches the tag name is found, then silently ignore and output nothing.

## Nested paths

<?code-excerpt "main.dart (nested_paths)"?>
```dart
  final Template template = Template('The author is {{ author.name }}');
  final String output = template.renderString(<String, dynamic>{
    'author': <String, String>{'name': 'Greg Lowe'},
  });
```

## Partials - example usage

<?code-excerpt "main.dart (partials)"?>
```dart
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
```

## Lambdas - example usage

<?code-excerpt "main.dart (lambdas)"?>
```dart
  // Simple lambda
  final Template t1 = Template('{{# foo }}inner{{/ foo }}');
  Object lambda1(Object? _) => 'bar';

  // Lambda returning text for a hidden section
  final Template t2 = Template('{{# foo }}hidden{{/ foo }}');
  Object lambda2(Object? _) => 'shown';

  // Lambda Context
  final Template t3 = Template('{{# foo }}oi{{/ foo }}');
  Object lambda3(LambdaContext ctx) =>
      '<b>${ctx.renderString().toUpperCase()}</b>';

  // Lambda Context with variables
  final Template t4 = Template('{{# foo }}{{bar}}{{/ foo }}');
  Object lambda4(LambdaContext ctx) =>
      '<b>${ctx.renderString().toUpperCase()}</b>';

  // Lambda Context re-parsing source
  final Template t5 = Template('{{# foo }}{{bar}}{{/ foo }}');
  Object lambda5(LambdaContext ctx) =>
      ctx.renderSource('${ctx.source} {{cmd}}');
```

In the last lambda example `LambdaContext.renderSource(source)` re-parses the source string in the current context, this is the default behaviour in many mustache implementations. Since re-parsing the content is slow, and often not required, this library makes this step optional.
