import 'package:flutter/services.dart';

class LineBreakLimitingTextInputFormatter extends TextInputFormatter {
  final int limit;

  LineBreakLimitingTextInputFormatter(this.limit) : assert(limit != null);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    return _selectionAwareTextManipulation(
      newValue,
          (String substring) {
        if("\n".allMatches(substring).length >= limit){
          substring = substring.split('').reversed.join('');
          String newText = substring.replaceFirst("\n", "");
          newText = newText.split('').reversed.join('');
          return newText;
        }
        return substring;
      },
    );
  }
}

TextEditingValue _selectionAwareTextManipulation(
    TextEditingValue value,
    String substringManipulation(String substring),
    ) {
  final int selectionStartIndex = value.selection.start;
  final int selectionEndIndex = value.selection.end;
  String manipulatedText;
  TextSelection manipulatedSelection;
  if (selectionStartIndex < 0 || selectionEndIndex < 0) {
    manipulatedText = substringManipulation(value.text);
  } else {
    final String beforeSelection = substringManipulation(
        value.text.substring(0, selectionStartIndex)
    );
    final String inSelection = substringManipulation(
        value.text.substring(selectionStartIndex, selectionEndIndex)
    );
    final String afterSelection = substringManipulation(
        value.text.substring(selectionEndIndex)
    );
    manipulatedText = beforeSelection + inSelection + afterSelection;
    if (value.selection.baseOffset > value.selection.extentOffset) {
      manipulatedSelection = value.selection.copyWith(
        baseOffset: beforeSelection.length + inSelection.length,
        extentOffset: beforeSelection.length,
      );
    } else {
      manipulatedSelection = value.selection.copyWith(
        baseOffset: beforeSelection.length,
        extentOffset: beforeSelection.length + inSelection.length,
      );
    }
  }
  return TextEditingValue(
    text: manipulatedText,
    selection: manipulatedSelection ?? const TextSelection.collapsed(offset: -1),
    composing: manipulatedText == value.text
        ? value.composing
        : TextRange.empty,
  );
}