import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

class ListaFilmes extends StatelessWidget {
  const ListaFilmes({super.key});

  Future<List<Map<String, dynamic>>> _carregarFilmes() async {
    return await DBHelper.listarFilmes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filmes Salvos')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _carregarFilmes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final filmes = snapshot.data!;
          if (filmes.isEmpty) return Center(child: Text('Nenhum filme salvo.'));
          return ListView.builder(
            itemCount: filmes.length,
            itemBuilder: (context, index) {
              final filme = filmes[index];
              return ListTile(
                title: Text(filme['titulo']),
                subtitle: Text('Diretor: ${filme['diretor']}'),
                trailing: Text('Nota: ${filme['nota'].toStringAsFixed(1)}'),
              );
            },
          );
        },
      ),
    );
  }
}
