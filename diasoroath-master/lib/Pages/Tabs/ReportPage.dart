
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gokhan/Entity/Report.dart';
import 'package:gokhan/Pages/LoginPage.dart';
import 'package:gokhan/Pages/ReportPageDetail.dart';




class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  CollectionReference userCollectionRef = FirebaseFirestore.instance.collection("User");

  Future<List<Report>> getEntity() async {

    DocumentReference userDocRef = userCollectionRef.doc(LoginPage.user!.id);
    CollectionReference reportsCollectionRef = userDocRef.collection('Reports');

    QuerySnapshot querySnapshot = await reportsCollectionRef.get();

    List<Report> reports = [];

    querySnapshot.docs.forEach((doc) {
      reports.add(Report(
        id: doc["id"] ,
        reportDetail: doc["reportDetail"],
        ImagePath: doc["ImagePath"],
        userId: doc["userId"],
      ));
    });
    return reports;
  }
  Future<void> deleteEntity(String reportId) async {// getEntity() fonksiyonundan verileri al

    DocumentReference reportDocRef =  await userCollectionRef.doc(LoginPage.user!.id)
        .collection('Reports').doc(reportId);

    await reportDocRef.delete().then((value) {
      print('Veri silindi.');
    }).catchError((error) {
      print('Silme işlemi başarısız oldu: $error');
    });
  }



  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return FutureBuilder<List<Report>>(builder: (context, snapshot)  {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        print("1");
        return Center(child: Column(
          children: [
            Text('Veriler alınamadı'),
          ],
        ));
      }
      else if (snapshot.data ==null) {
        print("2");
        return Center(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Veriler alınamadı'),
          ],
        ));
      }
      else{
        return
          snapshot.data!.length >0 ?
          ListView.builder(
            padding:  EdgeInsets.only(top: 8),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              File file= File(snapshot.data![index].ImagePath.replaceAll("'", ""));


              return  GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportPageDetail(snapshot.data![index])));
                },
                onLongPress: () async{
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text('Do you want to delete this report'),
                            content:Form(
                              child:ElevatedButton(child:Text("Yes") ,style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.redAccent, )),onPressed: () async{
                                setState(()  {
                                  deleteEntity(snapshot.data![index].id).then((value) {
                                 }
                                  );
                                  Navigator.pop(context);
                                });

                              }) ,
                            )
                        );
                      },
                    );
                  });

                },
                child: Container(
                  height: 100,
                  width: width,
                  child: Padding(
                    padding:  EdgeInsets.only(bottom: 15.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(child: Image.file(file,width:width/5 ,height: width/5,fit:  BoxFit.fill,)),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left: 12.0),
                          child: Text("Report ${(snapshot.data!.length - index ).toString()}",style: TextStyle(color: Colors.black,fontSize: 25),),
                        )

                      ],
                    ),
                  ),
                ),
              );
            }
        ): Center(child: Text("You do not have any report"),);

      }
    },future: getEntity(),);

  }
}


