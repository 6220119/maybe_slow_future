import 'package:fake_async/fake_async.dart';
import 'package:maybe_slow_future/maybe_slow_future.dart';
import 'package:test/test.dart';

void verifyOnSlowCallback({
  int expectedTimeToComplete,
  int actualTimeToComplete,
  bool expectSlowCallbackCalled,
}) {
  final expectedDurationToComplete = Duration(
    milliseconds: expectedTimeToComplete,
  );

  final actualDurationToComplete = Duration(
    milliseconds: actualTimeToComplete,
  );

  fakeAsync((fasync) {
    final longFuture = Future.delayed(
      actualDurationToComplete,
      () => 'dummyResult',
    );

    bool isSlowCallbackCalled = false;

    maybeSlowFuture(
      actualFuture: longFuture,
      threshold: expectedDurationToComplete,
      onSlowCallback: () => isSlowCallbackCalled = true,
    );

    fasync.elapse(const Duration(seconds: 1));

    expect(isSlowCallbackCalled, expectSlowCallbackCalled);
  });
}

void main() {
  group('maybeSlowFuture', () {
    test(
      'call onSlowCallback when a future fails to complete in the given threshold',
      () {
        verifyOnSlowCallback(
          expectedTimeToComplete: 250,
          actualTimeToComplete: 500,
          expectSlowCallbackCalled: true,
        );
      },
    );

    test(
      'do not call onSlowCallback when a future completes in the given threshold',
      () {
        verifyOnSlowCallback(
          expectedTimeToComplete: 250,
          actualTimeToComplete: 100,
          expectSlowCallbackCalled: false,
        );
      },
    );

    test(
      'assert actualFuture is required',
      () {
        expect(
          () => maybeSlowFuture(
            actualFuture: null,
            threshold: Duration(),
            onSlowCallback: () {},
          ),
          throwsA(isA<Error>()),
        );
      },
    );

    test(
      'assert threshold is required',
      () {
        expect(
          () => maybeSlowFuture(
            actualFuture: Future.value(0),
            threshold: null,
            onSlowCallback: () {},
          ),
          throwsA(isA<Error>()),
        );
      },
    );

    test(
      'assert onSlowCallback is required',
      () {
        expect(
          () => maybeSlowFuture(
            actualFuture: Future.value(0),
            threshold: Duration(),
            onSlowCallback: null,
          ),
          throwsA(isA<Error>()),
        );
      },
    );

    test('example of using extension method', () {
      fakeAsync((fasync) {
        final operation = Future.delayed(
          Duration(milliseconds: 1000),
          () => 'dummyValue',
        );

        bool isSlowOperation = false;
        // using extension variant
        operation.onSlow(Duration(milliseconds: 500), () {
          isSlowOperation = true;
        });

        operation.then((value) => expect(value, 'dummyValue'));

        fasync.elapse(Duration(milliseconds: 1000));

        expect(isSlowOperation, true);
      });
    });
  });
}
