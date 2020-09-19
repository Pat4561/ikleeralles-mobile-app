import 'package:flutter/material.dart';
import 'package:ikleeralles/constants.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:ikleeralles/logic/managers/operation.dart';

abstract class OperationBasedTable extends StatefulWidget {

  final OperationManager operationManager;

  OperationBasedTable (this.operationManager, { Key key }) : super(key: key);

}

abstract class OperationBasedTableState<T extends OperationBasedTable> extends State<T> {


  Color backgroundColor = Colors.white;

  Future _onRefresh() {
    widget.operationManager.reset();
    return widget.operationManager.execute();
  }

  bool get resultNotNullOrArrayEmpty {
    bool resultNotEmpty = widget.operationManager.currentState.result != null;
    if (resultNotEmpty) {
      List data = widget.operationManager.currentState.result;
      return data.length > 0;
    }
    return false;
  }

  Widget loadingBackgroundBuilder(BuildContext context);

  Widget errorBackgroundBuilder(BuildContext context, dynamic error);

  Widget noResultsBackgroundBuilder(BuildContext context);

  Widget listBuilder(BuildContext context, dynamic result);

  Widget background(BuildContext context) {
    if (resultNotNullOrArrayEmpty) {
      return Container();
    } else if (widget.operationManager.loadingDelegate.isLoading) {
      return loadingBackgroundBuilder(context);
    } else if (widget.operationManager.currentState.error != null) {
      return errorBackgroundBuilder(context, widget.operationManager.currentState.error);
    } else if (widget.operationManager.currentState.result != null && widget.operationManager.currentState.result.length == 0) {
      return noResultsBackgroundBuilder(context);
    }
    return Container();
  }

  Widget list(BuildContext context) {
    if (resultNotNullOrArrayEmpty) {
      return listBuilder(context, widget.operationManager.currentState.result);
    }
    return ListView();
  }

  @override
  void initState() {
    super.initState();
    widget.operationManager.execute();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<OperationManager>(
      model: widget.operationManager,
      child: ScopedModelDescendant<OperationManager>(
        builder: (BuildContext context, Widget widget, OperationManager _operationManager) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: BrandColors.secondaryButtonColor,
            child: Container(
              color: backgroundColor,
              child: Stack(
                children: <Widget>[
                  background(context),
                  list(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
