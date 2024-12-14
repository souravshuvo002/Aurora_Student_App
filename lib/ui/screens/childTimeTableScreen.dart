import 'package:aurora_student/cubits/timeTableCubit.dart';
import 'package:aurora_student/data/repositories/studentRepository.dart';
import 'package:aurora_student/ui/widgets/timetableContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildTimeTableScreen extends StatelessWidget {
  final int childId;
  const ChildTimeTableScreen({Key? key, required this.childId})
      : super(key: key);

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => BlocProvider<TimeTableCubit>(
              create: (context) => TimeTableCubit(StudentRepository()),
              child:
                  ChildTimeTableScreen(childId: routeSettings.arguments as int),
            ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TimeTableContainer(
        childId: childId,
      ),
    );
  }
}
