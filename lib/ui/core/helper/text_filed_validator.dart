class TextFiledValidator {
  TextFiledValidator._();

  static List<String> passwordErrors(String? value) {
    final errors = <String>[];

    if (value == null || value.trim().isEmpty) {
      errors.add('يجب إدخال كلمة المرور');
      return errors;
    }

    if (value.length < 8) {
      errors.add('يجب أن تكون كلمة المرور 8 أحرف على الأقل');
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      errors.add('يجب أن تحتوي كلمة المرور على حرف كبير');
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      errors.add('يجب أن تحتوي كلمة المرور على حرف صغير');
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      errors.add('يجب أن تحتوي كلمة المرور على رقم');
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      errors.add('يجب أن تحتوي كلمة المرور على رمز خاص');
    }

    if (RegExp(r'\s').hasMatch(value)) {
      errors.add('يجب ألا تحتوي كلمة المرور على مسافات');
    }

    return errors;
  }

  static String? passwordValidator(String? value) {
    final errors = passwordErrors(value);

    if (errors.isEmpty) return null;

    return errors.first;
  }
}
