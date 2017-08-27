library redux_thunk;

import 'package:redux/redux.dart';

/// The thunkMiddleware intercepts and calls [ThunkAction]s, which is simply a
/// fancy name for any function that takes 1 argument: a Redux Store. This
/// allows you to dispatch functions (aka [ThunkAction]s) to your Store that can
/// perform asynchronous work, then dispatch actions using the Store after the
/// work is complete.
///
/// The dispatched [ThunkAction]s will be swallowed, meaning they will not go
/// through the rest of your middleware to the [Store]'s [Reducer].
///
/// ### Example
///
///    // First, create a quick reducer
///    final reducer = (String state, action) =>
///    action is String ? action : state;
///
///    // Next, apply the `thunkMiddleware` to the Store
///    final store = new Store<String>(
///      reducer,
///      middleware: [thunkMiddleware],
///    );
///
///    // Create a `ThunkAction`, which is any function that accepts the
///    // Store as it's only argument. Our function (aka ThunkAction) will
///    // simply send an action after 1 second.  This is just an example,
///    // but  in real life, you could make a call to an HTTP service or
///    // database instead!
///    final action = (Store<String> store) async {
///      final searchResults = await new Future.delayed(
///        new Duration(seconds: 1),
///            () => "Search Results",
///      );
///
///      store.dispatch(searchResults);
///    };
void thunkMiddleware<State>(Store<State> store, action, NextDispatcher next) {
  if (action is ThunkAction) {
    action(store);
  } else {
    next(action);
  }
}

/// A function that can be dispatched as an action to a Redux [Store] and
/// intercepted by the the [thunkMiddleware]. It can be used to delay the
/// dispatch of an action, or to dispatch only if a certain condition is met.
///
/// The ThunkFunction receives a [Store], which it can use to get the latest
/// state if need be, or dispatch actions at the appropriate time.
typedef void ThunkAction<State>(Store<State> store);
