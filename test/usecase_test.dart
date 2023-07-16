import 'package:api_utils/src/common/usecase.dart';
import 'package:api_utils/src/common/usecase.result.dart';
import 'package:flutter_test/flutter_test.dart';

class BigNumberComputationUseCase extends BackgroundUseCase<int, int> {
  @override
  void execute(BackgroundUseCaseParams<int> params) async {
    int sum = 0;
    for (int i = 0; i < params.params; i++) {
      sum += i;
    }
    params.sendPort.send(UseCaseResult<int>.success(sum));
  }
}

void main() async {
  group('testing use cases', () {
    test('background use case test', () async {
      final useCase = BigNumberComputationUseCase();
      final result = await useCase(1000000000);
      expect(result, isA<UseCaseResultSuccess<int>>());
    });
  });
}
