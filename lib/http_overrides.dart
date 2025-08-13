// lib/http_overrides.dart

import 'dart:io';

// Classe para sobrescrever o comportamento padrão de verificação de certificados HTTP.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
    // Esta linha é a chave: ela diz ao cliente para aceitar qualquer certificado,
    // mesmo que a verificação falhe.
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}