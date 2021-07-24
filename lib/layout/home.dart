import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class Home extends StatelessWidget {
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..createDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text('${cubit.appBarTitle[cubit.index]}'),
                titleSpacing: 20.0,
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.index,
                onTap: (selectedIndex) {
                  cubit.changeAppbarIndex(selectedIndex);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.archive_outlined,
                    ),
                    label: 'Archived',
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: 'AddTask',
                child: Icon(cubit.floatIcon),
                onPressed: () {
                  if (cubit.isShow) {
                    if (formKey.currentState.validate()) {
                      cubit
                          .insertToDatabase(
                              date: dateController.text,
                              title: titleController.text,
                              time: timeController.text)
                          .then((value) {
                        Navigator.pop(context);
                        cubit.changeBSheetstate(show: false, icon: Icons.edit);
                      });
                    }
                  } else {
                    scaffoldKey.currentState
                        .showBottomSheet((context) => Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(
                              20.0,
                            ),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                    type: TextInputType.text,
                                    label: 'Task Title',
                                    prefix: Icons.title,
                                    controller: titleController,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'Title must not be empty';
                                      }

                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: defaultFormField(
                                          isClickable: false,
                                          type: TextInputType.text,
                                          label: 'Task Time',
                                          prefix: Icons.watch_later_outlined,
                                          controller: timeController,
                                          validate: (String value) {
                                            if (value.isEmpty) {
                                              return 'Time must not be empty';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      FloatingActionButton(
                                        heroTag: 'addTime',
                                        onPressed: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) => timeController
                                                  .text =
                                              value.format(context).toString());
                                        },
                                        mini: true,
                                        child: Icon(Icons.edit),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: defaultFormField(
                                          isClickable: false,
                                          type: TextInputType.text,
                                          label: 'Task Date',
                                          prefix: Icons.calendar_today_outlined,
                                          controller: dateController,
                                          validate: (String value) {
                                            if (value.isEmpty) {
                                              return 'Date must not be empty';
                                            }

                                            return null;
                                          },
                                        ),
                                      ),
                                      FloatingActionButton(
                                        heroTag: 'addDate',
                                        onPressed: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(2050))
                                              .then((value) =>
                                                  dateController.text =
                                                      DateFormat.yMMMd()
                                                          .format(value));
                                        },
                                        mini: true,
                                        child: Icon(Icons.edit),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )))
                        .closed
                        .then((value) {
                      cubit.changeBSheetstate(show: false, icon: Icons.edit);
                    });
                    cubit.changeBSheetstate(show: true, icon: Icons.add);
                  }
                },
              ),
              body: ConditionalBuilder(
                builder: (context) => cubit.screens[cubit.index],
                condition: true,
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            );
          },
        ));
  }
}
