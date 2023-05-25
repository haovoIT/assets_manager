import 'dart:async';

class Validators {
  Validators();
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email))
      return sink.addError('Email chưa đúng');
    else
      return sink.add(email);
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(password))
      return sink.addError(
          'Mật khẩu có ít nhất 6 kí tự gồm 1 chữ hoa, 1 chữ thường, 1 chữ số và 1 kí tự đặt biệt');
    else
      return sink.add(password);
  });

  String? empty(String? value, String? message) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }

  String? checkForDuplicates(String? valueCheck, String? valueDuplicate,
      Map<String, dynamic> message) {
    if (valueCheck!.isEmpty) {
      return message['EMPTY_VALUE_CHECK'];
    }

    if (valueDuplicate!.isEmpty) {
      return message['EMPTY_VALUE_DUPLICATE'];
    }
    if (valueCheck != valueDuplicate) {
      return message['ERROR_MASSAGE'];
    }
    return null;
  }

  String? checkForNoDuplicates(String? valueCheck, String? valueDuplicate,
      Map<String, dynamic> message) {
    if (valueCheck!.isEmpty) {
      return message['EMPTY_VALUE_CHECK'];
    }

    if (valueDuplicate!.isEmpty) {
      return message['EMPTY_VALUE_DUPLICATE'];
    }
    if (valueCheck == valueDuplicate) {
      return message['ERROR_NO_DUPLICATES'];
    }
    return null;
  }

  String? checkAmount(
      String? amount, String? amountConvert, Map<String, dynamic> message) {
    if (amount!.isEmpty) {
      return message['EMPTY_AMOUNT'];
    }

    if (amountConvert!.isEmpty) {
      return message['EMPTY_AMOUNT_CONVERT'];
    }
    if (int.parse(amount) <= int.parse(amountConvert)) {
      return message['ERROR_CHECK_AMOUNT'];
    }
    return null;
  }

  String? money(String? value, String? message) {
    double flag = double.parse(value!.replaceAll(".", ""));
    if (flag == 0) {
      return message;
    }
    return null;
  }

  String? validateForm(List<String?> validateGroup) {
    var length = validateGroup.length;
    for (var i = 0; i < length; i++) {
      String? message = validateGroup[i];
      if (message != null) {
        return message;
      } else {
        if (i == length - 1) {
          return "";
        } else {}
      }
    }
    return null;
  }
}
