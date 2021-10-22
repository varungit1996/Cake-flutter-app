import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(VaruMyApp());

class VaruMyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

//Creating a class user to store the data;
class User {
  final int id;
  final String userId;
  final String title;
  final String body;

  User({
    this.id,
    this.userId,
    this.title,
    this.body,
  });
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//Applying get request.

  Future<List<User>> getRequest() async {
    //replace your restFull API here.
    String url = "https://6661-103-165-167-242.ngrok.io/Laravel/Task1/public/api/list";
    final response = await http.get(url);
    print(">>>>>>>>>$response");

    var responseData = json.decode(response.body);

    //Creating a list to store input data;
    List<User> users = [];
    for (var singleUser in responseData) {
      User user = User(
          id: singleUser["id"],
          userId: singleUser["Name"],
          title: singleUser["Flavour"],
          body: singleUser["Bakeddate"]);

      //Adding user to the list.
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("The Cake House"),
           backgroundColor: Colors.deepOrange,
           centerTitle: true,
        ),
        body: Container(
           padding: EdgeInsets.all(12.0),
          child: FutureBuilder(
            future: getRequest(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                      child:
                    CircularProgressIndicator(),
                  ),
                );
              } else {
                return
                  ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (ctx, index) =>
                        TextData(id : snapshot.data[index].id,name: snapshot.data[index].userId, flavour : snapshot.data[index].title, date : snapshot.data[index].body),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

class TextData extends StatefulWidget {
  TextData({Key key,this.id,this.name,this.flavour,this.date}) : super(key: key);
  int id;
  String name;
  String flavour;
  String date;

  @override
  _TextDataState createState() => _TextDataState();
}

class _TextDataState extends State<TextData> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        child:
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .7,
                        child: Text(widget.name,style: TextStyle(color: Colors.deepOrangeAccent,fontSize: 27,fontWeight: FontWeight.w900),maxLines: 1,overflow:TextOverflow.visible,)
                    ),
                    Text("Flavour : "+ widget.flavour ,style: TextStyle(color: Colors.deepOrangeAccent,fontSize: 21,fontWeight: FontWeight.w600),),
                    Text("Mfg :" + widget.date,style: TextStyle(color: Colors.deepOrangeAccent,fontSize: 18,fontWeight: FontWeight.w600),),
                  ],
                 ),
                Image.network("https://www.pngfind.com/pngs/m/11-117230_free-png-download-birthday-cake-png-images-background.png",height: 75,)
              ],
            ),
            Divider(thickness: 0.5,color:Colors.deepPurple,),
          ],
        )
    );
  }
}
