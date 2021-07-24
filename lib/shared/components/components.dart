import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  Function onTap,
  bool isPassword = false,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  Function suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );
Widget taskListItem({@required Map item, @required context}) => Dismissible(
      key: Key(item['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).delteData(id: item['id']);
      },
      child: Padding(
        padding:
            const EdgeInsetsDirectional.only(start: 20, top: 10, bottom: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blueAccent,
              child: Text(
                item['time'],
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['Title'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item['date'],
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  )
                ],
              ),
            ),
            IconButton(
                icon: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
                onPressed: () {
                  AppCubit.get(context)
                      .updateDate(status: 'done', id: item['id']);
                }),
            IconButton(
                icon: Icon(
                  Icons.archive_outlined,
                  color: Colors.black54,
                ),
                onPressed: () {
                  AppCubit.get(context)
                      .updateDate(status: 'archive', id: item['id']);
                }),
          ],
        ),
      ),
    );
Widget tasksBuilder({@required List<Map> tasks}) => ConditionalBuilder(
      builder: (BuildContext context) => ListView.separated(
          itemBuilder: (context, index) =>
              taskListItem(item: tasks[index], context: context),
          separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsetsDirectional.only(start: 20.0),
                child: Container(
                    width: double.infinity, height: 1, color: Colors.grey[300]),
              ),
          itemCount: tasks.length),
      condition: tasks.length > 0,
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              color: Colors.grey,
              size: 100,
            ),
            Text(
              'No Tasks Found yet, Pleas Add Some ',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            )
          ],
        ),
      ),
    );
