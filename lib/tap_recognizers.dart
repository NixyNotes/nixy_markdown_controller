import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nixy_markdown_controller/patterns.dart';
import 'package:url_launcher/url_launcher.dart';

/// The TapRecognizers class provides methods for recognizing and handling tap gestures on specific
/// patterns in text editing values.
class TapRecognizers {
  /// The TapRecognizers class provides methods for recognizing and handling tap gestures on specific
  /// patterns in text editing values.
  TapRecognizers({
    required this.patternMatched,
    required this.match,
    required this.context,
  });

  /// `final Patterns patternMatched;` is declaring a final variable `patternMatched` of type `Patterns`.
  /// This variable is used to store the pattern that was matched in the text editing value.
  final Patterns patternMatched;

  /// `final String match;` is declaring a final variable `match` of type `String`. This variable is used
  /// to store the specific text that was matched by the pattern in the text editing value. It is used in
  /// the `onPressUrlPattern()`, `onPressCheckboxListPattern()`, and `onPressCheckboxDoneListPattern()`
  /// methods to manipulate the text in the text editing value based on the matched pattern.
  final String match;

  /// Build context for showing alerts.
  final BuildContext context;

  /// This function returns a TapGestureRecognizer that launches a URL if it matches a specified pattern.
  ///
  /// Returns:
  ///   A `TapGestureRecognizer` object is being returned.
  TapGestureRecognizer onPressUrlPattern() {
    return TapGestureRecognizer()
      ..onTap = () async {
        final regexp = RegExp(patternMatched.pattern).firstMatch(match);
        final url = regexp?.group(2);
        if (url != null) {
          final shouldOpen = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Nixy'),
                content: Text('Do you want to open $url?'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Cancel',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Open url'),
                  )
                ],
              );
            },
          );

          if (shouldOpen != null && shouldOpen) {
            final uri = Uri.parse(url);
            final canLaunch = await canLaunchUrl(uri);

            if (canLaunch) {
              await launchUrl(uri);
            }
          }
        }
      };
  }

  /// This function returns a TapGestureRecognizer that updates a given TextEditingValue with a new text
  /// value that replaces a specific pattern with a checkbox.
  ///
  /// Args:
  ///   value (TextEditingValue): A TextEditingValue object that represents the current value of the text
  /// field.
  ///   text (String): The original text that needs to be updated with a checkbox list pattern.
  ///   onUpdateValue (void Function(TextEditingValue newValue)): onUpdateValue is a callback function
  /// that takes in a new TextEditingValue as a parameter and updates the value of the text editing field.
  /// This function is called when the TapGestureRecognizer is triggered, which means when the user taps
  /// on a checkbox in the list pattern. The new value is created by replacing
  ///
  /// Returns:
  ///   A `TapGestureRecognizer` object is being returned.
  TapGestureRecognizer onPressCheckboxListPattern(
    TextEditingValue value,
    String text,
    void Function(TextEditingValue newValue) onUpdateValue,
  ) {
    return TapGestureRecognizer()
      ..onTap = () {
        final newValue = value.copyWith(
          composing: TextRange.empty,
          selection: TextSelection.collapsed(offset: text.length),
          text: text.replaceAll(
            match,
            "- [x] ${match.replaceAll("- [ ]", "")}",
          ),
        );

        onUpdateValue.call(newValue);
      };
  }

  /// This function returns a TapGestureRecognizer that updates a given TextEditingValue with a new text
  /// value that replaces a specific pattern with a checkbox.
  ///
  /// Args:
  ///   value (TextEditingValue): A TextEditingValue object that represents the current value of the text
  /// field.
  ///   text (String): The original text that needs to be updated with a checkbox list pattern.
  ///   onUpdateValue (void Function(TextEditingValue newValue)): onUpdateValue is a callback function
  /// that takes in a new TextEditingValue as a parameter and updates the value of the text editing field.
  /// This function is called when the TapGestureRecognizer is triggered, which means when the user taps
  /// on a checkbox in the list pattern. The new value is created by replacing
  ///
  /// Returns:
  ///   A `TapGestureRecognizer` object is being returned.
  TapGestureRecognizer onPressCheckboxDoneListPattern(
    TextEditingValue value,
    String text,
    void Function(TextEditingValue newValue) onUpdateValue,
  ) {
    return TapGestureRecognizer()
      ..onTap = () {
        final newValue = value.copyWith(
          composing: TextRange.empty,
          selection: TextSelection.collapsed(offset: text.length),
          text: text.replaceAll(
            match,
            "- [ ] ${match.replaceAll("- [x]", "")}",
          ),
        );

        onUpdateValue.call(newValue);
      };
  }
}
