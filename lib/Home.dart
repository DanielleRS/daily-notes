import 'package:flutter/material.dart';
import 'package:daily_notes/model/Annotation.dart';
import 'package:daily_notes/helper/AnnotationHelper.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  var _db = AnnotationHelper();

  _displayRegistrationScreen() {
    showDialog(
        context: context,
      builder: (context) {
          return AlertDialog(
            title: Text("Adicionar anotações"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Título",
                    hintText: "Digite título..."
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Digite descrição..."
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar"),
              ),
              FlatButton(
                onPressed: () {
                  _saveAnnotation();
                  Navigator.pop(context);
                },
                child: Text("Salvar"),
              )
            ],
          );
      }
    );
  }

  _saveAnnotation() async {
    String title = _titleController.text;
    String description = _descriptionController.text;

    Annotation annotation = Annotation(title, description, DateTime.now().toString());
    int result = await _db.saveAnnotation(annotation);
    print("salvar anotacao: " + result.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: _displayRegistrationScreen
      ),
    );
  }
}
