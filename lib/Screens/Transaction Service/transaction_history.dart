import 'package:flutter/material.dart';
import 'package:zojatech_assignment/Services/get_firestore_data.dart';
import 'package:zojatech_assignment/necessary%20widgets/spacing.dart';
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
        elevation: 0,
      ),
      body: _data.isNotEmpty?Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: _data['transactions'].length,
            itemBuilder: (context, index){
            final transactionInfo = _data['transactions'][index];
            return _listViewWidget(transactionInfo);
            }
        ),
      ):const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget richText(String key, String value){
    return RichText(
      text: TextSpan(
          text: '$key:  ',
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 14
          ),
          children:  <TextSpan>[
            TextSpan(
                text: value,
                style: const TextStyle(
                  color: Color(0xffE8D28B),
                ),
            ),
          ]
      ),
    );
  }

  Widget _listViewWidget(dynamic transactionInfo){
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 14),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            richText("Items",  transactionInfo['itemName'].join(', '),),
            const Space(height: 3),
            richText('price', '\$ ${transactionInfo['itemPrice']}',),
            const Space(height: 3),
            richText('Dispute Transaction', transactionInfo['disputeTransaction'],),
            const Space(height: 3),
            richText('Post Transaction', transactionInfo['postTransaction'],),
            const Space(height: 12),
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(text: transactionInfo['paymentStatus'],
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
                richText('Amount paid', '\$${transactionInfo['amountPaid']}')

              ],
            )
          ],
        ),
      ),
    );
  }
}
