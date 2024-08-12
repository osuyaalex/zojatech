import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zojatech_assignment/Provider/cart_provider.dart';
import 'package:zojatech_assignment/Provider/products_provider.dart';
import 'package:zojatech_assignment/Screens/Product%20Service/product_details.dart';
import 'package:zojatech_assignment/Screens/Product%20Service/see_all_products.dart';
import 'package:zojatech_assignment/Screens/Product%20Service/see_all_tapped_products.dart';
import 'package:zojatech_assignment/Services/get_firestore_data.dart';
import 'package:zojatech_assignment/Services/product_services.dart';
import 'package:zojatech_assignment/class/user_class.dart';
import 'package:zojatech_assignment/necessary%20widgets/text_widget.dart';

import '../../Services/json/product_json.dart';
import '../../class/product_class.dart';
import '../../necessary widgets/icon_button_widget.dart';
import '../../necessary widgets/spacing.dart';
import '../Transaction Service/transaction_history.dart';
import 'cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  Users? _users;
  final ProductServices _productServices = ProductServices();
  final GetFirestoreData _getFirestoreData = GetFirestoreData();
  List<Data>? _productList;
  late AnimationController _controller;
  Animation<int>? _animationInt;


Future _getUserData()async{
  _getFirestoreData.getUserData().then((value){
   if(mounted){
     setState(() {
       _users = value;
     });
   }
  });
}

  Future _getProducts()async{
    await _productServices.products(context).then((v){
      if(v.status == "success"){
        if(mounted){
          setState(() {
            _productList = v.data;
          });
        }
        print('dddddddddddddd$_productList');
      }
    });
  }

  _countNumbers(){
    if (_productList == null) return;
     _animationInt = IntTween(begin: 0, end: _productList?.length).animate(_controller)
       ..addListener(() {
        if(mounted){
          setState(() {});
        } // Rebuild the widget with the new value
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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Adjust duration as needed
    );
    _getUserData();
    _getProductNumber();
    Provider.of<CartProvider>(context, listen: false).loadCart();
    Provider.of<ProductProvider>(context, listen: false).loadProduct();
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButtonWidget(
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return const TransactionHistory();
                          }));
                        },
                        icon: Icon(Icons.history, color: Colors.grey,)
                    ),
                    IconButtonWidget(
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return const CartPage();
                          }));
                        }, icon: const Icon(Icons.shopping_cart, color: Colors.grey,)
                    )
                  ],
                ),
                const Space(height:15),
                TextWidget(
                  text: 'Hello, ${_users?.firstName??'Guest'}',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextWidget(
                      text: 'You might like',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    )
                    ,
                    TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return const SeeAllProducts();
                          }));
                        },
                        child: const TextWidget(
                          text: 'See All',
                          fontSize: 16,
                        )
                    )
                  ],
                ),

                _productList != null?Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height*0.25,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                        itemBuilder: (context, index){
                        final data = _productList?[index];
                        return _builderContainer(data, context);
                        }
                    ),
                  ),
                ):const Center(
                  child: CircularProgressIndicator(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextWidget(
                      text: 'Recently Viewed',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    )
                    ,
                    TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return const SeeAllTappedProduct();
                          }));
                        },
                        child: const TextWidget(
                          text: 'See All',
                          fontSize: 16,
                        )
                    ),
                  ],
                ),
                Consumer<ProductProvider>(
                    builder: (context, productProvider, child){
                      int? itemCount = productProvider.count;
                      int maxItemCount = 3;
                      int? displayedItemCount = itemCount! < maxItemCount ? itemCount : maxItemCount;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: displayedItemCount,
                                itemBuilder: (context, index){
                                  final product = productProvider.getItems[index];
                                  return _providerContainer(product, context);
                                }
                            )
                          ],
                        ),
                      );
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String formatNumberInDouble(String? number) {
  if(number != null){
    var convertedNumber = double.parse(number);
    final formatter = NumberFormat('#,###.##');
    return formatter.format(convertedNumber);
  }
  return '';
}

Widget _builderContainer(Data? data, BuildContext context){
  final productProvider = Provider.of<ProductProvider>(context);
  final product = Product(
      title:  data!.title!,
      imagePath: data.imagePath!,
      price: data.pricelists!.isNotEmpty?
      data.pricelists![0].price!:'500',
      description: data.description!,
      genre: data.genre!

  );
  return GestureDetector(
    onTap: (){
      data.pricelists!.isNotEmpty?
      productProvider.addItem(
          data.title!,
          data.imagePath!,
          data.pricelists![0].price!,
        data.description!,
        data.genre!
      ):productProvider.addItem(
          data.title!,
          data.imagePath!,
          '500',
          data.description!,
          data.genre!
      );
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return ProductDetails(details: product,);
      }));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.7,
            height: MediaQuery.of(context).size.height*0.18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              image: DecorationImage(
                  image: NetworkImage('https://api.naijacp.com/naijacp/public/${data.imagePath!}'),
                fit: BoxFit.fill
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: data.title!,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                data.pricelists!.isNotEmpty?TextWidget(
                    text: "\$ ${formatNumberInDouble(data.pricelists?[0].price!)}",
                ):const TextWidget(
                  text: '\$ 700',
                )
              ],
            ),
          )

        ],
      ),
    ),
  );
}

Widget _providerContainer(Product product, BuildContext context){
  return GestureDetector(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return ProductDetails(details: product,);
      }));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.85,
            height: MediaQuery.of(context).size.height*0.25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                    image: NetworkImage('https://api.naijacp.com/naijacp/public/${product.imagePath}'),
                    fit: BoxFit.fill
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: product.title,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                TextWidget(
                  text: "\$ ${formatNumberInDouble(product.price)}",
                )
              ],
            ),
          )

        ],
      ),
    ),
  );
}
