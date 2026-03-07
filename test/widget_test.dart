import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_app/app.dart';

void main() {
  testWidgets('Login page is shown on app start', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Log In'), findsWidgets);
    expect(find.byType(TextFormField), findsWidgets);
  });
}
