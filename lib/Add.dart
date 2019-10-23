import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:todolist/Database/Helper.dart';
import 'package:todolist/Database/Model.dart';

class AddForm extends StatefulWidget {
  @override
  _AddFormState createState() => _AddFormState();
}

TextEditingController timeController = new TextEditingController(); //to be global

class _AddFormState extends State<AddForm> {
  var db = DatabaseHelper();
  TextEditingController titleController = new TextEditingController();
  TextEditingController descController = new TextEditingController();


  // End variables section

  void _showDialog(bool way) {
    // flutter defined function
    if (way){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(
              "Completed",
              textAlign: TextAlign.center,
            ),
            content: Container(
              child: Icon(
                Icons.check_circle,
                size: 50,
                color: Color.fromRGBO(70, 82, 157, 1),
              ),
            ),
          );
        },
      );
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(
              "Please, fill fields",
              textAlign: TextAlign.center,
            ),
            content: Container(
              child: Icon(
                Icons.remove_circle,
                size: 50,
                color: Colors.red,
              ),
            ),
          );
        },
      );
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(70, 82, 157, 1),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color.fromRGBO(70, 82, 157, 1),
          title: Text('Add new thing'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 50),
                width: MediaQuery.of(context).size.width,
                child: Icon(
                  Icons.assignment,
                  color: Colors.white.withOpacity(0.8),
                  size: 100,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 62,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextField(
                    controller: titleController,
                    style: TextStyle(
                        fontSize: 19, color: Colors.white.withOpacity(0.5)),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.5))),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 62,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextField(
                    controller: descController,
                    style: TextStyle(
                        fontSize: 19, color: Colors.white.withOpacity(0.5)),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Decription',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.5))),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 62,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: BasicTimeField(),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.9)),
                child: MaterialButton(
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 22),
                  ),
                  onPressed: () {
                    if (titleController.text.length > 2 && descController.text.length > 2 && timeController.text.length > 3){
                      db.SaveTodo(new Todo(titleController.text,descController.text,timeController.text,'0'));
                      titleController.text = '';
                      descController.text = '';
                      timeController.text = '';
                      _showDialog(true);
                    }else{

                      _showDialog(false);
                    }
                 // print(timeController.text);

                  },
                ),
              ),
            ],
          ),
        )));
  }
}

class BasicTimeField extends StatelessWidget {
  final format = DateFormat("HH:mm");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      DateTimeField(
    controller: timeController,
        style: TextStyle(color: Colors.white.withOpacity(0.5)),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Time',
          hintStyle:
              TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 19),
        ),
        format: format,
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.convert(time);
        },
      ),
    ]);
  }
}

class BasicDateField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      //Text('Basic date field (${format.pattern})'),
      DateTimeField(
        style: TextStyle(color: Colors.white.withOpacity(0.5)),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Date',
          hintStyle:
              TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 19),
        ),
        format: format,
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    ]);
  }
}
