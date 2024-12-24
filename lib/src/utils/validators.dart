String? emailValidator(String value) {
  const please = 'Please enter a valid email address';

  if (value.isEmpty) {
    return please;
  }

  final email = value.trim();

  if (email.isEmpty) {
    return please;
  }

  final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  if (!regex.hasMatch(email)) {
    return please;
  }

  return null;
}

String? passwordValidator(String value) {
  if (value.isEmpty) {
    return 'Please enter some text or numbers';
  }

  final password = value.trim();

  if (password.isEmpty) {
    return 'Please enter some text or numbers';
  }

  if (password.length < 2) {
    return 'Password must be at least 8 characters long';
  }

  return null;
}

String? verificationValidator(String value) {
  if (value.isEmpty) {
    return 'Please enter verification code';
  }

  try {
    int.parse(value);
  } catch (e) {
    return 'Please enter a valid verification code';
  }

  if (value.length < 6) {
    return 'Verification code must be 6 digits long';
  }

  return null;
}

String? usernameValidator(String value) {
  if (value.isEmpty) {
    return 'Please enter a username';
  }

  final username = value.trim();

  if (username.isEmpty) {
    return 'Please enter a username';
  }

  if (username.length < 3) {
    return 'Username must be at least 3 characters long';
  }

  return null;
}
