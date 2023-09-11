import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:uni/view/Pages/home_page_view.dart';
import 'package:uni/view/Widgets/page_transition.dart';
import 'package:uni/view/Widgets/notifications_form.dart';

class NotificationsPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NotificationsPageViewState();
}

class NotificationsPageViewState extends GeneralPageViewState{

  @override
  Widget getBody(BuildContext context){

    return Container(
        margin:  EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child:  NotificationsForm()
    );

  }

}