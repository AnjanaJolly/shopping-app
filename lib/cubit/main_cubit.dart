import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_state.dart';

class MainCubit<S extends MainCubitState> extends Cubit<S> {
  MainCubit(S initialState) : super(initialState) {
    @override
    Future close() {
      return super.close();
    }
  }
}
