// Form validators shared by all screens. Each returns an error message or null.
class Validators {
  static final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
  // Optional leading +, then 8-15 digits/spaces (matches the Laravel rule)
  static final _phoneRegex = RegExp(r'^\+?[0-9 ]{8,15}$');

  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return 'Please enter $fieldName';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your email';
    if (!_emailRegex.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter a phone number';
    if (!_phoneRegex.hasMatch(value.trim())) return 'Enter a valid phone number (e.g. 012 345 678)';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Za-z]').hasMatch(value) || !RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain letters and numbers';
    }
    return null;
  }

  static String? price(String? value) {
    final number = double.tryParse(value?.trim() ?? '');
    if (number == null) return 'Enter a valid price';
    if (number < 0) return 'Price cannot be negative';
    return null;
  }

  static String? stock(String? value) {
    final number = int.tryParse(value?.trim() ?? '');
    if (number == null) return 'Enter a whole number';
    if (number < 0) return 'Stock cannot be negative';
    return null;
  }
}
