<?code-excerpt path-base="example/lib"?>

# Mustache templates

A Dart library to parse and render [mustache templates](https://mustache.github.io/).

See the [mustache manual](https://mustache.github.io/mustache.5.html) for detailed usage information.

This library passes all [mustache specification](https://github.com/mustache/spec/tree/master/specs) tests.

## Example usage

<?code-excerpt "readme_excerpts.dart (basic)"?>
```dart
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
```

A template is parsed when it is created, after parsing it can be rendered any number of times with different values. A TemplateException is thrown if there is a problem parsing or rendering the template.

The Template contstructor allows passing a name, this name will be used in error messages. When working with a number of templates, it is important to pass a name so that the error messages specify which template caused the error.

By default all output from `{{variable}}` tags is html escaped, this behaviour can be changed by passing htmlEscapeValues : false to the Template constructor. You can also use a `{{{triple mustache}}}` tag, or a unescaped variable tag `{{&unescaped}}`, the output from these tags is not escaped.

## Differences between strict mode and lenient mode.

### Strict mode (default)

* Tag names may only contain the characters a-z, A-Z, 0-9, underscore, period and minus. Other characters in tags will cause a TemplateException to be thrown during parsing.

* During rendering, if no map key or object member which matches the tag name is found, then a TemplateException will be thrown.

### Lenient mode

* Tag names may use any characters.
* During rendering, if no map key or object member which matches the tag name is found, then silently ignore and output nothing.

## Nested paths

<?code-excerpt "readme_excerpts.dart (nested)"?>
```dart
final template = Template('{{ author.name }}');
final output = template.renderString({'author': {'name': 'Greg Lowe'}});
```

## Partials - example usage

<?code-excerpt "readme_excerpts.dart (partials)"?>
```dart
final partial = Template('{{ foo }}', name: 'partial');
final resolver = (String name) {
  if (name == 'partial-name') {
    return partial;
  }
  return null;
};
final template = Template('{{> partial-name }}', partialResolver: resolver);
final output = template.renderString({'foo': 'bar'}); // bar
```

## Lambdas - example usage

<?code-excerpt "readme_excerpts.dart (lambda-render-string)"?>
```dart
final template = Template('{{# foo }}{{bar}}{{/ foo }}');
final lambda =
    (LambdaContext ctx) => '<b>${ctx.renderString().toUpperCase()}</b>';
final output =
    template.renderString({'foo': lambda, 'bar': 'pub'}); // <b>PUB</b>
```

In the following example `LambdaContext.renderSource(source)` re-parses the source string in the current context, this is the default behaviour in many mustache implementations. Since re-parsing the content is slow, and often not required, this library makes this step optional.

<?code-excerpt "readme_excerpts.dart (lambda-render-source)"?>
```dart
final template = Template('{{# foo }}{{bar}}{{/ foo }}');
final lambda =
    (LambdaContext ctx) => ctx.renderSource(ctx.source + ' {{cmd}}');
final output = template
    .renderString({'foo': lambda, 'bar': 'pub', 'cmd': 'build'}); // pub build
```