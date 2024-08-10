import 'package:flutter/material.dart';
import 'package:zojatech_assignment/Services/get_firestore_data.dart';
import 'package:zojatech_assignment/necessary%20widgets/text_widget.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  final GetFirestoreData _firestoreData = GetFirestoreData();
  Map<String,dynamic> _data = {};


  Future _getData()async{
    _firestoreData.getTransactionData().then((value){
      if(mounted){
        setState(() {
          _data = value!;
        });
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidget(text: 'Transaction History'),
        toolbarHeight:80 ,
        elevation: 0,
        backgroundColor: const Color(0xffE7EAEF),
      ),
      body: _data.isNotEmpty?ListView.builder(
        itemCount: _data['transactions'].length,
          itemBuilder: (context, index){

          }
      ):const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
