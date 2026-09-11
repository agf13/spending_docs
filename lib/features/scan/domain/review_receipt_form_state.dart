class ReviewReceiptItemState {
  String price;
  String itemName;

  ReviewReceiptItemState({this.price = '', this.itemName = ''});
}

class ReviewReceiptFormState {
  String amount;
  String date;
  String storeName;
  String card;

  List<ReviewReceiptItemState> items = [];

  ReviewReceiptFormState({
    this.amount = '',
    this.date = '',
    this.storeName = '',
    this.card = '',
  });
}
