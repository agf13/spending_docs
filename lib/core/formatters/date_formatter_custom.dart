class DateFormatterCustom {
  static String dayMonthYearHourMinuteSecond(DateTime date) {
    const padSymbol = '0';

    String output = '';
    output += date.day.toString().padLeft(2, padSymbol);
    output += '-${date.month.toString().padLeft(2, padSymbol)}';
    output += '-${date.year}';
    output += ' ${date.hour.toString().padLeft(2, padSymbol)}';
    output += ':${date.minute.toString().padLeft(2, padSymbol)}';
    output += ':${date.second.toString().padLeft(2, padSymbol)}';

    return output;
  }

  static String yearMonthDayHourMinuteSecond(DateTime date) {
    const padSymbol = '0';

    String output = '';
    output += '${date.year}';
    output += '-${date.month.toString().padLeft(2, padSymbol)}';
    output += '-${date.day.toString().padLeft(2, padSymbol)}';
    output += ' ${date.hour.toString().padLeft(2, padSymbol)}';
    output += ':${date.minute.toString().padLeft(2, padSymbol)}';
    output += ':${date.second.toString().padLeft(2, padSymbol)}';

    return output;
  }

  /*
    Assumed the date format as: yyyy-mm-dd hh:mm:ss or dd-mm-yyyy hh:mm:ss
    Removes the second half keeping just yyyy-mm-dd or dd-mm-yyyy
  */
  static String removeHourMinuteSecond(String dateTimeString) {
    return dateTimeString.split(' ').first;
  }

  /*
    Swtiches between: yyyy-mm-dd hh:mm:ss and dd-mm-yyyy hh:mm:ss
  */
  static String switchDayAndYearWithTime(String dateTimeString) {
    final List<String> splitDate = dateTimeString.split(' ');
    final List<String> firstHalf = splitDate.first.split('-');
    final String secondHalf = splitDate.last;

    String year = firstHalf[0];
    String month = firstHalf[1];
    String day = firstHalf[2];

    String output = '$day-$month-$year $secondHalf';
    return output;
  }

  /*
    Swtiches between: yyyy-mm-dd and dd-mm-yyyy
  */
  static String switchDayAndYearNoTime(String dateString) {
    print('received: $dateString');
    final List<String> terms = dateString.split('-');

    String first = terms.first;
    terms.first = terms.last;
    terms.last = first;

    return terms.join('-');
  }
}
