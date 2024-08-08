import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zojatech_assignment/class/product_services.dart';
import 'package:zojatech_assignment/necessary%20widgets/text_widget.dart';

import '../class/json/product_json.dart';
import '../necessary widgets/spacing.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  Map<String, dynamic> _data = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProductServices _productServices = ProductServices();
  List<Data>? _productList;
  late AnimationController _controller;
  Animation<int>? _animationInt;
  final String _profilePlaceholder = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR5wt2-sE3VgB3SwwpeW9QWKNvvN3JqOFlUSQ&s";

  Future<void> _getUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          _data = userDoc.data() as Map<String, dynamic>;
        });
        print(_data);
      } else {
        _data = {};
      }

    } catch (e) {
      print('Error retrieving user track items: $e');
    }
  }

  Future _getProducts()async{
    await _productServices.products(context).then((v){
      if(v.status == "success"){
        setState(() {
          _productList = v.data;
        });
        print('dddddddddddddd$_productList');
      }
    });
  }

  _countNumbers(){
    if (_productList == null) return;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Adjust duration as needed
    );
     _animationInt = IntTween(begin: 0, end: _productList?.length).animate(_controller)
       ..addListener(() {
         setState(() {}); // Rebuild the widget with the new value
       });

    _controller.forward();
  }

  Future _getProductNumber()async{
    await _getProducts();
    _countNumbers();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserData();
    _getProductNumber();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat("#,##0", "en_US");
    String productLength = '0';
    if(_animationInt != null){
      productLength = numberFormat.format(_animationInt!.value);
    }

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xffD397F8).withOpacity(0.3),
              Colors.white,
            ],
            stops: [0.2, 0.43],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Space(height:MediaQuery.of(context).size.height*0.07),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                              image: NetworkImage(
                                  _data['image'] ?? _profilePlaceholder),
                              fit: BoxFit.fill
                          )
                      ),
                    ),
                  ],
                ),
                const Space(height:15),
                TextWidget(
                  text: 'Hello, ${_data['firstName']??''}',
                  fontSize: 30,
                  fontWeight:  FontWeight.w800,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: TextWidget(
                      text: 'There are $productLength products available for purchase',
                    color: const Color(0xffD397F8),
                    fontSize: 30,
                    fontWeight:  FontWeight.w800,
                  )
                ),
                const Space( height: 25,),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'You might like',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    )
                    ,
                    TextWidget(
                        text: 'See All',
                         fontSize: 16,
                        )
                  ],
                ),

                _productList != null?Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height*0.35,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _productList?.length,
                        itemBuilder: (context, index){
                        final data = _productList?[index];
                        return builderContainer(data, context);
                        }
                    ),
                  ),
                ):const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}


Widget builderContainer(Data? data, BuildContext context){
  return Column(
    children: [
      Container(
        width: MediaQuery.of(context).size.width*0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          image: DecorationImage(
              image: NetworkImage(data!.imageUrl!),
            fit: BoxFit.fill
          )
        ),
      ),
    ],
  );
}
