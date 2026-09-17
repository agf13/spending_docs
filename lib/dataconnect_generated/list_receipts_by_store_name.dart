part of 'generated.dart';

class ListReceiptsByStoreNameVariablesBuilder {
  String storeName;

  final FirebaseDataConnect _dataConnect;
  ListReceiptsByStoreNameVariablesBuilder(this._dataConnect, {required  this.storeName,});
  Deserializer<ListReceiptsByStoreNameData> dataDeserializer = (dynamic json)  => ListReceiptsByStoreNameData.fromJson(jsonDecode(json));
  Serializer<ListReceiptsByStoreNameVariables> varsSerializer = (ListReceiptsByStoreNameVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListReceiptsByStoreNameData, ListReceiptsByStoreNameVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListReceiptsByStoreNameData, ListReceiptsByStoreNameVariables> ref() {
    ListReceiptsByStoreNameVariables vars= ListReceiptsByStoreNameVariables(storeName: storeName,);
    return _dataConnect.query("ListReceiptsByStoreName", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListReceiptsByStoreNameReceipts {
  final String id;
  final String storeName;
  final Timestamp date;
  final double amount;
  final String? card;
  ListReceiptsByStoreNameReceipts.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  storeName = nativeFromJson<String>(json['storeName']),
  date = Timestamp.fromJson(json['date']),
  amount = nativeFromJson<double>(json['amount']),
  card = json['card'] == null ? null : nativeFromJson<String>(json['card']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListReceiptsByStoreNameReceipts otherTyped = other as ListReceiptsByStoreNameReceipts;
    return id == otherTyped.id && 
    storeName == otherTyped.storeName && 
    date == otherTyped.date && 
    amount == otherTyped.amount && 
    card == otherTyped.card;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, storeName.hashCode, date.hashCode, amount.hashCode, card.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['storeName'] = nativeToJson<String>(storeName);
    json['date'] = date.toJson();
    json['amount'] = nativeToJson<double>(amount);
    if (card != null) {
      json['card'] = nativeToJson<String?>(card);
    }
    return json;
  }

  ListReceiptsByStoreNameReceipts({
    required this.id,
    required this.storeName,
    required this.date,
    required this.amount,
    this.card,
  });
}

@immutable
class ListReceiptsByStoreNameData {
  final List<ListReceiptsByStoreNameReceipts> receipts;
  ListReceiptsByStoreNameData.fromJson(dynamic json):
  
  receipts = (json['receipts'] as List<dynamic>)
        .map((e) => ListReceiptsByStoreNameReceipts.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListReceiptsByStoreNameData otherTyped = other as ListReceiptsByStoreNameData;
    return receipts == otherTyped.receipts;
    
  }
  @override
  int get hashCode => receipts.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['receipts'] = receipts.map((e) => e.toJson()).toList();
    return json;
  }

  ListReceiptsByStoreNameData({
    required this.receipts,
  });
}

@immutable
class ListReceiptsByStoreNameVariables {
  final String storeName;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListReceiptsByStoreNameVariables.fromJson(Map<String, dynamic> json):
  
  storeName = nativeFromJson<String>(json['storeName']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListReceiptsByStoreNameVariables otherTyped = other as ListReceiptsByStoreNameVariables;
    return storeName == otherTyped.storeName;
    
  }
  @override
  int get hashCode => storeName.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['storeName'] = nativeToJson<String>(storeName);
    return json;
  }

  ListReceiptsByStoreNameVariables({
    required this.storeName,
  });
}

