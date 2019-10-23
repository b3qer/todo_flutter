import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/Add.dart';
import 'package:todolist/Database/Helper.dart';
import 'package:todolist/Database/Model.dart';
import 'package:todolist/bloc.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

int allTodos = 0;
var db = DatabaseHelper();
var toDos = [];

class _MyHomeState extends State<MyHome> {
  bool checkb = false;
  int completed = 0;
  static var now = new DateTime.now();
  static var date = DateTime.parse(now.toString());
  var formattedDate = "${date.year}-${date.month}-${date.day}";

  Widget buildList(AsyncSnapshot<List<Todo>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        return Container(
          height: 70,
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[400]))),
          child: Dismissible(
            key: Key(snapshot.data[index].id.toString()),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (direction) {
              db.deleteTodo(snapshot.data[index].id);
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Deleted'),
              ));
            },
            child: ListTile(
              onLongPress: () {
                db.deleteTodo(snapshot.data[index].id);
              },
              leading: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Checkbox(
                  value: snapshot.data[index].did == '0' ? false : true,
                  onChanged: (bool value) {
                    db.updateTodo(toDos[index]);

                    // changeDid(toDos[index]);
                  },
                ),
              ),
              title: Text(
                '${snapshot.data[index].title}',
                style: TextStyle(
                  decoration: snapshot.data[index].did == '1'
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              subtitle: Text("${snapshot.data[index].desc}",
                  style: TextStyle(
                    decoration: snapshot.data[index].did == '1'
                        ? TextDecoration.lineThrough
                        : null,
                  )),
              trailing: Text("${snapshot.data[index].time}"),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.fetchAllTodos();
    getcount();
  }

  @override
  Widget build(BuildContext context) {
    bloc.fetchAllTodos();
    bloc.fetchCount();
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/herob.jpg'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 20,
                        offset: Offset(0, 10))
                  ]),
              child: Container(
                padding: EdgeInsets.only(top: 140, left: 20),
                child: Text(
                  'Your Things',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'INBOX',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'COMPLETED',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: StreamBuilder(
                              stream: bloc.count,
                              builder: (context, AsyncSnapshot<int> snapshot) {
                                return Container(
                                  width: 25,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${snapshot.data}',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                  ),
                                );
                              },
                            )
//
                            ),
                      ],
                    ),
                  )
                ],
              ),
              padding: EdgeInsets.only(left: 20, top: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 20),
                child: StreamBuilder(
                  stream: bloc.allTodos,
                  builder: (context, AsyncSnapshot<List<Todo>> snapshot) {
                    if (snapshot.hasData && snapshot.data.length > 0) {
                      return buildList(snapshot);
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    return Center(
                      child: Text('Add Todo, it will appear here'),
                      // child: CircularProgressIndicator()
                    );
                  },
                ),

                //buildList()
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddForm()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(69, 98, 159, 1),
      ),
    );
  }
}

getcount() async {
  int num = await db.getCount();
  allTodos = num;
  print(allTodos);
}

getTodos() async {
  toDos = await db.getTodos();
}
