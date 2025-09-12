import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'example_event.dart';
part 'example_state.dart';

@injectable
class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  ExampleBloc() : super(ExampleInitial()) {
    on<LoadExample>(_onLoadExample);
    on<ResetExample>(_onResetExample);
  }

  void _onLoadExample(LoadExample event, Emitter<ExampleState> emit) async {
    emit(ExampleLoading());
    
    try {
      await Future.delayed(const Duration(seconds: 5));
      emit(const ExampleLoaded(data: "Example data loaded"));
    } catch (e) {
      emit(ExampleError(message: e.toString()));
    }
  }

  void _onResetExample(ResetExample event, Emitter<ExampleState> emit) {
    emit(ExampleInitial());
  }
}