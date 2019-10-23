class Todo{
  int id; String title; String desc; String time; String did;

  Todo(this.title,this.desc, this.time,this.did);

  Todo.map(dynamic obj){
    this.id = obj['id'];
    this.title = obj['title'];
    this.desc = obj['desc'];
    this.time = obj['Time'];
    this.did = obj['did'];

  }

  int get _id => id;
  String get _title => title;
  String get _desc => desc;
  String get _time => time;
  String get _did => did;

  Map<String, dynamic> toMap (){
    var map = new Map<String , dynamic> ();
    map['id'] = _id;
    map['title'] = _title;
    map['desc'] = _desc;
    map['Time'] = _time;
    map['did'] = _did;
    return map;
  }

  Todo.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.title = map['title'];
    this.desc = map['desc'];
    this.time = map['Time'];
    this.did = map['did'];
  }
}