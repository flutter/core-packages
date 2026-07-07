<?code-excerpt path-base="example/lib"?>

# listen

A package to notify state changes to interested listeners in pure Dart.

## Usage

### Using ValueNotifier

`ValueNotifier` wraps a single value and notifies listeners whenever the value changes:

<?code-excerpt "readme_excerpts.dart (ValueNotifier)"?>
```dart
void valueNotifierExample() {
  final counter = ValueNotifier<int>(0);

  counter.addListener(() {
    print('Value changed: ${counter.value}');
  });

  counter.value = 5; // Prints: Value changed: 5
  counter.value = 10; // Prints: Value changed: 10
  counter.value = 10; // Does not print because the value is == 10

  counter.dispose();
}

```

### Using ChangeNotifier

Extend or mix in `ChangeNotifier` to manage state and notify listeners manually:

<?code-excerpt "readme_excerpts.dart (ChangeNotifierClass)"?>
```dart
/// A [ChangeNotifier] subclass that encapsulates a list of items and notifies
/// listeners whenever items are added or removed.
class ItemListNotifier extends ChangeNotifier {
  final List<String> _items = <String>[];

  /// The unmodifiable list of current items.
  List<String> get items => List<String>.unmodifiable(_items);

  /// Adds an [item] to the list and notifies listeners.
  void addItem(String item) {
    _items.add(item);
    notifyListeners();
  }

  /// Removes an [item] from the list and notifies listeners if it was present.
  void removeItem(String item) {
    if (_items.remove(item)) {
      notifyListeners();
    }
  }
}

```

Then, listen to changes and update state:

<?code-excerpt "readme_excerpts.dart (ChangeNotifierUsage)"?>
```dart
void changeNotifierExample() {
  final listNotifier = ItemListNotifier();

  listNotifier.addListener(() {
    print('Current items: ${listNotifier.items}');
  });

  listNotifier.addItem('Apple'); // Prints: Current items: [Apple]
  listNotifier.addItem('Banana'); // Prints: Current items: [Apple, Banana]
  listNotifier.removeItem('Apple'); // Prints: Current items: [Banana]

  listNotifier.dispose();
}

```

### Merging listenables

Use `Listenable.merge` to listen to multiple objects simultaneously:

<?code-excerpt "readme_excerpts.dart (Merge)"?>
```dart
void mergeExample() {
  final first = ValueNotifier<String>('Hello');
  final second = ValueNotifier<String>('World');

  final merged = Listenable.merge(<Listenable>[first, second]);

  merged.addListener(() {
    print('Merged listenable triggered: ${first.value} ${second.value}');
  });

  first.value = 'Hi'; // Prints: Merged listenable triggered: Hi World
  second.value = 'Dart'; // Prints: Merged listenable triggered: Hi Dart

  first.dispose();
  second.dispose();
}
```
