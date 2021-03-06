import 'package:axolotl/adventure/states.dart';
import 'package:axolotl/common/app_state.dart';
import 'package:flutter/material.dart';

@immutable
class AdventureListState {
  final List<Adventure> adventures;
  final LoadingState loadingState;

  const AdventureListState({this.adventures = const [], this.loadingState = LoadingState.NONE});

  AdventureListState copyWith({List<Adventure> adventures, LoadingState loadingState}){
    return AdventureListState(
      adventures: adventures??this.adventures,
      loadingState: loadingState??this.loadingState
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdventureListState &&
          runtimeType == other.runtimeType &&
          adventures == other.adventures &&
          loadingState == other.loadingState;

  @override
  int get hashCode => adventures.hashCode ^ loadingState.hashCode;
}