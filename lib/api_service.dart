// lib/api_service.dart

import 'package:http/http.dart' as http;
import 'transacao_pix_model.dart'; // Importamos nosso modelo

class ApiService {
  // A URL da API com a data de Agosto de 2025
  static const String _baseUrl =
      "https://olinda.bcb.gov.br/olinda/servico/Pix_DadosAbertos/versao/v1/odata/TransacoesPixPorMunicipio(DataBase=@DataBase)?@DataBase='202507'&\$top=100&\$format=json";

  Future<List<TransacaoPix>> fetchTransacoesPix() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        // Se a chamada à API for bem-sucedida, decodifica o JSON.
        // Usamos a função auxiliar que criamos no nosso modelo.
        return transacoesPixFromJson(response.body);
      } else {
        // Se a chamada não for bem-sucedida, lança um erro.
        throw Exception('Falha ao carregar os dados da API. Código: ${response.statusCode}');
      }
    } catch (e) {
      // Captura erros de rede ou outros problemas
      throw Exception('Ocorreu um erro: $e');
    }
  }
}
