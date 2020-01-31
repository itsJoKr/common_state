import 'package:flutter/material.dart';

import 'bloc_event.dart';

@immutable
abstract class RequestEvent<T> extends BlocEvent<T>{
  const RequestEvent([this._props]);

  final List<T> _props;

  @override
  List<T> get props => _props ?? <T>[];
}

@immutable
class MakeRequest<T> extends RequestEvent<T>{
  const MakeRequest(this.request);

  final Future<T> request;
}