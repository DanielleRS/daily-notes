class Annotation {
  int id;
  String title;
  String description;
  String date;

  Annotation(this.title, this.description, this.date);

  Map toMap() {
    Map<String, dynamic> map = {
      "title": this.title,
      "description": this.description,
      "date": this.date,
    };

    if(this.id != null) {
      map["id"] = this.id;
    }

    return map;
  }
}