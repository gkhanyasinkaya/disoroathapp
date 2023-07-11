import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gokhan/Pages/HomePage.dart';
import 'package:gokhan/Pages/LoginPage.dart';
import 'package:gokhan/Entity/Message.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}



class _RegisterPageState extends State<RegisterPage> {



  FirebaseFirestore fire = FirebaseFirestore.instance;
  Future<void> addEntity(String name, String value, String avatarUrl, String smoke, String age) async {
    DocumentReference docRef = FirebaseFirestore.instance.collection("User").doc();

    await docRef.set({
      'id': docRef.id,
      'name': name,
      'gender': value=="1" ? "F" : value=="2"? "M":"MB",
      'avatarUrl': avatarUrl,
      'smoke': smoke,
      'age': age,
    }).then((_) {
      print('Belge eklendi: ${docRef.id}');
    }).catchError((error) {
      print('Belge ekleme işlemi başarısız oldu: $error');
    });


  }

  var nameSurnameCont=TextEditingController();
  var ageController =TextEditingController();
  bool _isChecked = false;
  var sexValue=0 ;
  var width;

  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body:
      SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding:  EdgeInsets.only(top: width/7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top:0.0),
                    child: Image.asset(
                      'images/Logo.png',
                      width: width/1.5,
                      height: width/1.5,
                      scale: 1,
                      alignment: Alignment.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom:width/25,
                        left: width/15,
                        right:width/15),
                    child: TextFormField(

                      controller: nameSurnameCont,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: width/45),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 4, color: Colors.red),
                            borderRadius: BorderRadius.circular(8.0)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 4, color: Colors.red),
                            borderRadius: BorderRadius.circular(8.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 4, color: Colors.black87),
                            borderRadius: BorderRadius.circular(8.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 4, color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(8.0)),
                        label: Text(
                          "Profile Name",
                          style: TextStyle(fontSize: width/20),
                        ),
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        Message msg = Message();
                        if (value!.isEmpty) {
                          msg.message = "Profile name cannot be left empty.";
                          msg.isCorrect = false;
                          return msg.message;
                        }
                        msg.isCorrect = true;
                        return null;
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                        bottom:width/25,
                        left: width/15,
                        right:width/15),
                    child: TextFormField(

                      controller: ageController,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: width/45),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 4, color: Colors.red),
                            borderRadius: BorderRadius.circular(8.0)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 4, color: Colors.red,),

                            borderRadius: BorderRadius.circular(8.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 4, color: Colors.black87),
                            borderRadius: BorderRadius.circular(8.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 4, color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(8.0)),
                        label: Text(
                          "Age",
                          style: TextStyle(fontSize: width/20),
                        ),
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        Message msg = Message();
                        if (value!.isEmpty) {
                          msg.message = "Age cannot be left empty.";
                          msg.isCorrect = false;
                          return msg.message;
                        }
                        if(!value.contains(RegExp(r"[0123456789]"))){
                          msg.message = "Invalid format for age, please enter a valid one.";
                          msg.isCorrect = false;
                          return msg.message;
                        }

                        if(value.contains(RegExp(r"[a-zA-Z]"))){
                          msg.message = "Invalid format for age, please enter a valid one.";
                          msg.isCorrect = false;
                          return msg.message;
                        }
                        msg.isCorrect = true;
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: width/12,bottom:width/30),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Do you smoke?",
                            style: TextStyle(
                              fontSize: width/30,
                            ),
                          ),
                          Checkbox(value: _isChecked,
                            onChanged: (chacked){
                              setState(() {
                                _isChecked=chacked!;
                                //print(_isChecked);
                              });
                            },),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding:  EdgeInsets.only(left: width/12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Gender:",
                          style: TextStyle(
                            fontSize: width/30,
                          ),
                        ),
                      ],
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.only(left: width/15 ,right:width/15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(child:RadioListTile<int>(title: Text("F" ,style: TextStyle(fontSize: width/30),),value: 1, groupValue: sexValue, onChanged: (int ? veri){
                          setState(() {
                            sexValue=veri!;
                          });
                        }),
                        ),
                        Flexible(child:RadioListTile(title: Text("M",style: TextStyle(fontSize: width/30)),value: 2, groupValue: sexValue, onChanged: (int ? veri){
                          setState(() {
                            sexValue=veri!;
                          });
                        }),
                        ),
                        Flexible(child:RadioListTile(title: Text("NB",style: TextStyle(fontSize: width/30)),value: 3, groupValue: sexValue, onChanged: (int ? veri){
                          setState(() {
                            sexValue=veri!;
                          });
                        }),
                        )
                      ],

                    ),
                  ),

                  Center(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(vertical:width/30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(top:width/20),
                            child: SizedBox(
                              width: width/4,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurpleAccent, // Background color
                                  onPrimary: Colors.black,// Text Color (Foreground color)
                                ),
                                onPressed: () {

                                  setState(() {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                                  });


                                },
                                child: Text('Back',style: TextStyle(fontSize: width/35)),
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(top:width/20,left: width/5),
                            child: SizedBox(
                              width: width/4,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurpleAccent, // Background color
                                  onPrimary: Colors.black,
                                  // Text Color (Foreground color)
                                ),
                                onPressed: () {

                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      addEntity(nameSurnameCont.text, this.sexValue.toString(), " ", _isChecked.toString(), ageController.text).then((value) => {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()))
                                      });
                                    });


                                  }
                                },
                                child: Text('Submit',style: TextStyle(fontSize: width/35)),
                              ),
                            ),
                          ),
                        ],

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}


