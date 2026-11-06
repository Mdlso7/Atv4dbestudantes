import 'package:dbestudante/disciplina.dart';
import 'package:dbestudante/disciplina_dao.dart';
import 'package:flutter/material.dart';

class pagDisciplina extends StatefulWidget {
  const pagDisciplina({super.key});

  @override
  State<pagDisciplina> createState() => _pagDisciplinaState();
}

class _pagDisciplinaState extends State<pagDisciplina> {
  final _disciplinaDAO = DisciplinaDao();
  Disciplina? _disciplinaAtual;

  final _controllerNome = TextEditingController();
  final _controllerProfessor = TextEditingController();
  List<Disciplina> _listaDisciplinas = [];

  @override
  void initState() {
    _loadDisciplinas();
    super.initState();
  }

  _loadDisciplinas() async {
    List<Disciplina> temp = await _disciplinaDAO.listarDisciplinas();
    setState(() {
      _listaDisciplinas = temp;
    });
  }

  _salvarOUEditar() async {
    if (_controllerNome.text.isEmpty || _controllerProfessor.text.isEmpty) {
      return;
    }
    if (_disciplinaAtual == null) {
      await _disciplinaDAO.incluirDisciplina(Disciplina(
          nome: _controllerNome.text, professor: _controllerProfessor.text));
    } else {
      _disciplinaAtual!.nome = _controllerNome.text;
      _disciplinaAtual!.professor = _controllerProfessor.text;
      await _disciplinaDAO.editarDisciplina(_disciplinaAtual!);
    }
    _controllerNome.clear();
    _controllerProfessor.clear();
    _disciplinaAtual = null;
    _loadDisciplinas();
  }

  _apagarDisciplina(int index) async {
    await _disciplinaDAO.deleteDisciplina(index);
    _loadDisciplinas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD Disciplina"),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controllerNome,
              decoration: InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controllerProfessor,
              decoration: InputDecoration(
                labelText: "Professor",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
              child:
                  _disciplinaAtual == null ? Text("Salvar") : Text("Atualizar"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _listaDisciplinas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_listaDisciplinas[index].nome),
                  subtitle: Text(_listaDisciplinas[index].professor),
                  trailing: IconButton(
                    onPressed: () {
                      _apagarDisciplina(_listaDisciplinas[index].id!);
                    },
                    icon: Icon(Icons.delete),
                  ),
                  onTap: () {
                    setState(() {
                      _disciplinaAtual = _listaDisciplinas[index];
                      _controllerNome.text = _disciplinaAtual!.nome;
                      _controllerProfessor.text = _disciplinaAtual!.professor;
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