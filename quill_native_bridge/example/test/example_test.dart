import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quill_native_bridge/quill_native_bridge.dart';
import 'package:quill_native_bridge_example/main.dart';

@GenerateMocks([QuillNativeBridge])
import 'example_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockQuillNativeBridge mockQuillNativeBridge;

  setUp(() {
    mockQuillNativeBridge = MockQuillNativeBridge();
    quillNativeBridge = mockQuillNativeBridge;
  });

  testWidgets(
    'pressing the `Is iOS Simulator` button shows a $SnackBar with the correct text on iOS devices',
    (tester) async {
      await tester.pumpWidget(const MainApp());

      Future<void> runIsIOSSimulatorTest(
          {required bool isIOSSimulator, expectedSnackbarMessage}) async {
        when(mockQuillNativeBridge
                .isSupported(QuillNativeBridgeFeature.isIOSSimulator))
            .thenAnswer((_) async => true);

        when(mockQuillNativeBridge.isIOSSimulator())
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

    when(mockQuillNativeBridge
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
