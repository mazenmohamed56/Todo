import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_task/archivedTasks.dart';
import 'package:todo/modules/done_tasks/done_tasks.dart';
import 'package:todo/modules/home_page/homePage.dart';
import 'package:todo/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitAppState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [HomePage(), DoneTasks(), ArchivedTasks()];
  List<String> appBarTitle = ['Task', 'Done Tasks', 'Archiced Tasks'];
  int index = 0;

  void changeAppbarIndex(int selectedIndex) {
    index = selectedIndex;
    emit(ChangeBnbState());
  }

  Database db;
  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (db, version) {
      print('created');
      db
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, Title TEXT, time TEXT,date TEXT,status TEXT)')
          .then((value) => print('table Created '))
          .catchError((error) {
        print('DataBase Not created');
      });
    }, onOpen: (db) {
      getdata(db);
      print('DataBase open');
    }).then((value) {
      db = value;
      emit(CreateDataBaseState());
    });
  }

  insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await db.transaction((txn) {
      txn
          .rawInsert(
        'INSERT INTO tasks(Title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then((value) {
        print('$value inserted successfully');
        emit(InsertToDataBaseState());
        getdata(db);
      }).catchError((error) {
        print('Error When Inserting New Record ${error.toString()}');
      });

      return null;
    });
  }

  updateDate({@required String status, @required int id}) {
    db.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      emit(UpdateDataBaseState());
      getdata(db);
    });
  }

  delteData({@required int id}) {
    db.rawUpdate('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(DeleteFromDataBaseState());
      getdata(db);
    });
  }

  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivetasks = [];
  getdata(Database db) {
    newtasks = [];
    donetasks = [];
    archivetasks = [];
    db.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newtasks.add(element);
        } else if (element['status'] == 'done') {
          donetasks.add(element);
        } else {
          archivetasks.add(element);
        }
      });
      emit(GetDataBaseState());
    });
  }

  bool isShow = false;
  IconData floatIcon = Icons.edit;
  void changeBSheetstate({@required bool show, @required IconData icon}) {
    floatIcon = icon;
    isShow = show;
    emit(ChangeSheetState());
  }
}
