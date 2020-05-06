import 'package:flutter/material.dart';

import 'bloc_event.dart';

@immutable
class MakeRequest<T> extends BlocEvent<T> {
  MakeRequest(this.request);

  final Future<T> request;
}