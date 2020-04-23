
import 'package:common_state/common_state.dart';
import 'package:common_state/source/request/request_widget_mixin.dart';
import 'package:common_state/source/state/bloc_state.dart';
import 'package:common_state/source/state/request_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/request_bloc.dart';
import '../request_snapshot.dart';
import '../show_dialog.dart';


/// To use [BlockingRequest] bloc that we pass as [T] has to extend [RequestBloc]
/// because this layout will only listen for [LoadingState], [ErrorState] and [ContentState]
///
/// You can only provide layout to [builder] that will be called when [ContentState] is
/// received to bloc to show the layout.
///
/// Everything else is optional. This includes [buildError] and [buildLoading] which
/// are shown inside the dialog.
///
/// [E] is type you want returned.
/// [MakeRequest] will be called and it needs to parse data to [E], then [ContentState] is called
/// with [E] set as it's content. When this widget gets [ContentState] it will send it to
/// builder with [RequestSnapshot.withData]
class BlockingRequestWidget<E, T extends RequestBloc<E>> extends StatefulWidget {

  const BlockingRequestWidget(this.bloc, {
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

  /// Called when user clicks onRetry.
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
  _BlockingRequestWidgetState<E, T> createState() =>
      _BlockingRequestWidgetState<E, T>();
}

class _BlockingRequestWidgetState<E, T extends RequestBloc<E>>
    extends State<BlockingRequestWidget<E, T>> with RequestWidgetMixin<E> {

  bool _dialogShown = false;

  Widget build(BuildContext context) {
    return BlocListener<T, BlocState<E>>(
      listener: (context, state) {
        if (_dialogShown) {
          Navigator.pop(context);
        }

        // Optional listener can be provided to this widget, so we call it here
        if (widget.listener != null) {
          widget.listener(context, state);
        }

        if (state is LoadingState<E>) {
          final loadingWidget = (widget.buildLoading != null) ? widget
              .buildLoading(context) : CommonStateHandling().loadingBuilder(context);
          _showDialog(state, loadingWidget);
        }

        if (state is ErrorState<E>) {
          final errorWidget = getErrorWidgetWithButton(
              context, widget.buildError, state,
              widget.onRetry, () {
            Navigator.pop(context);
          });
          _showDialog(state, errorWidget, dismissible: true);
        }
      },
      child: _buildWidget(context),
    );
  }

  Widget _buildWidget(BuildContext context) {
    return BlocBuilder<T, BlocState<E>>(
      bloc: widget.bloc,
      builder: (BuildContext context, BlocState<E> state) {
        if (state is ContentState<E>) {
          return widget.builder(context, state.content);
        }

        if (widget.buildInitial == null) {
          return SizedBox.shrink();
        } else {
          return widget.buildInitial(context);
        }
      },
    );
  }


  Future<T> _showDialog<T>(BlocState state, Widget child, { bool dismissible = false}) async {
    _dialogShown = true;
    final T content = await showInfoDialog<T>(context, state, child, dismissible: dismissible);
    _dialogShown = false;
    return content;
  }

}