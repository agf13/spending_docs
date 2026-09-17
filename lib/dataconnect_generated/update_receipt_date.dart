part of 'generated.dart';

class UpdateReceiptDateVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  UpdateReceiptDateVariablesBuilder(this._dataConnect, );
  Deserializer<UpdateReceiptDateData> dataDeserializer = (dynamic json)  => UpdateReceiptDateData.fromJson(jsonDecode(json));
  
  Future<OperationResult<UpdateReceiptDateData, void>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateReceiptDateData, void> ref() {
    
    return _dataConnect.mutation("UpdateReceiptDate", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class UpdateReceiptDateData {
  final int? execute_;
  UpdateReceiptDateData.fromJson(dynamic json):
  
  execute_ = json['_execute'] == null ? null : nativeFromJson<int>(json['_execute']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateReceiptDateData otherTyped = other as UpdateReceiptDateData;
    return execute_ == otherTyped.execute_;
    
  }
  @override
  int get hashCode => execute_.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (execute_ != null) {
      json['_execute'] = nativeToJson<int?>(execute_);
    }
    return json;
  }

  UpdateReceiptDateData({
    this.execute_,
  });
}

