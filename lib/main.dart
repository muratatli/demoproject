import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_spacex_demo/spaceX.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(SpaceXApp());
}

class SpaceXApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpaceX App Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: SpaceXHomePage(title: 'SpaceX Son Görev Bilgileri'),
    );
  }
}

class SpaceXHomePage extends StatefulWidget {
  SpaceXHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SpaceXHomePageState createState() => _SpaceXHomePageState();
}

class _SpaceXHomePageState extends State<SpaceXHomePage> {
  int _counter = 0;
  //SpaceX objSpaceX;
  
  Future<SpaceX> fromApi(String strApiUrl) async{

    var response = await http.get(strApiUrl);
    try {

      if (response.statusCode == 200) {

        return SpaceX.fromRawJson(response.body);

      } else {
        print('Request failed with status: ${response.statusCode}.');
      }

    } catch (e) {
      return null;
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: spaceXInfoWidget(),
    );
  }

  Widget spaceXInfoWidget() {
    return FutureBuilder(
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.none &&
            snapShot.hasData == null) {
          return Center(child: CircularProgressIndicator(),);
        }
        SpaceX project = snapShot.data;
        if(project?.name!=null) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Center(child: Text(project.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),
              FadeInImage.assetNetwork(
                placeholder: 'assets/images/placeholder-image.png',
                image: project.patch,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.75,
              ),
              Padding(padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(project.details,
                  style: TextStyle(
                      color: Colors.lightBlue[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 16),),
              ),
              SizedBox(height: 15,),
              RichText(
                  text: TextSpan(children: [ TextSpan(
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 14),
                    text: "© 2021, Murat Atlı tarafından AppNation için yapılmıştır.",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        launch("https://muratatli.com.tr");
                      },

                  )
                  ])),
            ],
          );
        }
        else{
          return Center(child: CircularProgressIndicator(),);
        }
      },
      future: fromApi('https://api.spacexdata.com/v4/launches/latest'),
    );
  }

}
