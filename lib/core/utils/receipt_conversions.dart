class ReceiptConversions {
  /*
    def: Convert a text to a double. Return null if the text is not a number
    input: String - the number in the string form
    output: double? - the value if is a number or null
  */
  static double? textToDouble(String valueText) {
    try {
      return double.parse(valueText);
    } catch (e) {
      return null;
    }
  }

  /*
    def: Convert a text to a DateTime value. Return null if the text is not a correct DateTime value.
    input: String - the date in the string form
    output: DateTime? - the value as DateTime if is correct or null
  */
  static DateTime? textToDateTime(String dateText) {
    try {
      return DateTime.parse(dateText);
    } catch (e) {
      return null;
    }
  }
}
