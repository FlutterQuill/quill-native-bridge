import 'package:flutter_test/flutter_test.dart';
import 'package:quill_native_bridge_windows/src/environment_provider.dart';

void main() {
  test('defaults to $DefaultEnvironmentProvider', () {
    expect(EnvironmentProvider.instance, isA<DefaultEnvironmentProvider>());
  });
  test('should update the instance correctly', () {
    expect(
        EnvironmentProvider.instance, isNot(isA<_FakeEnvironmentProvider>()));

    EnvironmentProvider.instance = _FakeEnvironmentProvider();
    expect(EnvironmentProvider.instance, isA<_FakeEnvironmentProvider>());
  });

  test(
      'environment getter from the instance delegates to the new provider instance',
      () {
    final fake = _FakeEnvironmentProvider();
    fake.testEnvironment.addAll({
      'test': 'foo/bar',
    });
    EnvironmentProvider.instance = fake;
    expect(EnvironmentProvider.instance.environment, fake.environment);
  });

  test('setToDefault restore the default instance', () {
    final fake = _FakeEnvironmentProvider();
    EnvironmentProvider.instance = fake;

    EnvironmentProvider.setToDefault();
    expect(EnvironmentProvider.instance, isA<DefaultEnvironmentProvider>());
  });
}

class _FakeEnvironmentProvider implements DefaultEnvironmentProvider {
  final Map<String, String> testEnvironment = {};
  @override
  Map<String, String> get environment => testEnvironment;
}
