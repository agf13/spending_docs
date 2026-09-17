import 'package:spending_docs/dataconnect_generated/generated.dart';

class ReceiptsFirebaseRepository {
  final MobileConnector _mobileConnector = MobileConnector.instance;

  ReceiptsFirebaseRepository();

  Future<List<ListReceiptsWithoutItemsReceipts>> fetchReceipts() async {
    final response = await _mobileConnector
        .listReceiptsWithoutItems()
        .execute();
    return response.data.receipts;
  }

  Future<List<ListReceiptsByStoreNameReceipts>> fetchReceiptsByStoreName(
    String storeName,
  ) async {
    final response = await _mobileConnector
        .listReceiptsByStoreName(storeName: storeName)
        .execute();
    return response.data.receipts;
  }
}
