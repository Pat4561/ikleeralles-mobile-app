import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:ikleeralles/logic/managers/operation.dart';
import 'package:ikleeralles/logic/operations/abstract.dart';

abstract class OperationBasedTableState<T extends StatefulWidget> extends State<T> {

  OperationManager operationManager;

  Color backgroundColor = Colors.white;

  Future _onRefresh() {
    operationManager.reset();
    return operationManager.execute();
  }

  bool get resultNotNullOrArrayEmpty {
    bool resultNotEmpty = operationManager.currentState.result != null;
    if (resultNotEmpty) {
      List data = operationManager.currentState.result;
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
    } else if (operationManager.loadingDelegate.isLoading) {
      return loadingBackgroundBuilder(context);
    } else if (operationManager.currentState.error != null) {
      return errorBackgroundBuilder(context, operationManager.currentState.error);
    } else if (operationManager.currentState.result != null && operationManager.currentState.result.length == 0) {
      return noResultsBackgroundBuilder(context);
    }
    return Container();
  }

  Widget list(BuildContext context) {
    if (resultNotNullOrArrayEmpty) {
      return listBuilder(context, operationManager.currentState.result);
    }
    return ListView();
  }

  Operation newOperation();

  @override
  void initState() {
    super.initState();
    operationManager = OperationManager(
        operationBuilder: newOperation
    );
    operationManager.execute();

  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<OperationManager>(
      model: operationManager,
      child: ScopedModelDescendant<OperationManager>(
        builder: (BuildContext context, Widget widget, OperationManager _operationManager) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: Stack(
              children: <Widget>[
                background(context),
                Container(
                  color: backgroundColor,
                  child: list(context),
                )
              ],
            ),
          );
        },
      ),
    );
  }

}
