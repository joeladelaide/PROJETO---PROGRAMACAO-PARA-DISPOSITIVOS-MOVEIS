import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../helpers/db_helper.dart';

class CadastroFilme extends StatefulWidget {
  const CadastroFilme({super.key});

  @override
  _CadastroFilmeState createState() => _CadastroFilmeState();
}

class _CadastroFilmeState extends State<CadastroFilme> {
  final _tituloController = TextEditingController();
  final _diretorController = TextEditingController();
  double _nota = 0.0;

  void _salvarFilme() async {
    final filme = {
      'titulo': _tituloController.text,
      'diretor': _diretorController.text,
      'nota': _nota,
    };

    await DBHelper.inserirFilme(filme);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Filme salvo com sucesso!')),
    );

    _tituloController.clear();
    _diretorController.clear();
    setState(() {
      _nota = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Filme')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _diretorController,
              decoration: InputDecoration(labelText: 'Diretor'),
            ),
            SizedBox(height: 16),
            RatingBar.builder(
              initialRating: _nota,
              minRating: 0,
              maxRating: 5,
              allowHalfRating: true,
              itemCount: 5,
              itemBuilder: (context, _) =>
                  Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  _nota = rating;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarFilme,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
