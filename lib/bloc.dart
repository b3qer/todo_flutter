import 'package:rxdart/rxdart.dart';
import 'package:rxdart/rxdart.dart' as prefix0;
import 'package:todolist/Database/Helper.dart';
import 'package:todolist/Database/Model.dart';
import 'package:todolist/Home.dart';

class TodosBloc {
  final _repository = DatabaseHelper();
  final _todoFetcher = PublishSubject<List<Todo>>();
  final _countFetcher = PublishSubject<int>();

  Observable<int> get count => _countFetcher.stream;
  Observable<List<Todo>> get allTodos => _todoFetcher.stream;

  fetchCount() async{
    int res = await _repository.getCount();
    _countFetcher.sink.add(res);
  }


  fetchAllTodos() async {
    //getcount();
    getTodos();
    var myTodos = await _repository.getTodos();
    List<Todo> todos = [];
    for (int i = 0; i < myTodos.length; i++) {
      Todo todo = Todo.map(myTodos[i]);
      todos.add(todo);
    }

    _todoFetcher.sink.add(todos);
  }

  dispose() {
    _todoFetcher.close();
    _countFetcher.close();
  }
}

final bloc = TodosBloc();
