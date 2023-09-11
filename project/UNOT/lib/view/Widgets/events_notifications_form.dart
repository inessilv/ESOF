import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';

import '../../controller/local_storage/notifications_database.dart';
import 'notification_system.dart';

const Color _darkRed = Color.fromARGB(255, 0x75, 0x17, 0x1e);
const Color _mildWhite = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);

class EventsNotificationsForm extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return EventsNotificationsFormState();
  }
}

class EventsNotificationsFormState extends UnnamedPageView{

  final _timeInAdvanceController = TextEditingController();
  final _reminderController = TextEditingController();

  static final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    NotificationApi.init();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey, child: ListView(children: getFormWidget(context)));
  }

  List<Widget> getFormWidget(BuildContext context) {
    final List<Widget> formWidget = [];

    formWidget.add(eventsNotificationsTitle(context));
    formWidget.add(eventsNotificationsScroller(context));

    return formWidget;
  }

  Widget eventsNotificationsTitle(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: Column(
        children: <Widget>[
          Text(
            'Notificações',
            textScaleFactor: 1.6,
            textAlign: TextAlign.center,
          ),
          Text(
            'EVENTOS',
            textScaleFactor: 0.8,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget eventsNotificationsScroller(BuildContext context){
    NotificationsDatabase db = NotificationsDatabase();

    return Container(
        child: FutureBuilder(
            future: db.getAllEvents(),
            initialData :"Aguardando os dados...",
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Logger().e(snapshot.data);
                // All lectures are here inside snapshot.data

                return Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: _mildWhite,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Eventos', style: TextStyle(fontSize: 23, color: _darkRed)),
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        ),
                        ListBody(children: getContainerWidget(context, snapshot.data))
                      ],
                    )
                );
              } else {
                return Center(
                    child: Text(
                      "Falhou para requisitar os eventos",
                      style: TextStyle(fontSize: 20.0),
                    )
                );
              }
            }
        ));
  }

  List<Widget> getContainerWidget(BuildContext context, Map<String, dynamic> events_data){
    final List<Widget> events = [];

    int state = 1;

    for(int i = 0; i < events_data.length; i++){
      if (events_data[events_data.keys.elementAt(i)]["state"] == 0){
        state = 0;
        break;
      }
    }

    for(int i = 0; i < events_data.length; i++){
      events.add(getEvents(context,events_data.keys.elementAt(i), events_data[events_data.keys.elementAt(i)]));
    }

    return events;
  }

    Widget getEvents(BuildContext context, String eventId, Map<String, dynamic> complete_event_element){
    String _events = complete_event_element["title"];

    return Container(
      color: _mildWhite,
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(child: Text(_events, textScaleFactor: 1.2,)),
              Switch(
                value:  complete_event_element["state"] != 0, // If notification is enabled
                onChanged: (value) {
                  if(value == true){
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Preferências', textScaleFactor: 1.5),
                        content: Container(
                          width: 70,
                          height: 165,
                          margin: EdgeInsets.symmetric(vertical: 1.0),
                          child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: _timeInAdvanceController,
                                  key : const Key("tempoev"),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.access_alarms, color: _darkRed,),
                                    labelText: 'Antecedência',
                                    labelStyle: TextStyle(color: _darkRed, fontSize: 18),
                                  ),
                                ),
                                SizedBox(height: 30),
                                TextFormField(
                                  controller: _reminderController,
                                  key : const Key("evnota"),
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.assignment_late, color: _darkRed,),
                                    labelStyle: TextStyle(color: _darkRed, fontSize: 18),
                                    labelText: 'Nota',
                                  ),
                                ),
                              ]
                          ),
                        ),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  if (value){
                                    createNotifications(int.parse(eventId));
                                    complete_event_element["state"] = 1;
                                 }else{
                                    removeNotifications(int.parse(eventId));
                                    complete_event_element["state"] = 0;
                                 }
                                  Navigator.pop(context, 'Cancelar');
                                },
                                key : const Key("cancelarev"),
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  NotificationsDatabase db = NotificationsDatabase();
                                  var timeInAdvance = int.parse(_timeInAdvanceController.text);
                                  var reminder = _reminderController.text;

                                  db.updateSpecificEventNotification(
                                      int.parse(eventId), value, timeInAdvance,
                                      complete_event_element["title"], reminder);

                                  if (value){
                                    createNotifications(int.parse(eventId));
                                    complete_event_element["state"] = 1;
                                  }else{
                                    removeNotifications(int.parse(eventId));
                                    complete_event_element["state"] = 0;
                                  }

                                  Navigator.pop(context, 'Confirmar');
                                },
                                key : const Key("confirmarev"),
                                child: const Text('Confirmar'),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }
                  setState(() {
                    NotificationsDatabase db = NotificationsDatabase();

                    db.updateSpecificEventNotification(
                        int.parse(eventId), value, complete_event_element["minutesBefore"],
                        complete_event_element["title"], complete_event_element["description"]);
                  });
                },
                key : Key('key_$_events'),
                activeTrackColor: _darkRed,
                activeColor: _mildWhite,
              ),
            ],
          )
        ],
      ),
    );


  }


  void createNotifications(int eventId) async{
    NotificationsDatabase db = NotificationsDatabase();
    List<Map<String, dynamic>> notifications = await db.getAllNotificationsForEventId(eventId);

    for (Map<String, dynamic> eventNotification in notifications ) {
      //var dateTime1 = DateTime.parse(eventNotification["dateOfNotification"] + 'T' + '08:00');
      //dateTime1 = dateTime1.subtract( Duration(minutes: eventNotification["minutesBefore"] ));
      var dateTime1 = DateTime.parse('2022-06-10T03:50');
      dateTime1 = dateTime1.subtract( Duration(minutes: eventNotification["minutesBefore"] ));
      NotificationApi.showNotification(id : eventNotification['notificationId'],
          title:eventNotification['title'] ,
          body :eventNotification['description'],
          date : dateTime1);

    }

  }

  void removeNotifications(int eventId) async {
    NotificationsDatabase db = NotificationsDatabase();
    List<Map<String, dynamic>> notifications = await db.getAllNotificationsForEventId(eventId);

    for (Map<String, dynamic> eventsNotification in notifications) {
      NotificationApi.cancelNotification(eventsNotification['notificationId']);
    }
  }

}