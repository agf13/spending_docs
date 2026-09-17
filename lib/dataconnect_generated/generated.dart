library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'list_receipts.dart';

part 'list_receipts_without_items.dart';

part 'list_receipts_by_store_name.dart';

part 'update_receipt_date.dart';







class MobileConnector {
  
  
  ListReceiptsVariablesBuilder listReceipts () {
    return ListReceiptsVariablesBuilder(dataConnect, );
  }
  
  
  ListReceiptsWithoutItemsVariablesBuilder listReceiptsWithoutItems () {
    return ListReceiptsWithoutItemsVariablesBuilder(dataConnect, );
  }
  
  
  ListReceiptsByStoreNameVariablesBuilder listReceiptsByStoreName ({required String storeName, }) {
    return ListReceiptsByStoreNameVariablesBuilder(dataConnect, storeName: storeName,);
  }
  
  
  UpdateReceiptDateVariablesBuilder updateReceiptDate () {
    return UpdateReceiptDateVariablesBuilder(dataConnect, );
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'europe-west2',
    'mobile',
    'spending-docs-service',
  );

  MobileConnector({required this.dataConnect});
  static MobileConnector get instance {
    
    CacheSettings cacheSettings = CacheSettings(
      maxAge: Duration(milliseconds:0),
      storage: CacheStorage.persistent,
    );
    
    return MobileConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            cacheSettings: cacheSettings,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
