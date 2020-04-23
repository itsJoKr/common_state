import 'package:common_state/common_state.dart';
import 'package:common_state/source/request/request_widget_mixin.dart';
import 'package:common_state/source/state/bloc_state.dart';
import 'package:common_state/source/state/request_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/request_bloc.dart';
import '../request_snapshot.dart';

/// To use [InLayoutRequestWidget] bloc that we pass [E] as data the bloc [T] returns.
/// [T] has to extend [RequestBloc] and this widget will only listen for
/// [LoadingState], [ErrorState] and [ContentState]
///
/// You can only provide layout to [builder] that will be called when [ContentState] is
/// received to bloc to show the layout.
///
/// Everything else is optional.
///
/// [E] is type you want returned.
/// [MakeRequest] will be called and it needs to parse data to [E], then [ContentState] is called
/// with [E] set as it's content. When this widget gets [ContentState] it will send it to
/// builder with [RequestSnapshot.withData]
class InLayoutRequestWidget<E, T extends RequestBloc<E>> extends StatelessWidget with RequestWidgetMixin<E> {
  const InLayoutRequestWidget(
    this.bloc, {
    Key key,
    @required this.builder,
    this.listener,
    this.buildLoading,
    this.buildInitial,
    this.buildError,
    this.onRetry,
  }) : super(key: key);

  /// Bloc that will be put in [BlocBuilder] and we will listen to it's state changes
  /// [T] has to extend [RequestBloc]
  final T bloc;

  /// Builder for successful request
  final SuccessRequestWidgetBuilder<E> builder;

  /// Called when user clicks onRetry
  final VoidCallback onRetry;

  /// Builder for loading state
  final RequestWidgetBuilder<E> buildLoading;

  /// Builder for initial state, before network request is started
  final RequestWidgetBuilder<E> buildInitial;

  /// Builder for unsuccessful request, all errors will propagate here
  /// or use common error handling
  final ErrorRequestWidgetBuilder<E> buildError;

  /// Just like [BlocConsumer] you can listen to events to do something other
  /// than building the widget, e.g. showing dialog.
  final BlocWidgetListener<BlocState<E>> listener;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<T, BlocState<E>>(
      bloc: bloc,
      listenWhen: (previous, current) => listener != null,
      listener: (context, state) => listener(context, state),
      builder: (BuildContext context, BlocState<E> state) {
        if (state is LoadingState<E>) {
          return (buildLoading != null) ? buildLoading(context) : CommonStateHandling().loadingBuilder(context);
        }

        if (state is ErrorState<E>) {
          return getErrorWidget(context, buildError, state, onRetry);
        }

        if (state is ContentState<E>) {
          return builder(context, state.content);
        }

        assert(state is InitialState<E>, "Received State that is not RequestState");
        return buildInitial(context);
      },
    );
  }
}
