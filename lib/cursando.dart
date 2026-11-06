class Cursando {
  int? id;
  int estudanteId;
  int disciplinaId;

  // Solo vienen del JOIN (no se guardan en la tabla)
  String? estudanteNome;
  String? matricula;
  String? disciplinaNome;
  String? professor;

  Cursando({
    this.id,
    required this.estudanteId,
    required this.disciplinaId,
    this.estudanteNome,
    this.matricula,
    this.disciplinaNome,
    this.professor,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'estudante_id': estudanteId,
      'disciplina_id': disciplinaId,
    };
  }

  factory Cursando.fromMap(Map<String, dynamic> map) {
    return Cursando(
      id: map['id'],
      estudanteId: map['estudante_id'],
      disciplinaId: map['disciplina_id'],
      estudanteNome: map['estudante_nome'],
      matricula: map['matricula'],
      disciplinaNome: map['disciplina_nome'],
      professor: map['professor'],
    );
  }
}