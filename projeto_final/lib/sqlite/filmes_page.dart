import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../helpers/db_helper.dart';
import 'filme.dart';

class FilmesPage extends StatefulWidget {
  const FilmesPage({super.key});

  @override
  _FilmesPageState createState() => _FilmesPageState();
}

class _FilmesPageState extends State<FilmesPage> {
  List<Filme> filmes = [];

  void loadFilmes() async {
    final result = await DBHelper.getAllFilmes();
    setState(() => filmes = result);
  }

  @override
  void initState() {
    super.initState();
    loadFilmes();
  }

  void showGroupDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Grupo'),
        content: Text('Nome do grupo: Flutter Masters'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Filmes'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: showGroupDialog,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: filmes.length,
        itemBuilder: (context, index) {
          final filme = filmes[index];
          return Dismissible(
            key: Key(filme.id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (_) async {
              await DBHelper.delete(filme.id!);
              loadFilmes();
            },
            background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 20), child: Icon(Icons.delete, color: Colors.white)),
            child: ListTile(
              leading: Image.network(filme.imagemUrl, width: 50, fit: BoxFit.cover),
              title: Text(filme.titulo),
              subtitle: RatingBarIndicator(
                rating: filme.pontuacao,
                itemCount: 5,
                itemSize: 20,
                itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
              ),
              onTap: () {
                // Exibir popup com opções
              },
            ),
          );
        },
      ),
    );
  }
}
