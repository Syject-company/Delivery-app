class Validator {
  static String? pass(String text) {
    if (RegExp(
            "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[#\$@!%&*?])[A-Za-z\\d#\$@!%&*?]{6,30}\$")
        .hasMatch(text)) {
      return null;
    } else {
      return "The password must contain at least one number, uppercase and lowercase letters, a non-alphanumeric character, and must be at least 6 characters long.";
    }
  }

  static String? notEmpty(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      return null;
    }
    return "This field must not be empty";
  }

  static String? phone(String value) {
    if (RegExp("^\\+\\d{5,15}\$").hasMatch(value)) {
      return null;
    } else {
      return "The number is not valid";
    }
  }

  static String? email(String value) {
    if (RegExp("^\S+@\S+\.\S+\$").hasMatch(value)) {
      return "Invalid email";
    } else {
      return null;
    }
  }
}
