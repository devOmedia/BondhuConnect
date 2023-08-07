bool validatePhoneNumber(String phoneNumber) {
  // // Regular expression to match a Bangladeshi phone number with country code
  // final RegExp regex = RegExp(r'^\+\d{11}$');

  // // Check if the phone number matches the regular expression
  // return regex.hasMatch(phoneNumber);

  if (phoneNumber.contains("+")) {
    if (phoneNumber.length > 10) {
      return true;
    }
  }

  return false;
}

validateDateOfBirth(String dob) {
  if (dob.isNotEmpty) {
    final RegExp regex =
        RegExp(r'^\d{2}-\d{2}-\d{4}$'); // check the dob formate.

    if (regex.hasMatch(dob)) {
      // check if matched
      try {
        //re-formate the date of birth
        final month = int.parse(dob.trim().split("-")[0]);
        final date = int.parse(dob.trim().split("-")[1]);
        final year = int.parse(dob.trim().split("-")[2]);

        var birthDate = DateTime(year, month, date); // cast the date of birth.
        var today = DateTime.now();
        var age = today.year - birthDate.year;

        // Check if the birth date is in the future or more than 100 years ago
        if (birthDate.isAfter(today) || age > 100) {
          return "Invalid birth date";
        }

        // Check if the birth date is in February and the day is greater than 29 (leap year)
        if (birthDate.month == 2 && birthDate.day > 29) {
          return 'Invalid birth date';
        }

        // Check if the birth date is in April, June, September, or November and the day is greater than 30
        if ([4, 6, 9, 11].contains(birthDate.month) && birthDate.day > 30) {
          return 'Invalid birth date';
        }

        return null;
      } catch (e) {
        throw Exception(e);
      }
    } else {
      return "Please enter your birth date in MM-DD-YYYY format.";
    }
  } else {
    // if empty.
    return null; // "Invalid birth date";
  }
}
