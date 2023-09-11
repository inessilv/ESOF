import 'package:flutter/material.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/exams_notifications_form.dart';


class ExamsNotificationsPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExamsNotificationsPageViewState();
}

class ExamsNotificationsPageViewState extends UnnamedPageView{

  @override
  Widget getBody(BuildContext context){

    return Container(
        margin:  EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child:  ExamsNotificationsForm()
    );

  }

}