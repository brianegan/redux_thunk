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
dynamic thunkMiddleware<State>(
  Store<State> store,
  dynamic action,
  NextDispatcher next,
) {
  if (action is ThunkAction<State>) {
    return action(store);
  } else if (action is CallableThunkAction<State>) {
    return action.call(store);
  } else {
    return next(action);
  }
}

/// The [ExtraArgumentThunkMiddleware] works exactly like the normal
/// [thunkMiddleware] with one difference: It injects the provided "extra
/// argument" into all Thunk functions.
///
/// ### Example
///
/// ```dart
/// // First, create a quick reducer
/// final reducer = (String state, action) => action is String ? action : state;
///
/// // Next, apply the `ExtraArgumentThunkMiddleware` to the Store. In this
/// // case, we want to provide an http client to each thunk function.
/// final store = new Store<String>(
///   reducer,
///   middleware: [ExtraArgumentThunkMiddleware(http.Client())],
///  );
///
/// // Create a `ThunkActionWithExtraArgument`, which is a fancy name for a
/// // function that takes in a Store and the extra argument provided above
/// // (the http.Client).
/// Future<void> fetchBlogAction(Store<String> store, http.Client client) async {
///   final response = await client.get('https://jsonplaceholder.typicode.com/posts');
///
///   store.dispatch(response.body);
/// }
/// ```
class ExtraArgumentThunkMiddleware<S, A> extends MiddlewareClass<S> {
  /// An Extra argument that will be injected into every thunk function.
  final A extraArgument;

  /// Create a ThunkMiddleware that will inject an extra argument into every
  /// thunk function
  ExtraArgumentThunkMiddleware(this.extraArgument);

  @override
  dynamic call(Store<S> store, dynamic action, NextDispatcher next) {
    if (action is ThunkActionWithExtraArgument<S, A>) {
      return action(store, extraArgument);
    } else if (action is CallableThunkActionWithExtraArgument<S, A>) {
      return action.call(store, extraArgument);
    } else {
      return next(action);
    }
  }
}

/// A function that can be dispatched as an action to a Redux [Store] and
/// intercepted by the the [thunkMiddleware]. It can be used to delay the
/// dispatch of an action, or to dispatch only if a certain condition is met.
///
/// The ThunkFunction receives a [Store], which it can use to get the latest
/// state if need be, or dispatch actions at the appropriate time.
typedef ThunkAction<State> = dynamic Function(Store<State> store);

/// An interface that can be implemented by end-users to create a class-based
/// [ThunkAction].
abstract class CallableThunkAction<State> {
  /// The method that acts as the [ThunkAction]
  dynamic call(Store<State> store);
}

/// A function that can be dispatched as an action to a Redux [Store] and
/// intercepted by the the [ExtraArgumentThunkMiddleware]. It can be used to
/// delay the dispatch of an action, or to dispatch only if a certain condition
/// is met.
///
/// The [Store] argument is used to get the latest state if need be, or dispatch
/// actions at the appropriate time.
///
/// The [extraArgument] argument is injected via [ExtraArgumentThunkMiddleware].
typedef ThunkActionWithExtraArgument<S, A> = dynamic Function(
  Store<S> store,
  A extraArgument,
);

/// An interface that can be implemented by end-users to create a class-based
/// [ThunkActionWithExtraArgument].
abstract class CallableThunkActionWithExtraArgument<S, A> {
  /// The method that acts as the [ThunkActionWithExtraArgument]
  dynamic call(Store<S> store, A extraArgument);
}
