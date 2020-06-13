import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
void main()=>runApp(
  MaterialApp(
    title:"fit",
    home:MainScreen(),
  )
);

class MainScreen  extends StatefulWidget {
  @override
  MainScreen_State createState() => MainScreen_State();
}

class MainScreen_State extends State<MainScreen> {
  DateTime alarmDate;
 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
 @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (Timer t) => checkForAlarm());
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher'); 
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
Future _showNotificationWithDefaultSound() async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'Reminder',
    'Its time for medicine:)',
    platformChannelSpecifics,
    payload: 'Default_Sound',
  );
}
  
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
    return SafeArea(
      top:true,
      child:Container(
      height: size.height,
      width: size.width,
      color: Colors.blue[50],
      child: new Stack(
        children:[
          new Positioned(
            
            child:SizedBox(width: size.width,
            height: size.height/3,
            child: new DecoratedBox(decoration: 
            const BoxDecoration(color: Colors.blue)),)
          ),
          new Positioned(
            top: size.height/4,
            bottom: size.height/7,
            left: size.width/8,
            right: size.width/8,
            child: Container(
              child: Card(
                elevation: 10,
                child:new Container(
                  margin: const EdgeInsets.only(top:60.0,bottom: 10.0,left: 10.0,right: 10.0),
                  alignment: Alignment.topCenter,
                  //color: Colors.orange,
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:<Widget>[
                      new Row(
                        
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children:<Widget> [
                          new Container(
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:<Widget>[
                                Container(
                                  height:50,
                                  width:50,
                                  decoration: BoxDecoration(
                                    image:DecorationImage(image: AssetImage("assets/image/heatbeat.gif"),fit:BoxFit.fill)
                                  ),
                                ),
                                Text( "73 BPM",style: TextStyle(fontSize:26,color:Colors.grey),),
                              ]
                            ),
                            height:100,
                            width:150,
                            
                          ),
                          new Container(
                            height: 100,
                            width:150,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                  height:50,
                                  width:50,
                                  decoration: BoxDecoration(
                                    image:DecorationImage(image: AssetImage("assets/image/bodyTemp.jpg"),fit: BoxFit.fill)
                                  ),
                                ),
                                Text("26 C",style: TextStyle(fontSize:26,color:Colors.grey),),
                              ],
                            ),
                          )

                        ],
                      ),
                      SizedBox(height:35),
                      new Row(mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap:(){},
                          child:new Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(shape:BoxShape.rectangle,
                            color: Colors.pink,
                            borderRadius:BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color:Colors.grey,blurRadius:10)]),
                            child: Text("LOCATE",style: TextStyle(fontWeight:FontWeight.bold,color:Colors.white),),
                            
                          )
                        )
                      ],)
                     // 
                      //
                    ]
                  )
                )

              ),
            ),
          ),
          new Positioned(
            top:size.height/4-50,
            left: size.width/2-50,
            child:Container(
              decoration: new BoxDecoration(shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage("assets/image/profile.jpg"),fit:BoxFit.cover),
              boxShadow: [BoxShadow(color:Colors.grey,blurRadius:5)]
                                ),
                                height:100,
              width:100,
            )
          ),

          new Positioned(
            top: size.height/1.26,
            left: size.width/1.5,
              child:new Container(
                height:60,
                width:60,
                decoration:BoxDecoration(shape: BoxShape.circle,
                color:Colors.blue[50],
                boxShadow:[BoxShadow(blurRadius: 10,color:Colors.grey)]),
                child:FlatButton(onPressed: (){
                   DatePicker.showTime12hPicker(context,
                              showTitleActions: true,
                               onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            //_showNotificationWithDefaultSound();
                            setState(() {
                              alarmDate = date;
                            });
                            print('confirm $date');
                            print(DateTime.now());
                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                }, child: Icon(Icons.alarm_add,color: Colors.blue[800],))
              )
            )
          
          
          
        ]
      ),
      
    )
    );
    
  }

    Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }
  Future checkForAlarm() async{
     // final difference  = DateTime.now().difference(alarmDate).inSeconds;
      final hour = DateTime.now().hour;
      final minute = DateTime.now().minute;
      final second  = DateTime.now().second;
      final alarmHour = alarmDate.hour;
      final alarmMinute = alarmDate.minute;
     if(hour == alarmHour){
       if(minute == alarmMinute && second == 0){
         _showNotificationWithDefaultSound();
       }
     }
     else{
       print("time not reached");
     }
  }
 
}
