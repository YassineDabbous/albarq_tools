import 'package:albarq_tools/data/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CountingState {}

class CountingInitial extends CountingState {}

class CountingLoading extends CountingState {}

class CountingPageLoaded extends CountingState {
  List<OrderCountingLog> data;
  CountingPageLoaded({required this.data});
}

class CountingSaving extends CountingState {}

class CountingSaved extends CountingState {
  int data;
  CountingSaved({required this.data});
}

class CountingError extends CountingState {
  String message;
  CountingError({required this.message});
}

class CountingBloc extends Cubit<CountingState> {
  CountingBloc() : super(CountingInitial());
  List<OrderCountingLog> lista = [];

  list() async {
    emit(CountingLoading());
    try {
      final data = await Repository.http().counting(page: 1);
      lista.addAll(data.data!.data!);
      emit(CountingPageLoaded(data: data.data!.data!));
    } catch (e) {
      emit(CountingError(message: e.toString()));
    }
  }

  save({required int count, String? note, required Map<String, int> items}) async {
    emit(CountingSaving());
    Repository.http().countingCreate(OrderCountingRequest(count: count, note: note, vouchers: items)).then((value) {
      if (value.data != null) {
        emit(CountingSaved(data: value.data!));
      }
    }).catchError((e) {
      emit(CountingError(message: e.toString()));
    });
  }
}
