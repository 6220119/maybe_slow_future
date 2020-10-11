library maybe_slow_future;

import 'dart:async';

/// Provide the extension method [onSlow] for a [Future]
extension OnSlowFuture<T> on Future<T> {
  /// Passing [threshold] and [onSlowCallback] to [maybeSlowFuture]
  Future<T> onSlow(Duration threshold, void Function() onSlowCallback) {
    return maybeSlowFuture(
      actualFuture: this,
      threshold: threshold,
      onSlowCallback: onSlowCallback,
    );
  }
}

/// Wrap a [Future] and return another [Future] that performs the [onSlowCallback]
/// when a certain time (specified by the [threshold] parameter) has passed.
///
/// It can be useful in certain scenario,
/// i.e. when we want to communicate to the user that an on-going operation is taking longer than it should be
Future<T> maybeSlowFuture<T>({
  Future<T> actualFuture,
  Duration threshold,
  void Function() onSlowCallback,
}) {
  assert(actualFuture != null);
  assert(threshold != null);
  assert(onSlowCallback != null);

  return actualFuture.timeout(threshold, onTimeout: () {
    onSlowCallback();
    return actualFuture;
  });
}
