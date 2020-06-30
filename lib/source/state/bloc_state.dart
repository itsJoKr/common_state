import 'package:common_state/common_state.dart';
import 'package:flutter/material.dart';

/// Default bloc state to pass.
///
/// Extend this for arbitrary states you might need that have nothing to do with [RequestState] loading/content/error.
@immutable
abstract class BlocState<T>{ }