import 'package:dbestudante/DatabaseHelper.dart';
import 'package:dbestudante/cursando.dart';
import 'package:sqflite/sqflite.dart';

class CursandoDao {
  final Databasehelper _dbHelper = Databasehelper();

  Future<void> incluirCursando(Cursando c) async {
    final db = await _dbHelper.database;
    await db.insert(
      "cursando",
      c.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> editarCursando(Cursando c) async {
    final db = await _dbHelper.database;
    await db.update(
      "cursando",
      c.toMap(),
      where: "id = ?",
      whereArgs: [c.id],
    );
  }

  Future<void> deleteCursando(int index) async {
    final db = await _dbHelper.database;
    await db.delete(
      "cursando",
      where: "id = ?",
      whereArgs: [index],
    );
  }

  // JOIN: une cursando + estudante + disciplina
  Future<List<Cursando>> listarCursando() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT c.id, c.estudante_id, c.disciplina_id,
             e.nome AS estudante_nome, e.matricula,
             d.nome AS disciplina_nome, d.professor
      FROM cursando c
      JOIN estudante e ON e.id = c.estudante_id
      JOIN disciplina d ON d.id = c.disciplina_id
      ORDER BY e.nome
    ''');
    return List.generate(maps.length, (index) {
      return Cursando.fromMap(maps[index]);
    });
  }
}