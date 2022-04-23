
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/repositories/todo_repository.dart';
import 'package:todolist/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({ Key? key }) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = new TextEditingController();
  final TodoRespository todoRespository = new TodoRespository();

  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;

  @override
  void initState(){
    super.initState();

    todoRespository.getTodoList().then((value) => {
      setState(() =>{todos = value })
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children:  <Widget> [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: todoController,
                          decoration: const InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Adicione uma tarefa',
                            hintText: 'Ex. Estudar Flutter',
                          ),
                        ),
                        
                      ),
                      const SizedBox(width: 8,),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (){
                            setState(() {
                              Todo newTodo = Todo(
                                  title: todoController.text,
                                  dateTime: DateTime.now()
                                  );
                              todos.add(newTodo);
                            });
                            todoController.clear();
                            todoRespository.saveTodoList(todos);
                          },
                          style: ElevatedButton.styleFrom(
                            primary :const Color(0xff00d7f3),
                            padding:const EdgeInsets.all(17)
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 30,
                            )
                        ),
                      ),
                    
                  ],
                ),
                const SizedBox(height: 16,),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children:[
                      for (var todo in todos)
                        TodoListItem(
                          todo:todo,
                          onDelete: onDelete
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16,),
                Row(
                  children: <Widget> [
                    Expanded(
                      child: Text('Você possui ${todos.length} tarefas pendentes'),
                      ),
                    const SizedBox(width: 8,),
                    ElevatedButton(
                      child: Text('Limpar tudo'),
                      onPressed: () {
                        showDeleteTodosDialog();
                      },
                      style: ElevatedButton.styleFrom(
                            primary : Color(0xff00d7f3),
                            padding: EdgeInsets.all(17)
                        ),
                      ),
                  ],
                )
              ],
            )
            
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo){
    
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
      todoRespository.saveTodoList(todos);

    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            'Tarefa ${todo.title} foi removida com sucesso.',
            style: TextStyle(
              color: Color(0xff060708)
            ),),
            backgroundColor: Colors.white70,
            action: SnackBarAction(
              label: 'Desfazer',
              textColor: const Color(0xff00d7f3),
              onPressed: () {
                setState(() {
                  todos.insert(deletedTodoPos!, deletedTodo!);
                  todoRespository.saveTodoList(todos);
                });
              }
              ),
            duration: const Duration(seconds: 5),
        )
      );
  }


  void showDeleteTodosDialog(){
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Limpar tudo?'),
          content: const Text('Você tem certeza que deseja apagar todas as tarefas?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(primary: Color(0xff00d7f3)),
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancelar'),
            ),
            TextButton(
              style: TextButton.styleFrom(primary: Colors.red),
              onPressed: () => {
                  Navigator.of(context).pop(),
                  deleteTodos()
                },
              child: const Text('Limpar Tudo'),
            ),
          ],
        ),
    );
  }

  void deleteTodos(){
    setState(() {
      todos.clear();
    });
    todoRespository.saveTodoList(todos);

  }

}