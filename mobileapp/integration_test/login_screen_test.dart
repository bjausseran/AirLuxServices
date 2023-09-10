import 'package:airlux/screens/login_and_signup/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final WebSocketChannel webSocketChannel =
      WebSocketChannel.connect(Uri.parse('ws://localhost:6001'));

  group('login screen integration test', () {
    testWidgets('test presence of all elements on login screen',
        (tester) async {
      // Créer un widget MaterialApp avec la page de connexion
      await tester.pumpWidget(
          MaterialApp(home: LoginScreen(webSocketChannel: webSocketChannel)));

      // Vérifier la présence du texte "Connectez vous !" à l'écran
      expect(find.text('Connectez vous !!'), findsOneWidget);

      // Vérifier la présence du champ de saisie d'email (CustomTextField)
      expect(find.byKey(const ValueKey('email_field')), findsOneWidget);

      // Vérifier la présence du champ de saisie de mot de passe (CustomTextField)
      expect(find.byKey(const ValueKey('password_field')), findsOneWidget);

      // Vérifier la présence du bouton "Forgot Password"
      expect(
          find.byKey(const ValueKey('forgot_password_button')), findsOneWidget);

      // Vérifier la présence du bouton "Login"
      expect(find.byKey(const ValueKey('login_button')), findsOneWidget);

      // Vérifier la présence du bouton "Create Account"
      expect(
          find.byKey(const ValueKey('create_account_button')), findsOneWidget);
    });
  });
}
