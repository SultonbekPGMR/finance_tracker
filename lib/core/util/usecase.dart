// Created by Sultonbek Tulanov on 30-August 2025
abstract class UseCase<Out, In> {
  Out call(In params);
}

abstract class StreamUseCase<Type, Params> {
  Stream<Type> call(Params params);
}

abstract class FutureUseCase<Type, Params> {
  Future<Type> call(Params params);
}
