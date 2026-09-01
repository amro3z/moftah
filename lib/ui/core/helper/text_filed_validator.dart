class TextFiledValidator {
  TextFiledValidator._();

  static List<String> passwordErrors(String? value) {
    final errors = <String>[];
    // Password validation
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

  // Name validation
  static List<String> nameErrors(String? value) {
    final errors = <String>[];

    if (value == null || value.trim().isEmpty) {
      errors.add('يجب إدخال الاسم');
      return errors;
    }

    if (RegExp(r'[0-9]').hasMatch(value)) {
      errors.add('يجب ألا تحتوي الاسم على أرقام');
    }

    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      errors.add('يجب ألا تحتوي الاسم على رمز خاص');
    }

    if (value.startsWith(' ') || value.endsWith(' ')) {
      errors.add('يجب ألا يبدأ أو ينتهي الاسم بمسافة');
    } 

    return errors;
  }

  static String? nameValidator(String? value) {
    final errors = nameErrors(value);

    if (errors.isEmpty) return null;

    return errors.first;
  }

  // Email validation
  static List<String> emailErrors(String? value) {
    final errors = <String>[];

    if (value == null || value.trim().isEmpty) {
      errors.add('يجب إدخال البريد الإلكتروني');
      return errors;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      errors.add('البريد الإلكتروني غير صالح');
    }

    return errors;
  }

  static String? emailValidator(String? value) {
    final errors = emailErrors(value);

    if (errors.isEmpty) return null;

    return errors.first;
  }

  // Phone number validation
  static List<String> phoneErrors(String? value) {
    final errors = <String>[];

    if (value == null || value.trim().isEmpty) {
      errors.add('يجب إدخال رقم الهاتف');
      return errors;
    }

    if (!RegExp(r'^\d{11}$').hasMatch(value)) {
      errors.add('رقم الهاتف غير صالح');
    }

    return errors;
  }

  static String? phoneValidator(String? value) {
    final errors = phoneErrors(value);

    if (errors.isEmpty) return null;

    return errors.first;
  }
}
