import 'package:flutter/material.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/events_notifications_form.dart';


class EventsNotificationsPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EventsNotificationsPageViewState();
}

class EventsNotificationsPageViewState extends UnnamedPageView{

  @override
  Widget getBody(BuildContext context){

    return Container(
        margin:  EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child:  EventsNotificationsForm()
    );

  }

}