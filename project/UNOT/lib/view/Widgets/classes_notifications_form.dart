import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/notification_system.dart';
import 'package:uni/model/entities/classes_notifications.dart';
import 'package:intl/intl.dart';
import '../../controller/local_storage/notifications_database.dart';
import '../../model/entities/lectureNotification.dart';



const Color _darkRed = Color.fromARGB(255, 0x75, 0x17, 0x1e);
const Color _mildWhite = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);

class ClassesNotificationsForm extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return ClassesNotificationsFormState({
    });

  }
}

class ClassesNotificationsFormState extends UnnamedPageView{
  Map<String,bool> listClasses;

  final _timeInAdvanceController = TextEditingController();
  final _reminderController = TextEditingController();

  ClassesNotificationsFormState(Map<String,bool> t){
    this.listClasses = t;
  }

  List<Classes> classes = [];
  Map notifications = Map<int, Classes>();

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

    formWidget.add(classesNotificationsTitle(context));

    // This is the list of classes
    formWidget.add(classesNotificationsScroller(context));

    return formWidget;
  }

  Widget classesNotificationsTitle(BuildContext context) {
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
            'AULAS',
            textScaleFactor: 0.8,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget classesNotificationsScroller(BuildContext context){

    NotificationsDatabase db = NotificationsDatabase();

  return Container(
          child: FutureBuilder(
              future: db.getAllLectures(),
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
                            child: Text('Aulas', style: TextStyle(fontSize: 23, color: _darkRed)),
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          ),
                          ListBody(children: getContainerWidget(context, snapshot.data))
                        ],
                      )
                  );
                } else {
                  return Center(
                    child: Text(
                       "Falhou para requisitar as aulas",
                       style: TextStyle(fontSize: 20.0),
                    )
                  );
                }
    }
    ));
  }

  List<Widget> getContainerWidget(BuildContext context, Map<String, dynamic> lectures_data){
    final List<Widget> classes = [];

    int state = 1;

    for(int i = 0; i < lectures_data.length; i++){
      if (lectures_data[lectures_data.keys.elementAt(i)]["state"] == 0){
        state = 0;
        break;
      }
    }

    for(int i = 0; i < lectures_data.length; i++){
      classes.add(getClasses(context,lectures_data.keys.elementAt(i), lectures_data[lectures_data.keys.elementAt(i)]));
    }

    return classes;

  }

  Widget getClasses(BuildContext context, String lectureId, Map<String, dynamic> complete_class_element){

    String _class = '';
    _class = complete_class_element["title"] + " (" + complete_class_element["type"] +")"
        + " - " + complete_class_element["weekday"];

    return Container(
      color: _mildWhite,
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(child: Text(_class, textScaleFactor: 1.2,)),
              Switch(
                value: complete_class_element["state"] != 0, // If notification is enabled
                onChanged: (value) {
                  if(value == true ){
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
                                  keyboardType: TextInputType.number,
                                  key : const Key("tempoaula"),
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.access_alarms, color: _darkRed,),
                                    labelText: 'Antecedência',
                                    labelStyle: TextStyle(color: _darkRed, fontSize: 18),
                                  ),
                                ),
                                SizedBox(height: 30),
                                TextFormField(
                                  controller: _reminderController,
                                  key : const Key("aulanota"),
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.assignment_late, color: _darkRed,),
                                    labelText: 'Nota',
                                    labelStyle: TextStyle(color: _darkRed, fontSize: 18),
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
                                      createNotifications(int.parse(lectureId));
                                      complete_class_element["state"] = 1;
                                    }else{
                                      removeNotifications(int.parse(lectureId));
                                      complete_class_element["state"] = 0;
                                    }

                                  Navigator.pop(context, 'Cancelar');
                                },
                                key : const Key("cancelarau"),
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: ()  {
                                  NotificationsDatabase db = NotificationsDatabase();
                                  var timeInAdvance = int.parse(_timeInAdvanceController.text);
                                  var reminder = _reminderController.text;

                                  db.updateSpecificLectureNotification(
                                      int.parse(lectureId), value, timeInAdvance,
                                      complete_class_element["title"], reminder);

                                    if (value){
                                      createNotifications(int.parse(lectureId));
                                      complete_class_element["state"] = 1;

                                    }else{
                                      removeNotifications(int.parse(lectureId));
                                      complete_class_element["state"] = 0;
                                    }

                                  Navigator.pop(context, 'Confirmar');
                                },
                                key : const Key("confirmarau"),
                              child: const Text('Confirmar'),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }

                  setState(()  {
                    NotificationsDatabase db = NotificationsDatabase();

                      db.updateSpecificLectureNotification(
                          int.parse(lectureId), value,complete_class_element["minutesBefore"],
                          complete_class_element["title"], complete_class_element["description"]);

                  });
                  },
                key : Key('key_$_class'),
                activeTrackColor: _darkRed,
                activeColor: _mildWhite,
              ),
            ],
          )
        ],
      ),
    );


  }


  void createNotifications(int lectureId) async{
    NotificationsDatabase db = NotificationsDatabase();
    List<Map<String, dynamic>> notifications = await db.getAllNotificationsForLectureId(lectureId);

    for (Map<String, dynamic> classNotification in notifications ) {
      //var dmyString = classNotification['dateOfNotification'];
      //var dateTime1 = DateTime.parse(dmyString + 'T' + classNotification["hourOfNotification"] + ":" + classNotification["minuteOfNotification"]);
      var dateTime1 = DateTime.parse('2022-06-10T03:50');
      dateTime1 = dateTime1.subtract( Duration(minutes: classNotification["minutesBefore"] ));
      NotificationApi.showNotification(id : classNotification['notificationId'],
                                            title:classNotification['title'] ,
                                            body :classNotification['description'],
                                            date : dateTime1);

    }

  }

  void removeNotifications(int lectureId) async {
    NotificationsDatabase db = NotificationsDatabase();
    List<Map<String, dynamic>> notifications = await db.getAllNotificationsForLectureId(lectureId);

    for (Map<String, dynamic> classNotification in notifications) {
      NotificationApi.cancelNotification(classNotification['notificationId']);
    }
  }
}