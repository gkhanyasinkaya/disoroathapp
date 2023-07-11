
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:gokhan/Pages/HomePage.dart';
import 'package:gokhan/Pages/RegisterPage.dart';
import 'package:image_picker/image_picker.dart';

import '../Entity/User.dart';

class LoginPage extends StatefulWidget {
   LoginPage({Key? key}) : super(key: key);
  static User ? user;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var nameCont= TextEditingController();
  var imageCont= TextEditingController();
  late List<User> users = [];


  final List<Color> _colors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.deepOrangeAccent,
    Colors.deepPurpleAccent,
    Colors.purple,
    Colors.red,
    Colors.blueGrey,
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,

  ];



  Future<List<User>> getEntity() async {
    late List<User> users = [];
    users.clear();
    await FirebaseFirestore.instance
        .collection("User")
        .get()
        .then((QuerySnapshot q) {
      for (var document in q.docs) {

        users.add(User(
            name: document["name"],
            id: document["id"],
            age: document["age"],
            gender: document["gender"],
            avatarUrl: document["avatarUrl"].toString(),
            smoke: document["smoke"] ));
      }
    });
    return users;
  }



  Future<void> updateDocument(String userId, String updatedValue) async {
    CollectionReference collectionRef = FirebaseFirestore.instance.collection("User");
    DocumentReference documentRef = collectionRef.doc(userId);

    await documentRef.update({
      'avatarUrl': updatedValue,
    }).then((_) {
      print("Belge güncellendi: ${documentRef.id}");
    }).catchError((error) {
      print("Belge güncelleme işlemi başarısız oldu: $error");
    });
  }


  Future<void>  deleteUser(User user) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("User").doc(user.id);

    await documentReference.delete().then((value) {
      print('Veri silindi.');
    }).catchError((error) {
      print('Silme işlemi başarısız oldu: $error');
    });


  }



  @override
  void initState() {
    getEntity().then((value) async =>  users= await value);
  }
  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.shortestSide;
    return  Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Image.asset(
              'images/Logo.png',
              alignment: Alignment.center,
              scale: 1,
            ),
          ),
          Flexible(
            child: FutureBuilder<List<User>>(
                future: getEntity(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {

                    return Center(child: Column(
                      children: [
                        Text('Veriler alınamadı'),
                        ElevatedButton(onPressed: (){
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                          });
                        }, child: Text("Register"))
                      ],
                    ));
                  }
                  else if (snapshot.data == null) {
                    return   GestureDetector(
                        child: Container(
                          width: width/5,
                          height: width/5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add),
                              SizedBox(height: width/50),
                              Text(
                                "Add user",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: (){
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                          });
                        }
                    );
                  }
                  else {
                    users = snapshot.data!;

                    return  Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            itemCount: snapshot.data!.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.0,
                            ),
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {

                              final Color color = _colors[index];

                              return GestureDetector(
                                onTap: (){
                                  LoginPage.user=users[index];
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
                                },
                                onLongPress: (){
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          title: Text('Do you want to delete the user?'),
                                          content:Form(
                                            child:ElevatedButton(child:Text("Delete"),onPressed: (){
                                              setState(() {
                                                deleteUser(users[index]);
                                                Navigator.pop(context);
                                              });

                                            }) ,
                                          )
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                  padding:  EdgeInsets.all(8),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border:Border.all(width:2),
                                          ),
                                          child:
                                          Image.asset( "images/img_$index.png",
                                            width: width/3.5,
                                            height: width/3.5,
                                            fit: BoxFit.fill,)


                                        ),

                                        /*
                                        Container(
                                          decoration: BoxDecoration(
                                            border:Border.all(width:2),
                                          ),
                                          child: GestureDetector(
                                            onLongPress: (){
                                              setState(() {
                                                _pickImageFromGallery().then((value) =>
                                                    updateDocument(  users[index].id, value.toString()));
                                              });
                                              },
                                            child:
                                          users[index].avatarUrl.replaceAll("'", "") ==null ?
                                            Image.file(  File(users[index].avatarUrl.replaceAll("'", "")),
                                              width: width,
                                              height: width/2,
                                              fit: BoxFit.fill,):

                                            Icon(Icons.error_outline_rounded,size: 25,)

                                          ),
                                            
                                        ),*/
                                        SizedBox(height:width/25),
                                        Text(
                                          users[index].name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: width/25,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                              );
                            },
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical: width/50),
                          child: GestureDetector(
                              child: Container(
                                width: width/5,
                                height: width/5,

                                decoration: BoxDecoration(
                                  color:Colors.deepPurpleAccent,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center ,
                                  children: [
                                    Icon(Icons.add,color: Colors.white,size: 35,),

                                  ],
                                ),
                              ),
                              onTap: (){
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));
                                });
                              }
                          ),
                        ),
                      ],
                    );

                  }
                }
            ),
          ),

        ],
      ),
    );



  }

  Future<File> _pickImageFromGallery() async {
    late File imageFile;
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        imageFile = File(pickedImage.path);
      }
    });
    return imageFile;
  }
}
