/// Remember to import the package to be able to use the [Future.onSlow] extension method
import 'package:maybe_slow_future/maybe_slow_future.dart';

void main() {
  print('Fetching data...');

  const timeToComplete = Duration(seconds: 5);

  /// simulate a long running operation
  final fetchDataFuture = Future.delayed(timeToComplete, () {
    print('Got data after ${timeToComplete}: Hello World!');
  });

  /// use the extension method [Future.onSlow]
  fetchDataFuture.onSlow(Duration(seconds: 2), () {
    print('Be patient! It might take a while to complete...');
  });

  /// or use the [maybeSlowFuture] function
  maybeSlowFuture(
    actualFuture: fetchDataFuture,
    threshold: Duration(seconds: 3, milliseconds: 500),
    onSlowCallback: () {
      print('This is taking longer than expected...');
    },
  );

  /// output:
  /// Fetching data...
  /// Be patient! It might take awhile to complete...
  /// This is taking longer than expected...
  /// Got data after 0:00:05.000000: Hello World!
}
