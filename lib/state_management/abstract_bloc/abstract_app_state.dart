import 'package:flutter/cupertino.dart';

@immutable
abstract class AbstractAppState {
  final bool isLoading;
  final bool? stateIsChanged;

  const AbstractAppState({
    required this.isLoading,
    this.stateIsChanged,
  });
}
