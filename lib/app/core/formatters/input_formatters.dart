import 'package:flutter/services.dart';

class CnpjInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    if (text.length > 14) {
      return oldValue;
    }
    
    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 2) {
        formatted += '.';
      } else if (i == 5) {
        formatted += '.';
      } else if (i == 8) {
        formatted += '/';
      } else if (i == 12) {
        formatted += '-';
      }
      formatted += text[i];
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    if (text.length > 8) {
      return oldValue;
    }
    
    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 5) {
        formatted += '-';
      }
      formatted += text[i];
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    if (text.length > 11) {
      return oldValue;
    }
    
    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 0) {
        formatted += '(';
      } else if (i == 2) {
        formatted += ') ';
      } else if (text.length == 11 && i == 7) {
        formatted += '-';
      } else if (text.length == 10 && i == 6) {
        formatted += '-';
      }
      formatted += text[i];
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class PercentageInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String text = newValue.text.replaceAll('%', '').replaceAll(RegExp(r'[^\d,.]'), '');
    
    if (text.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    
    text = text.replaceAll(',', '.');
    
    final dotIndex = text.indexOf('.');
    if (dotIndex != -1) {
      final beforeDot = text.substring(0, dotIndex);
      final afterDot = text.substring(dotIndex + 1).replaceAll('.', '');
      if (afterDot.length > 2) {
        text = '$beforeDot.${afterDot.substring(0, 2)}';
      } else {
        text = '$beforeDot.$afterDot';
      }
    }
    
    final formatted = text + '%';
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length - 1),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String text = newValue.text
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll(RegExp(r'[^\d,.]'), '');
    
    if (text.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    
    text = text.replaceAll(',', '.');
    
    final dotIndex = text.indexOf('.');
    if (dotIndex != -1) {
      final beforeDot = text.substring(0, dotIndex);
      final afterDot = text.substring(dotIndex + 1).replaceAll('.', '');
      if (afterDot.length > 2) {
        text = '$beforeDot.${afterDot.substring(0, 2)}';
      } else {
        text = '$beforeDot.$afterDot';
      }
    }
    
    String formatted;
    final parts = text.split('.');
    
    if (parts.length == 2) {
      final decimalPart = parts[1].length > 2 ? parts[1].substring(0, 2) : parts[1];
      formatted = 'R\$ ${parts[0]},$decimalPart';
    } else if (text.isNotEmpty) {
      formatted = 'R\$ $text';
    } else {
      formatted = 'R\$ 0';
    }
    
    final oldTextNumbers = oldValue.text
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll(RegExp(r'[^\d,.]'), '')
        .replaceAll(',', '.');
    
    int cursorOffset = formatted.length;
    
    if (oldTextNumbers.isNotEmpty && newValue.selection.baseOffset < oldValue.text.length) {
      final oldCursor = newValue.selection.baseOffset;
      final oldNumbersLength = oldTextNumbers.length;
      final newNumbersLength = text.length;
      final lengthDiff = newNumbersLength - oldNumbersLength;
      
      if (oldCursor > 3) {
        if (lengthDiff == 0) {
          cursorOffset = oldCursor.clamp(3, formatted.length);
        } else {
          cursorOffset = (oldCursor + lengthDiff).clamp(3, formatted.length);
        }
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }
}

class NumbersOnlyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
