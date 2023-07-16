# Flutter Clean Architecture Usecase Templates and API Helpers

This Flutter package provides a set of functionalities for implementing Clean Architecture in Flutter projects, along
with helper functions for making unary and streaming gRPC calls and HTTP 1.1 requests using Retrofit (+ Dio).

## Usecase Templates for Flutter Clean Architecture

This package includes predefined templates for implementing use cases in Flutter Clean Architecture. These templates
follow the principles of Clean Architecture, separating concerns into distinct layers and promoting code modularity and
testability. The use case templates provided include:

### 1. Domain Layer

The domain layer contains the core business logic and rules of the application. It should be independent of any external
frameworks or libraries.

#### UseCase Template

```dart
class UseCaseName {
  final SomeRepository _repository;

  UseCaseName(this._repository);

  FutureOr<Result> call(Params input) async {
    // Perform business logic operations using the repository
    // Return a Result object indicating the outcome
  }
}
```

### 2. Data Layer

The data layer handles data retrieval and storage. It communicates with external sources such as APIs or databases.

#### Repository Template

```dart
abstract class SomeRepository {
  Future<Result> fetchData();
}
```

### 3. Presentation Layer

The presentation layer handles the UI and user interactions. It communicates with the domain layer to retrieve and
display data.

#### Presenter Template

```dart
class SomePresenter {
  final UseCaseName _useCase;

  SomePresenter(this._useCase);

  Future<void> fetchData() async {
    // Call the use case to retrieve data
    // Update the UI based on the result
  }
}
```

## gRPC Helper Functions

This package also includes helper functions for making unary and streaming gRPC calls.

### 1. Unary gRPC Call Helper

```dart
Future<Result> makeUnaryGrpcCall(RequestPayload payload) async {
  return runWithGrpcUnaryZonedGuarded(() async {
    // Construct the gRPC request with the payload
    // Send the request to the specified host and port
    // The response is transformed into a Union (Either) object and returned
  }, onError: (err) {
    // Handle any errors that occur during the gRPC call
    // Return a Result object indicating the outcome
  }, errMessage: 'Error Message');
}
```

### 2. Streaming gRPC Call Helper

```dart
Future<Stream<Result>> makeStreamingGrpcCall(RequestPayload payload) async {
  return runWithGrpcStreamZonedGuarded(() async {
    // Construct the gRPC request with the payload
    // Send the request to the specified host and port
    // The response is transformed into a Union (Either) object and returned
  }, onError: (err) {
    // Handle any errors that occur during the gRPC call
    // Return a Result object indicating the outcome
  }, errMessage: 'Error Message');
}
```

## Retrofit HTTP 1.1 Helper Functions

This package also provides helper functions for making HTTP 1.1 requests using Retrofit.

### 1. HTTP GET Request Helper

```dart
Future<Result> getHttp(String url, Map<String, dynamic> headers) async {
  return runApiCall(() async {
    // Construct the HTTP GET request with the specified URL and headers
    // Send the request (which returns a HttpResponse object)
    // The response is transformed into a Union (Either) object and returned
  }, onError: (err) {
    // Handle any errors that occur during the gRPC call
    // Return a Result object indicating the outcome
  }, errMessage: 'Error Message');
}
```

### 2. HTTP POST Request Helper

```dart
Future<Result> postHttp(String url, Map<String, dynamic> headers, RequestPayload payload) async {
  // Construct the HTTP POST request with the specified URL, headers, and payload
  // Send the request
  // Handle the response and return a Result object
}
```

These helper functions simplify the process of making gRPC and HTTP requests in your Flutter applications, allowing you
to focus on implementing the desired functionality with ease.

## Example

For a complete example of how to use this package, please refer to the [test](test) directory.

