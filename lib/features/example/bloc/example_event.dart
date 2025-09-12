part of 'example_bloc.dart';

abstract class ExampleEvent extends Equatable {
  const ExampleEvent();

  @override
  List<Object> get props => [];
}

class LoadExample extends ExampleEvent {
  const LoadExample();
}

class ResetExample extends ExampleEvent {
  const ResetExample();
}