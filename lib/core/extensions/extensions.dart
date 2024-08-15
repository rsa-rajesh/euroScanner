const empty = '';
const zero = 0.0;
const emptyList = [];

extension ExtenstionOnString on String? {
  String orEmpty() {
    if (this == null) {
      return empty;
    } else {
      return this!;
    }
  }

  bool containesDigit() {
    if (this == null) {
      return false;
    } else {
      bool found = this!.contains(RegExp(r'[0-9]'));
      return found;
    }
  }

  String firstWord() {
    if (this == null) {
      return empty;
    } else {
      List<String> wordList = this!.split(" ");
      if (wordList.isNotEmpty) {
        return wordList[0];
      } else {
        return ' ';
      }
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension ExtenstionOnNum<T extends num> on T? {
  T orZero() {
    if (this == null) {
      return zero as T;
    } else {
      switch (T) {
        case int:
          return this as T;
        case double:
          return this as T;
        default:
          // this happens when the call-site forgets
          // to specify the generic type argument
          return 0 as T;
      }
    }
  }
}

extension ExtenstionOnList<T> on List<T>? {
  List<T> orEmptyList() {
    if (this == null) {
      return <T>[];
    } else {
      return this!;
    }
  }
}
