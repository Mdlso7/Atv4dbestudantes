import 'package:dbestudante/cursando.dart';
import 'package:dbestudante/cursando_dao.dart';
import 'package:dbestudante/disciplina.dart';
import 'package:dbestudante/disciplina_dao.dart';
import 'package:dbestudante/estudante.dart';
import 'package:dbestudante/estudante_dao.dart';
import 'package:flutter/material.dart';

class pagCursando extends StatefulWidget {
  const pagCursando({super.key});

  @override
  State<pagCursando> createState() => _pagCursandoState();
}

class _pagCursandoState extends State<pagCursando> {
  final _cursandoDAO = CursandoDao();
  final _estudanteDAO = EstudanteDao();
  final _disciplinaDAO = DisciplinaDao();

  Cursando? _cursandoAtual;
  int? _estudanteId;
  int? _disciplinaId;

  List<Cursando> _listaCursando = [];
  List<Estudante> _listaEstudantes = [];
  List<Disciplina> _listaDisciplinas = [];

  @override
  void initState() {
    _loadTudo();
    super.initState();
  }

  _loadTudo() async {
    final c = await _cursandoDAO.listarCursando(); // usa o JOIN
    final e = await _estudanteDAO.listarEstudantes();
    final d = await _disciplinaDAO.listarDisciplinas();
    setState(() {
      _listaCursando = c;
      _listaEstudantes = e;
      _listaDisciplinas = d;
    });
  }

  _salvarOUEditar() async {
    if (_estudanteId == null || _disciplinaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selecione estudante e disciplina")),
      );
      return;
    }
    if (_cursandoAtual == null) {
      await _cursandoDAO.incluirCursando(
          Cursando(estudanteId: _estudanteId!, disciplinaId: _disciplinaId!));
    } else {
      _cursandoAtual!.estudanteId = _estudanteId!;
      _cursandoAtual!.disciplinaId = _disciplinaId!;
      await _cursandoDAO.editarCursando(_cursandoAtual!);
    }
    setState(() {
      _estudanteId = null;
      _disciplinaId = null;
      _cursandoAtual = null;
    });
    _loadTudo();
  }

  _apagarCursando(int index) async {
    await _cursandoDAO.deleteCursando(index);
    _loadTudo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD Cursando"),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Estudante",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _estudanteId,
                  hint: Text("Selecione"),
                  items: _listaEstudantes
                      .map((e) => DropdownMenuItem<int>(
                            value: e.id,
                            child: Text("${e.nome} (${e.matricula})"),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _estudanteId = v),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: "Disciplina",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _disciplinaId,
                  hint: Text("Selecione"),
                  items: _listaDisciplinas
                      .map((d) => DropdownMenuItem<int>(
                            value: d.id,
                            child: Text(d.nome),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _disciplinaId = v),
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                _salvarOUEditar();
              },
              child: _cursandoAtual == null ? Text("Salvar") : Text("Atualizar"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listaCursando.length,
              itemBuilder: (context, index) {
                final c = _listaCursando[index];
                return ListTile(
                  title: Text("${c.estudanteNome} (${c.matricula})"),
                  subtitle: Text("${c.disciplinaNome} - Prof. ${c.professor}"),
                  trailing: IconButton(
                    onPressed: () {
                      _apagarCursando(c.id!);
                    },
                    icon: Icon(Icons.delete),
                  ),
                  onTap: () {
                    setState(() {
                      _cursandoAtual = c;
                      _estudanteId = c.estudanteId;
                      _disciplinaId = c.disciplinaId;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}