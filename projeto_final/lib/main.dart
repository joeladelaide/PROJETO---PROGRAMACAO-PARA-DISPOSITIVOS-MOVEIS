import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// Função principal que inicializa o app
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// Widget principal do aplicativo
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          shape: CircleBorder(),
        ),
      ),
      title: 'Gerenciador de Filmes',
      home: HomePage(),
    );
  }
}

// Classe que representa um filme
class Filme {
  int? id;
  String titulo;
  String genero;
  String faixaEtaria;
  String duracao;
  double pontuacao;
  String descricao;
  String ano;
  String imagemUrl;

  Filme({
    this.id,
    required this.titulo,
    required this.genero,
    required this.faixaEtaria,
    required this.duracao,
    required this.pontuacao,
    required this.descricao,
    required this.ano,
    required this.imagemUrl,
  });
}

// Tela principal que lista os filmes
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Filme> filmes = [
    Filme(
      id: 1,
      titulo: 'Velozes e Furiosos 8',
      genero: 'Ação, Aventura e Crime',
      faixaEtaria: '12',
      duracao: '2h 16min',
      pontuacao: 4.0,
      descricao:
          'Dom é seduzido por uma mulher misteriosa e volta ao mundo do crime.',
      ano: '2017',
      imagemUrl:
          'https://upload.wikimedia.org/wikipedia/pt/1/15/Velozes_e_Furiosos_8_p%C3%B4ster.jpg',
    ),
    Filme(
      id: 2,
      titulo: 'Harry Potter e o Cálice de Fogo',
      genero: 'Aventura, Família e Fantasia',
      faixaEtaria: '12',
      duracao: '2h 37min',
      pontuacao: 4.0,
      descricao:
          'Harry é misteriosamente selecionado para participar do Torneio Tribruxo.',
      ano: '2005',
      imagemUrl:
          'https://upload.wikimedia.org/wikipedia/pt/7/7b/Harry_Potter_C%C3%A1lice_Fogo_2004.jpg',
    ),
  ];

  void _mostrarAlertaGrupo() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Equipe:'),
            content: Text(
              'Joel Adelaide Medeiros - RGM: 29799384 \nMarcos Barbosa Vieira Filho - RGM: 30174503',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  void _exibirFormulario({Filme? filme}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormularioFilmePage(filme: filme)),
    );

    if (resultado != null && resultado is Filme) {
      setState(() {
        if (filme != null) {
          int index = filmes.indexOf(filme);
          filmes[index] = resultado;
        } else {
          filmes.add(resultado);
        }
      });
    }
  }

  void _exibirDetalhes(Filme filme) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalhesFilmePage(filme: filme)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filmes', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: _mostrarAlertaGrupo,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _exibirFormulario(),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: filmes.length,
        itemBuilder: (context, index) {
          final filme = filmes[index];
          return Dismissible(
            key: Key(filme.id.toString()),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              setState(() {
                filmes.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${filme.titulo} removido')),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 16),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              margin: EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder:
                        (_) => Wrap(
                          children: [
                            ListTile(
                              leading: Icon(Icons.info),
                              title: Text('Exibir Dados'),
                              onTap: () {
                                Navigator.pop(context);
                                _exibirDetalhes(filme);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Alterar'),
                              onTap: () {
                                Navigator.pop(context);
                                _exibirFormulario(filme: filme);
                              },
                            ),
                          ],
                        ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        filme.imagemUrl,
                        width: 70,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filme.titulo,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              filme.genero,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            Text(
                              filme.duracao,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            SizedBox(height: 8),
                            RatingBarIndicator(
                              rating: filme.pontuacao,
                              itemCount: 5,
                              itemSize: 20,
                              itemBuilder:
                                  (context, _) =>
                                      Icon(Icons.star, color: Colors.amber),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FormularioFilmePage extends StatefulWidget {
  final Filme? filme;
  FormularioFilmePage({this.filme});

  @override
  _FormularioFilmePageState createState() => _FormularioFilmePageState();
}

class _FormularioFilmePageState extends State<FormularioFilmePage> {
  final _formKey = GlobalKey<FormState>();
  final _faixas = ['Livre', '10', '12', '14', '16', '18'];
  late TextEditingController _titulo;
  late TextEditingController _genero;
  late TextEditingController _duracao;
  late TextEditingController _descricao;
  late TextEditingController _ano;
  late TextEditingController _imagemUrl;
  String faixaSelecionada = 'Livre';
  double _pontuacao = 0;

  @override
  void initState() {
    super.initState();
    _titulo = TextEditingController(text: widget.filme?.titulo ?? '');
    _genero = TextEditingController(text: widget.filme?.genero ?? '');
    _duracao = TextEditingController(text: widget.filme?.duracao ?? '');
    _descricao = TextEditingController(text: widget.filme?.descricao ?? '');
    _ano = TextEditingController(text: widget.filme?.ano ?? '');
    _imagemUrl = TextEditingController(text: widget.filme?.imagemUrl ?? '');
    faixaSelecionada = widget.filme?.faixaEtaria ?? 'Livre';
    _pontuacao = widget.filme?.pontuacao ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.filme == null ? 'Cadastrar Filme' : 'Editar Filme',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _imagemUrl,
                  decoration: InputDecoration(labelText: 'Url Imagem'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Informe a imagem'
                              : null,
                ),
                TextFormField(
                  controller: _titulo,
                  decoration: InputDecoration(labelText: 'Título'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Informe o título'
                              : null,
                ),
                TextFormField(
                  controller: _genero,
                  decoration: InputDecoration(labelText: 'Gênero'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Informe o gênero'
                              : null,
                ),
                DropdownButtonFormField<String>(
                  value: faixaSelecionada,
                  onChanged:
                      (valor) => setState(() => faixaSelecionada = valor!),
                  items:
                      _faixas
                          .map(
                            (faixa) => DropdownMenuItem(
                              value: faixa,
                              child: Text(faixa),
                            ),
                          )
                          .toList(),
                  decoration: InputDecoration(labelText: 'Faixa Etária'),
                ),
                TextFormField(
                  controller: _duracao,
                  decoration: InputDecoration(labelText: 'Duração'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Informe a duração'
                              : null,
                ),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Nota:', style: TextStyle(fontSize: 16)),
                ),
                RatingBar.builder(
                  initialRating: _pontuacao,
                  minRating: 0,
                  maxRating: 5,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 30.0,
                  itemBuilder:
                      (context, _) => Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (valor) => setState(() => _pontuacao = valor),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _ano,
                  decoration: InputDecoration(labelText: 'Ano'),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Informe o ano'
                              : null,
                ),
                TextFormField(
                  controller: _descricao,
                  decoration: InputDecoration(labelText: 'Descrição'),
                  maxLines: 4,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Informe a descrição'
                              : null,
                ),
                SizedBox(height: 80), // espaço para o botão flutuante
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pop(
              context,
              Filme(
                id: widget.filme?.id ?? DateTime.now().millisecondsSinceEpoch,
                titulo: _titulo.text,
                genero: _genero.text,
                faixaEtaria: faixaSelecionada,
                duracao: _duracao.text,
                pontuacao: _pontuacao,
                descricao: _descricao.text,
                ano: _ano.text,
                imagemUrl: _imagemUrl.text,
              ),
            );
          }
        },
        child: Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}

class DetalhesFilmePage extends StatelessWidget {
  final Filme filme;
  DetalhesFilmePage({required this.filme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(filme.imagemUrl, height: 200)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    filme.titulo,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(filme.ano, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(filme.genero),
                Text(
                  '${filme.faixaEtaria} anos',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(filme.duracao),
                RatingBarIndicator(
                  rating: filme.pontuacao,
                  itemCount: 5,
                  itemSize: 20,
                  itemBuilder:
                      (context, _) => Icon(Icons.star, color: Colors.amber),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(filme.descricao, textAlign: TextAlign.justify),
          ],
        ),
      ),
    );
  }
}
