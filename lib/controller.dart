import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nixy_markdown_controller/patterns.dart';
import 'package:nixy_markdown_controller/tap_recognizers.dart';

/// The NixyTextFieldController class is a custom implementation of the TextEditingController in Dart
/// that supports various text patterns and styles, including URLs, checkboxes, and code blocks.
class NixyTextFieldController extends TextEditingController {
  /// The NixyTextFieldController class is a custom implementation of the TextEditingController in Dart
  /// that supports various text patterns and styles, including URLs, checkboxes, and code blocks.
  NixyTextFieldController(this.patterns, this.context)
      : pattern = RegExp(
          patterns.keys.map((key) {
            return Patterns.values
                .firstWhere((element) => element.pattern == key)
                .pattern;
          }).join('|'),
          multiLine: true,
        );

  /// `final Map<String, TextStyle> patterns;` is declaring a final variable `patterns` of type
  /// `Map<String, TextStyle>`. This variable is used to store the different text patterns and their
  /// corresponding text styles that the `NixyTextFieldController` class supports, such as URLs,
  /// checkboxes, and code blocks. The keys of the map are the pattern strings, and the values are the
  /// corresponding `TextStyle` objects that define how the text should be styled when that pattern is
  /// matched.
  final Map<String, TextStyle> patterns;

  /// The `final Pattern pattern;` line is declaring a final variable `pattern` of type `Pattern`. This
  /// variable is used to store a regular expression pattern that matches the different text patterns that
  /// the `NixyTextFieldController` class supports, such as URLs, checkboxes, and code blocks. The regular
  /// expression pattern is created by joining the keys of the `patterns` map with the `|` character,
  /// which means "or" in regular expressions. The `multiLine: true` parameter is used to indicate that
  /// the regular expression should match across multiple lines. This `pattern` variable is used in the
  /// `splitMapJoin` method in the `buildTextSpan` method to split the text into different parts based on
  /// the regular expression pattern.
  final Pattern pattern;

  /// Build context
  final BuildContext context;

  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }

  TapGestureRecognizer? _checkboxTapRecognizer(
    String match,
    Patterns patternMatched,
  ) {
    final recognizers = TapRecognizers(
      patternMatched: patternMatched,
      match: match,
      context: context,
    );

    if (patternMatched == Patterns.URL_PATTERN) {
      return recognizers.onPressUrlPattern();
    }

    if (patternMatched == Patterns.CHECKBOX_LIST_PATTERN) {
      recognizers.onPressCheckboxListPattern(value, text, (newValue) {
        value = newValue;
      });
    }
    if (patternMatched == Patterns.CHECKBOX_LIST_DONE_PATTERN) {
      return recognizers.onPressCheckboxDoneListPattern(value, text,
          (newValue) {
        value = newValue;
      });
    }

    return null;
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    final children = <InlineSpan>[];
    Patterns? patternMatched;
    String? formatText;
    TextStyle? myStyle;

    text.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        myStyle = patterns[match[0]] ??
            patterns[patterns.keys.firstWhere(
              (e) {
                var ret = false;
                RegExp(e, multiLine: true).allMatches(text).forEach((element) {
                  if (element.group(0) == match[0]) {
                    patternMatched =
                        Patterns.values.firstWhere((s) => s.pattern == e);
                    ret = true;
                    return;
                  }
                });
                return ret;
              },
            )];

        switch (patternMatched!) {
          case Patterns.BOLD_TEXT_PATTERN:
            formatText = match[0];
          case Patterns.CHECKBOX_LIST_PATTERN:
            formatText = match[0]?.replaceAll('- [ ]', '   ☐ ');
          case Patterns.CHECKBOX_LIST_DONE_PATTERN:
            formatText = match[0]?.replaceAll('- [x]', '   ☑ ');
          case Patterns.CODE_PATTERN:
            formatText = match[0];
          case Patterns.URL_PATTERN:
            formatText = match[0];
          case Patterns.HEADERS_PATTERN:
            formatText = match[2];
        }

        children.addAll([
          if (match[1] != null)
            TextSpan(
              text: match[1],
              style: myStyle?.merge(
                const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
              ),
            ),
          TextSpan(
            text: formatText,
            style: style?.merge(myStyle),
            recognizer: _checkboxTapRecognizer(match[0]!, patternMatched!),
          ),
        ]);
        return '';
      },
      onNonMatch: (String text) {
        children.add(TextSpan(text: text, style: style));
        return '';
      },
    );

    return TextSpan(style: style, children: children);
  }
}
