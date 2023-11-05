import 'package:flutter/material.dart';
import 'package:plant/InputData.dart';
import 'package:plant/ReadDat.dart';
import 'package:plant/cropspage.dart';
import 'package:plant/switchcontrol.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage()
      
    );
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/background_image.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 130),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.translate(
                        offset: Offset(0, -20),
                        child: Container(
                          child: Text(
                            "ARAS",
                            style: TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'PoetsenOne', 
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Transform.translate(
                    offset: Offset(0, -20),
                    child: Container(
                      child: Text(
                        "Automated Remote Agricultural System",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                           fontFamily: 'PoetsenOne',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                  ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return CropsPage();
                        }));
                  
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        )),
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 31, 93, 34))
                      ), 
                      child: Text("Login")
                      ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return CropsPage();
                        }));
                      }, 
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        )),
                       backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 31, 93, 34))
                      ),
                      child: Text("Register")
                      ),
                    ),
                ],
              ),
            ),
            
          ),
        ],
      ),
    );
  }
}
