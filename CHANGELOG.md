### 0.0.1-dev11

* Fix grpc call timeout issue

### 0.0.1-dev10

* Updated grpc call cancellation function to use `Completer` rather than `Future`
* Added timeout argument to grpc call function

### 0.0.1-dev09

* Updated packages to latest versions

### 0.0.1-dev08

* Updated `ObservableUseCase` to use **streams** rather than **futures**

### 0.0.1-dev07

* Added grpc call cancellation function (used to cancel grpc calls before completion)

### 0.0.1-dev06

* fixed positioning of use case result

### 0.0.1-dev05

* Added `typedef` for API calls

## 0.0.1-dev04

* Replaced `execute` with `call` in `UseCase` class

## 0.0.1-dev03

* Added `fold` method to `UseCaseResult` class

## 0.0.1-dev02

* Added use case results & background

## 0.0.1-dev01

* Added log interceptor

## 0.0.1

* Added grpc call wrappers
* Added rest call wrappers
