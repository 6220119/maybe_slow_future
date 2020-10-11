library maybe_slow_future;

import 'dart:async';

extension OnSlowFuture<T> on Future<T> {
  Future<T> onSlow(Duration threshold, void Function() onSlowCallback) {
    return maybeSlowFuture(
      actualFuture: this,
      threshold: threshold,
      onSlowCallback: onSlowCallback,
    );
  }
}

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
