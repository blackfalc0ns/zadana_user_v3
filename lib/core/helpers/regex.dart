abstract class AppRegExp {
  static bool isNameValid(String name) {
    return RegExp(r"^[A-Za-z]{2,}$").hasMatch(name);
  }

  static bool isEmailValid(String email) {
    return RegExp(
      r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)+$",
    ).hasMatch(email);
  }

  static bool isPhoneNumberValid(String phoneNumber) {
    return RegExp(r"^01[0125][0-9]{8}$").hasMatch(phoneNumber);
  }

  static bool isOTPValid(String otp) {
    return RegExp(r"^[0-9]{6}$").hasMatch(otp);
  }

  static bool isPasswordValid(String password) {
    return RegExp(
      r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$",
    ).hasMatch(password);
  }
}
