# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
MobileConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### ListReceipts
#### Required Arguments
```dart
// No required arguments
MobileConnector.instance.listReceipts().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListReceiptsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await MobileConnector.instance.listReceipts();
ListReceiptsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = MobileConnector.instance.listReceipts().ref();
ref.execute();

ref.subscribe(...);
```


### ListReceiptsWithoutItems
#### Required Arguments
```dart
// No required arguments
MobileConnector.instance.listReceiptsWithoutItems().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListReceiptsWithoutItemsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await MobileConnector.instance.listReceiptsWithoutItems();
ListReceiptsWithoutItemsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = MobileConnector.instance.listReceiptsWithoutItems().ref();
ref.execute();

ref.subscribe(...);
```


### ListReceiptsByStoreName
#### Required Arguments
```dart
String storeName = ...;
MobileConnector.instance.listReceiptsByStoreName(
  storeName: storeName,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListReceiptsByStoreNameData, ListReceiptsByStoreNameVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await MobileConnector.instance.listReceiptsByStoreName(
  storeName: storeName,
);
ListReceiptsByStoreNameData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String storeName = ...;

final ref = MobileConnector.instance.listReceiptsByStoreName(
  storeName: storeName,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### UpdateReceiptDate
#### Required Arguments
```dart
// No required arguments
MobileConnector.instance.updateReceiptDate().execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpdateReceiptDateData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await MobileConnector.instance.updateReceiptDate();
UpdateReceiptDateData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = MobileConnector.instance.updateReceiptDate().ref();
ref.execute();
```

