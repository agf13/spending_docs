part of 'generated.dart';

class ListReceiptsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListReceiptsVariablesBuilder(this._dataConnect, );
  Deserializer<ListReceiptsData> dataDeserializer = (dynamic json)  => ListReceiptsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListReceiptsData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListReceiptsData, void> ref() {
    
    return _dataConnect.query("ListReceipts", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListReceiptsReceipts {
  final String id;
  final String storeName;
  final Timestamp date;
  final double amount;
  final String? card;
  final List<ListReceiptsReceiptsReceiptItemsOnReceipt> receiptItems_on_receipt;
  ListReceiptsReceipts.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  storeName = nativeFromJson<String>(json['storeName']),
  date = Timestamp.fromJson(json['date']),
  amount = nativeFromJson<double>(json['amount']),
  card = json['card'] == null ? null : nativeFromJson<String>(json['card']),
  receiptItems_on_receipt = (json['receiptItems_on_receipt'] as List<dynamic>)
        .map((e) => ListReceiptsReceiptsReceiptItemsOnReceipt.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListReceiptsReceipts otherTyped = other as ListReceiptsReceipts;
    return id == otherTyped.id && 
    storeName == otherTyped.storeName && 
    date == otherTyped.date && 
    amount == otherTyped.amount && 
    card == otherTyped.card && 
    receiptItems_on_receipt == otherTyped.receiptItems_on_receipt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, storeName.hashCode, date.hashCode, amount.hashCode, card.hashCode, receiptItems_on_receipt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['storeName'] = nativeToJson<String>(storeName);
    json['date'] = date.toJson();
    json['amount'] = nativeToJson<double>(amount);
    if (card != null) {
      json['card'] = nativeToJson<String?>(card);
    }
    json['receiptItems_on_receipt'] = receiptItems_on_receipt.map((e) => e.toJson()).toList();
    return json;
  }

  ListReceiptsReceipts({
    required this.id,
    required this.storeName,
    required this.date,
    required this.amount,
    this.card,
    required this.receiptItems_on_receipt,
  });
}

@immutable
class ListReceiptsReceiptsReceiptItemsOnReceipt {
  final String itemName;
  final double price;
  ListReceiptsReceiptsReceiptItemsOnReceipt.fromJson(dynamic json):
  
  itemName = nativeFromJson<String>(json['itemName']),
  price = nativeFromJson<double>(json['price']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListReceiptsReceiptsReceiptItemsOnReceipt otherTyped = other as ListReceiptsReceiptsReceiptItemsOnReceipt;
    return itemName == otherTyped.itemName && 
    price == otherTyped.price;
    
  }
  @override
  int get hashCode => Object.hashAll([itemName.hashCode, price.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['itemName'] = nativeToJson<String>(itemName);
    json['price'] = nativeToJson<double>(price);
    return json;
  }

  ListReceiptsReceiptsReceiptItemsOnReceipt({
    required this.itemName,
    required this.price,
  });
}

@immutable
class ListReceiptsData {
  final List<ListReceiptsReceipts> receipts;
  ListReceiptsData.fromJson(dynamic json):
  
  receipts = (json['receipts'] as List<dynamic>)
        .map((e) => ListReceiptsReceipts.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListReceiptsData otherTyped = other as ListReceiptsData;
    return receipts == otherTyped.receipts;
    
  }
  @override
  int get hashCode => receipts.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['receipts'] = receipts.map((e) => e.toJson()).toList();
    return json;
  }

  ListReceiptsData({
    required this.receipts,
  });
}

