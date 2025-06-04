class Filme {
  int? id;
  String titulo;
  String imagemUrl;
  String genero;
  String faixaEtaria;
  int duracao;
  double pontuacao;
  String descricao;
  int ano;

  Filme({
    this.id,
    required this.titulo,
    required this.imagemUrl,
    required this.genero,
    required this.faixaEtaria,
    required this.duracao,
    required this.pontuacao,
    required this.descricao,
    required this.ano,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'imagemUrl': imagemUrl,
      'genero': genero,
      'faixaEtaria': faixaEtaria,
      'duracao': duracao,
      'pontuacao': pontuacao,
      'descricao': descricao,
      'ano': ano,
    };
  }

  factory Filme.fromMap(Map<String, dynamic> map) {
    return Filme(
      id: map['id'],
      titulo: map['titulo'],
      imagemUrl: map['imagemUrl'],
      genero: map['genero'],
      faixaEtaria: map['faixaEtaria'],
      duracao: map['duracao'],
      pontuacao: map['pontuacao'],
      descricao: map['descricao'],
      ano: map['ano'],
    );
  }
}
