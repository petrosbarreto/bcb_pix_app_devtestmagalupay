// lib/transacao_pix_model.dart

import 'dart:convert';

// Função para ajudar a decodificar a resposta JSON completa
List<TransacaoPix> transacoesPixFromJson(String str) {
  final jsonData = json.decode(str);
  // A API do OData retorna os dados dentro de um array chamado "value"
  final List<dynamic> values = jsonData['value'];
  return List<TransacaoPix>.from(values.map((x) => TransacaoPix.fromJson(x)));
}

class TransacaoPix {
  final String municipio;
  final String uf;
  final int totalPagamentos;
  final int quantidadePagamentos;
  final int totalRecebimentos;
  final int quantidadeRecebimentos;

  TransacaoPix({
    required this.municipio,
    required this.uf,
    required this.totalPagamentos,
    required this.quantidadePagamentos,
    required this.totalRecebimentos,
    required this.quantidadeRecebimentos,
  });

  // Factory constructor para criar uma instância a partir de um mapa JSON
  factory TransacaoPix.fromJson(Map<String, dynamic> json) {
    return TransacaoPix(
      municipio: json['Municipio'] ?? 'N/A',
      uf: json['UF'] ?? 'N/A',
      // Os dados de Pagamentos e Recebimentos são objetos aninhados
      totalPagamentos: json['Pagamentos']?['Total'] ?? 0,
      quantidadePagamentos: json['Pagamentos']?['Quantidade'] ?? 0,
      totalRecebimentos: json['Recebimentos']?['Total'] ?? 0,
      quantidadeRecebimentos: json['Recebimentos']?['Quantidade'] ?? 0,
    );
  }
}