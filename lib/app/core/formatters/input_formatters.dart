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

class ValueInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove todos os caracteres não numéricos exceto vírgula e ponto
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    
    // Converte para número e formata como centavos
    // Ex: 1234 -> 12,34 | 123 -> 1,23 | 12 -> 0,12
    final value = int.parse(digitsOnly);
    final cents = value % 100;
    final reais = value ~/ 100;
    
    // Formata com separador de milhar e vírgula para decimais
    String formatted;
    if (reais == 0 && cents == 0) {
      formatted = 'R\$ 0,00';
    } else {
      final reaisStr = reais.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
      formatted = 'R\$ $reaisStr,${cents.toString().padLeft(2, '0')}';
    }
    
    // Calcula a posição do cursor
    int cursorPosition = formatted.length;
    
    // Se está editando (não apenas adicionando no final)
    if (newValue.selection.baseOffset < oldValue.text.length) {
      final oldCursorPos = newValue.selection.baseOffset;
      
      // Conta quantos dígitos havia antes do cursor na string antiga
      final oldTextBeforeCursor = oldValue.text.substring(0, oldCursorPos);
      final digitsBeforeOldCursor = oldTextBeforeCursor.replaceAll(RegExp(r'[^\d]'), '').length;
      
      // Conta quantos dígitos existem na nova string formatada
      final oldDigitsOnly = oldValue.text.replaceAll(RegExp(r'[^\d]'), '');
      final isDeleting = digitsOnly.length < oldDigitsOnly.length;
      
      // Ajusta a posição do cursor baseado na quantidade de dígitos
      int targetDigits = digitsBeforeOldCursor;
      if (isDeleting) {
        // Ao apagar, mantém a posição relativa, mas não pode ser maior que o total de dígitos
        targetDigits = digitsBeforeOldCursor.clamp(0, digitsOnly.length);
      } else {
        // Ao adicionar, mantém a posição após os dígitos digitados
        targetDigits = digitsBeforeOldCursor.clamp(0, digitsOnly.length);
      }
      
      // Encontra a posição correspondente na nova string formatada
      int digitsCount = 0;
      for (int i = 0; i < formatted.length; i++) {
        if (RegExp(r'\d').hasMatch(formatted[i])) {
          digitsCount++;
          if (digitsCount >= targetDigits) {
            // Coloca o cursor após o dígito encontrado
            cursorPosition = (i + 1).clamp(3, formatted.length);
            break;
          }
        }
      }
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
  
  /// Extrai o valor numérico como string (double formatado como string)
  static String getValueAsString(String formattedValue) {
    if (formattedValue.isEmpty) return '';
    
    // Remove formatação e converte para double
    String digitsOnly = formattedValue.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.isEmpty) return '0';
    
    // Converte centavos para reais
    final value = int.parse(digitsOnly);
    final doubleValue = value / 100.0;
    
    return doubleValue.toString();
  }
}
