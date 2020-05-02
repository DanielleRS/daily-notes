import 'package:flutter/material.dart';
import 'package:daily_notes/model/Annotation.dart';
import 'package:daily_notes/helper/AnnotationHelper.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  var _db = AnnotationHelper();
  List<Annotation> _annotation = List<Annotation>();

  _displayRegistrationScreen({Annotation annotation}) {
    String textSaveUpdate = "";
    if(annotation == null) { //save
      _titleController.text = "";
      _descriptionController.text = "";
      textSaveUpdate = "Salvar";
    } else { //update
      _titleController.text = annotation.title;
      _descriptionController.text = annotation.description;
      textSaveUpdate = "Atualizar";
    }

    showDialog(
        context: context,
      builder: (context) {
          return AlertDialog(
            title: Text("$textSaveUpdate anotações"),
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
                  _saveUpdateAnnotation(annotationSelected: annotation);
                  Navigator.pop(context);
                },
                child: Text(textSaveUpdate),
              )
            ],
          );
      }
    );
  }

  _retrieveNotes() async {
    List retrieveNotes = await _db.retrieveNotes();
    List<Annotation> listTemp = List<Annotation>();
    for(var item in retrieveNotes) {
      Annotation annotation = Annotation.fromMap(item);
      listTemp.add(annotation);
    }
    setState(() {
      _annotation = listTemp;
    });
    listTemp = null;

    //print("Lista anotacoes: " + retrieveNotes.toString());
  }

  _saveUpdateAnnotation({Annotation annotationSelected}) async {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if(annotationSelected == null) { //save
      Annotation annotation = Annotation(title, description, DateTime.now().toString());
      int result = await _db.saveAnnotation(annotation);
    } else { //update
      annotationSelected.title = title;
      annotationSelected.description = description;
      annotationSelected.date = DateTime.now().toString();
      int result = await _db.updateAnnotation(annotationSelected);
    }

    _titleController.clear();
    _descriptionController.clear();

    _retrieveNotes();
  }

  _formatDate(String date) {
    initializeDateFormatting("pt_BR");
    //var formater = DateFormat("d/MMM/y H:m:s");
    var formater = DateFormat.yMd("pt-BR");

    DateTime convertDate = DateTime.parse(date);
    String dateFormat = formater.format(convertDate);

    return dateFormat;
  }

  _removeAnnotation(int id) async {
    await _db.removeAnnotation(id);
    _retrieveNotes();
  }

  @override
  void initState() {
    super.initState();
    _retrieveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _annotation.length,
                itemBuilder: (context, index) {
                  final annotation = _annotation[index];
                  return Card(
                    child: ListTile(
                      title: Text(annotation.title),
                      subtitle: Text("${_formatDate(annotation.date)} - ${annotation.description}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              _displayRegistrationScreen(annotation: annotation);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.edit,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              _removeAnnotation(annotation.id);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: () {
            _displayRegistrationScreen();
          }
      ),
    );
  }
}
