import 'package:flutter/material.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Pages/notifications_page_view.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/classes_notifications_form.dart';

class ClassesNotificationsPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ClassesNotificationsPageViewState();
}

class ClassesNotificationsPageViewState extends UnnamedPageView{

  @override
  Widget getBody(BuildContext context){

    return Container(
        margin:  EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child:  ClassesNotificationsForm()
    );

  }

}