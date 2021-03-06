import 'package:flutter/material.dart';

import 'bloc_state.dart';

@immutable
abstract class RequestState<T> extends BlocState<T>{
  RequestState();
}

@immutable
class InitialState<T> extends RequestState<T>{
}

@immutable
class LoadingState<T> extends RequestState<T>{
  LoadingState({this.content});

  /// Used for e.g. pull-to-refresh, when you have content but still loading
  final T content;
}

@immutable
class ErrorState<T> extends RequestState<T>{
  ErrorState(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}

@immutable
class ContentState<T> extends RequestState<T>{
  ContentState(this.content);

  final T content;
}