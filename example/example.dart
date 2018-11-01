import 'dart:async';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() {
  // First, create a quick reducer
  String reducer(String state, dynamic action) =>
      action is String ? action : state;

  // Next, apply the `thunkMiddleware` to the Store
  final store = new Store<String>(
    reducer,
    middleware: [thunkMiddleware],
  );

  // Create a `ThunkAction`, which is any function that accepts the
  // Store as it's only argument. Our function (aka ThunkAction) will
  // simply send an action after 1 second.  This is just an example,
  // but  in real life, you could make a call to an HTTP service or
  // database instead!
  void action(Store<String> store) async {
    final String searchResults = await new Future.delayed(
      new Duration(seconds: 1),
      () => "Search Results",
    );

    store.dispatch(searchResults);
  }

  // Dispatch the action! The `thunkMiddleware` will intercept and invoke
  // the action function.
  store.dispatch(action);
}
