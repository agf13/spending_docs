part of 'generated.dart';

class ListReceiptsWithoutItemsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListReceiptsWithoutItemsVariablesBuilder(this._dataConnect, );
  Deserializer<ListReceiptsWithoutItemsData> dataDeserializer = (dynamic json)  => ListReceiptsWithoutItemsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListReceiptsWithoutItemsData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListReceiptsWithoutItemsData, void> ref() {
    
    return _dataConnect.query("ListReceiptsWithoutItems", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListReceiptsWithoutItemsReceipts {
  final String id;
  final String storeName;
  final Timestamp date;
  final double amount;
  final String? card;
  ListReceiptsWithoutItemsReceipts.fromJson(dynamic json):
  
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

    final ListReceiptsWithoutItemsReceipts otherTyped = other as ListReceiptsWithoutItemsReceipts;
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

  ListReceiptsWithoutItemsReceipts({
    required this.id,
    required this.storeName,
    required this.date,
    required this.amount,
    this.card,
  });
}

@immutable
class ListReceiptsWithoutItemsData {
  final List<ListReceiptsWithoutItemsReceipts> receipts;
  ListReceiptsWithoutItemsData.fromJson(dynamic json):
  
  receipts = (json['receipts'] as List<dynamic>)
        .map((e) => ListReceiptsWithoutItemsReceipts.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListReceiptsWithoutItemsData otherTyped = other as ListReceiptsWithoutItemsData;
    return receipts == otherTyped.receipts;
    
  }
  @override
  int get hashCode => receipts.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['receipts'] = receipts.map((e) => e.toJson()).toList();
    return json;
  }

  ListReceiptsWithoutItemsData({
    required this.receipts,
  });
}

