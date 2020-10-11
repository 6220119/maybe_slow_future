# verified on Dart verson 2.10.1

# assuming standing at the root folder

# generate json coverage data to `coverage` folder
dart test --coverage=coverage

# the next command requires running `dart pub global activate coverage` once
dart pub global run coverage:format_coverage \
  --in coverage/test/maybe_slow_future_test.dart.vm.json \
  --out coverage/lcov.info \
  --lcov \
  --packages=.dart_tool/package_config.json \
  --report-on=lib/

# the next command requires `brew install lcov` on macOS
genhtml -o coverage/html coverage/lcov.info

# launch browser (macOS)
open coverage/html/index.html
