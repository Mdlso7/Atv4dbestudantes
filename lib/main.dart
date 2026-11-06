import 'package:dbestudante/pag1.dart';
import 'package:dbestudante/pag_cursando.dart';
import 'package:dbestudante/pag_disciplina.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(app());
}

class app extends StatelessWidget {
  const app({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "CRUD Escola", home: const Menu());
  }
}

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escola"), backgroundColor: Colors.cyan),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Estudantes"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => pag1())),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text("Disciplinas"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => pagDisciplina())),
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text("Cursando"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => pagCursando())),
          ),
        ],
      ),
    );
  }
}