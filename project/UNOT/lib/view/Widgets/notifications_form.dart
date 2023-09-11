import 'package:flutter/cupertino.dart';
import 'package:uni/view/Pages/classes_notifications_page_view.dart';
import 'package:uni/view/Pages/exams_notifications_page_view.dart';
import 'package:uni/view/Pages/events_notifications_page_view.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/page_transition.dart';

import '../../model/entities/notifications_pdf.dart';

const Color _darkRed = Color.fromARGB(255, 0x75, 0x17, 0x1e);
const Color _mildWhite = Color.fromARGB(255, 0xfa, 0xfa, 0xfa);

class NotificationsForm extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return NotificationsFormState();
  }
}

class NotificationsFormState extends GeneralPageViewState{

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey, child: ListView(children: getFormWidget(context)));
  }

  List<Widget> getFormWidget(BuildContext context) {
    final List<Widget> formWidget = [];

    formWidget.add(notificationsTitle(context));
    formWidget.add(aulasButton(context));
    formWidget.add(examesButton(context));
    formWidget.add(eventosButton(context));
    formWidget.add(exportarButton(context));

    return formWidget;
  }

  Widget notificationsTitle(BuildContext context) {
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
              'GERAL',
              textScaleFactor: 0.8,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
    );
  }

  Widget aulasButton(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height / 11)),  // Posição vertical que influencia os pŕoximos botões
        margin: EdgeInsets.symmetric(vertical: 11.0),
        child: ElevatedButton(
          onPressed: (){
            //action code for button 1
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClassesNotificationsPageView()),
            );
          },
          style: ElevatedButton.styleFrom(fixedSize: const Size(300,60),
              primary: _mildWhite),
          key: const Key('Aulas'),
          child: Text("Aulas                                   ▶",
            style: TextStyle(fontSize: 19, color: _darkRed),),
        )
    );
  }

  Widget examesButton(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 11.0),
        child: ElevatedButton(
          onPressed: (){
            //action code for button 2
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExamsNotificationsPageView()),
            );
          },
          style: ElevatedButton.styleFrom(fixedSize: const Size(300,60),
              primary: _mildWhite),
          key: const Key('Exames'),
          child: Text("Exames                                ▶",
            style: TextStyle(fontSize: 19, color: _darkRed),),
        )
    );
  }

  Widget eventosButton(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 11.0),
        child: ElevatedButton(
          onPressed: (){
            //action code for button 3
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventsNotificationsPageView()),
            );
          },
          style: ElevatedButton.styleFrom(fixedSize: const Size(300,60),
              primary: _mildWhite),
          key: const Key('Eventos'),
          child: Text("Eventos                                ▶",
            style: TextStyle(fontSize: 19, color: _darkRed),),
        )
    );
  }

  Widget exportarButton(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
        margin: EdgeInsets.symmetric(vertical: 11.0),
        child: ElevatedButton(
            key:const Key("pdf") ,
          onPressed: () async {
            //action code for button 4
            await getNotificationsPdf();
          },
          style: ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.of(context).size.width,60),
              primary: _darkRed),
          child: Text("Exportar como PDF",
            style: TextStyle(fontSize: 19, color: _mildWhite),),
        )
    );
  }


}