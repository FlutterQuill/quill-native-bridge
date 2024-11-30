import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:quill_native_bridge_example/main.dart';
import 'package:quill_native_bridge_platform_interface/quill_native_bridge_platform_interface.dart';

// IMPORTANT: Currently, this is not the most straightforward way to mock QuillNativeBridge.
// Since all methods are static, this workaround is required for now.
// In the future this issue will be addressed.

@GenerateMocks([], customMocks: [MockSpec<QuillNativeBridgePlatform>()])
import 'example_test.mocks.dart' as base_mock;

// Add the mixin to make the platform interface accept the mock.
// For more details, refer to https://pub.dev/packages/plugin_platform_interface#mocking-or-faking-platform-interfaces
class _MockQuillNativeBridgePlatform extends base_mock
    .MockQuillNativeBridgePlatform with MockPlatformInterfaceMixin {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockQuillNativeBridgePlatform mockQuillNativeBridgePlatform;

  setUp(() {
    mockQuillNativeBridgePlatform = _MockQuillNativeBridgePlatform();
    QuillNativeBridgePlatform.instance = mockQuillNativeBridgePlatform;
  });

  testWidgets(
    'pressing the `Is iOS Simulator` button shows a $SnackBar with the correct text on iOS devices',
    (tester) async {
      await tester.pumpWidget(const MainApp());

      Future<void> runIsIOSSimulatorTest(
          {required bool isIOSSimulator, expectedSnackbarMessage}) async {
        when(mockQuillNativeBridgePlatform
                .isSupported(QuillNativeBridgeFeature.isIOSSimulator))
            .thenAnswer((_) async => true);

        when(mockQuillNativeBridgePlatform.isIOSSimulator())
            .thenAnswer((_) async => isIOSSimulator);

        final isIOSButton = find.text('Is iOS Simulator');

        expect(isIOSButton, findsOneWidget);

        await tester.tap(isIOSButton);
        await tester.pump();

        expect(find.text(expectedSnackbarMessage), findsOneWidget);
      }

      await runIsIOSSimulatorTest(
        isIOSSimulator: true,
        expectedSnackbarMessage: "You're running the app on iOS simulator.",
      );
      await runIsIOSSimulatorTest(
        isIOSSimulator: false,
        expectedSnackbarMessage: "You're running the app on a real iOS device.",
      );
    },
  );

  testWidgets(
      'pressing the `Is iOS Simulator` button shows a $SnackBar with the correct text on non-iOS devices',
      (tester) async {
    await tester.pumpWidget(const MainApp());

    when(mockQuillNativeBridgePlatform
            .isSupported(QuillNativeBridgeFeature.isIOSSimulator))
        .thenAnswer((_) async => false);

    final isIOSButton = find.text('Is iOS Simulator');

    expect(isIOSButton, findsOneWidget);

    await tester.tap(isIOSButton);
    await tester.pump();

    expect(
      find.text(
          'Available only on iOS to determine if the device is a simulator.'),
      findsOneWidget,
    );
  });
}
