// lib/main.dart

import 'dart:io'; // Importe a biblioteca dart:io
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'http_overrides.dart'; // Importe o arquivo que você acabou de criar
import 'transacao_pix_model.dart';

void main() {
  // Adicione estas duas linhas
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PIX BCB App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const PixDataScreen(),
    );
  }
}

class PixDataScreen extends StatefulWidget {
  const PixDataScreen({super.key});

  @override
  _PixDataScreenState createState() => _PixDataScreenState();
}

class _PixDataScreenState extends State<PixDataScreen> {
  // Criamos uma instância do nosso serviço de API
  final ApiService _apiService = ApiService();
  // Future para armazenar o resultado da chamada da API
  late Future<List<TransacaoPix>> _transacoesFuture;

  @override
  void initState() {
    super.initState();
    // Iniciamos a chamada da API assim que a tela é construída
    _transacoesFuture = _apiService.fetchTransacoesPix();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações PIX por Município (08/2025)'),
      ),
      body: FutureBuilder<List<TransacaoPix>>(
        future: _transacoesFuture,
        builder: (context, snapshot) {
          // 1. Enquanto os dados estão carregando, mostramos um spinner
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. Se ocorreu um erro na requisição
          else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          // 3. Se os dados foram carregados com sucesso
          else if (snapshot.hasData) {
            final transacoes = snapshot.data!;
            return ListView.builder(
              itemCount: transacoes.length,
              itemBuilder: (context, index) {
                final transacao = transacoes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(transacao.uf),
                    ),
                    title: Text(
                      transacao.municipio,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Pagamentos: ${transacao.quantidadePagamentos}\nRecebimentos: ${transacao.quantidadeRecebimentos}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          }
          // 4. Caso não se encaixe em nenhum dos cenários acima (pouco provável)
          else {
            return const Center(child: Text('Nenhum dado encontrado.'));
          }
        },
      ),
    );
  }
}