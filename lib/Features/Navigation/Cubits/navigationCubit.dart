import 'package:flutter_bloc/flutter_bloc.dart';

class navigationSate{
  final int currentIndex;

  navigationSate(this.currentIndex);
}

class Navigationcubit extends Cubit<navigationSate>{
  Navigationcubit() : super(navigationSate(0));

  void updateIndex(int index){  
    emit(navigationSate(index));
  }
}