import 'package:fake_async/fake_async.dart';
import 'package:maybe_slow_future/maybe_slow_future.dart';
import 'package:test/test.dart';

void main() {
  group('maybeSlowFuture', () {
    test(
      'call onSlowCallback when a future fails to complete in the given threshold',
      () {
        const expectedDurationToComplete = Duration(milliseconds: 250);
        const actualDurationToComplete = Duration(milliseconds: 500);

        fakeAsync((fasync) {
          final longFuture = Future.delayed(actualDurationToComplete, () => 0);

          bool slow = false;

          maybeSlowFuture(
            actualFuture: longFuture,
            threshold: expectedDurationToComplete,
            onSlowCallback: () => slow = true,
          );

          fasync.elapse(const Duration(seconds: 1));

          expect(slow, true);
        });
      },
    );

    test(
      'do not call onSlowCallback when a future completes in the given threshold',
      () {
        const expectedDurationToComplete = Duration(milliseconds: 250);
        const actualDurationToComplete = Duration(milliseconds: 100);

        fakeAsync((fasync) {
          final longFuture = Future.delayed(actualDurationToComplete, () => 0);

          bool slow = false;

          maybeSlowFuture(
            actualFuture: longFuture,
            threshold: expectedDurationToComplete,
            onSlowCallback: () => slow = true,
          );

          fasync.elapse(const Duration(seconds: 1));

          expect(slow, false);
        });
      },
    );
  });
}
