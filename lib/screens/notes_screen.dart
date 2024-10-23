import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<Map<String, String>> _notes = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // _loadNotes();
  }

  // Método para guardar notas localmente
  void _saveNote() async {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      setState(() {
        _notes.add({'title': title, 'description': description});
        _titleController.clear();
        _descriptionController.clear();
      });
      Navigator.of(context).pop();

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('notes', json.encode(_notes));
    }
  }

  void _editNoteDialog(int index) {
    _titleController.text = _notes[index]['title']!;
    _descriptionController.text = _notes[index]['description']!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Nota'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * .50,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El título no puede estar vacío';
                      }
                      if (value.length > 20) {
                        return 'El título no puede ser mas de 20 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La descripción no puede estar vacía';
                      }
                      return null;
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _editNote(index);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _editNote(int index) async {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      setState(() {
        _notes[index] = {'title': title, 'description': description};
        _titleController.clear();
        _descriptionController.clear();
      });
      Navigator.of(context).pop();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('notes', json.encode(_notes));
    }
  }

  void _deleteNote(int index) async {
    setState(() {
      _notes.removeAt(index);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('notes', json.encode(_notes));
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Nota'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * .50,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (value) {
                      // validar que no agregue mas de 50 caracteres
                      if (value == null || value.isEmpty) {
                        return 'El título no puede estar vacío';
                      }
                      if (value.length > 20) {
                        return 'El título no puede ser mas de 20 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La descripción no puede estar vacía';
                      }
                      return null;
                    },
                    inputFormatters: [
                      // limitar a 20 palabras ,
                      LengthLimitingTextInputFormatter(20),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveNote(); // Guardar la nota si el formulario es válido
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Notas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.grey[100], // Fondo claro para un look limpio
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      title: Text(
                        _notes[index]['title']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87, // Texto oscuro para contraste
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _notes[index]['description']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54, // Subtítulo en gris suave
                          ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: Colors
                                .blueAccent, // Color de acento para editar
                            onPressed: () => _editNoteDialog(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.redAccent, // Color de acento sutil
                            onPressed: () => _deleteNote(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
