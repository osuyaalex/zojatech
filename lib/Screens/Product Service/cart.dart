
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zojatech_assignment/Screens/Product%20Service/home_page.dart';
import 'package:zojatech_assignment/Screens/Transaction%20Service/transaction_history.dart';
import 'package:zojatech_assignment/necessary%20widgets/icon_button_widget.dart';
import 'package:zojatech_assignment/necessary%20widgets/text_widget.dart';
import 'package:zojatech_assignment/class/cart_class.dart';
import '../../Provider/cart_provider.dart';
import '../../necessary widgets/spacing.dart';
import '../../utilities/shot_snackbar.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future _buyItem(BuildContext context)async{
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    EasyLoading.show();
    try{
      DocumentSnapshot documentSnapshot = await _firestore.
      collection('Transactions').doc(_auth.currentUser!.uid).
      get();

      List<dynamic> allTransactions = documentSnapshot.get('transactions') ?? [];
      allTransactions.add({
        'itemName': cartProvider.itemNames,
        'itemPrice':cartProvider.totalPrice,
        "paymentStatus": 'Successful',
        "disputeTransaction": 'None',
        "postTransaction": 'Okay',
        "amountPaid":cartProvider.totalPrice
      });
      await _firestore.
      collection('Transactions').doc(_auth.currentUser!.uid).update({
        'transactions': allTransactions
      });
      cartProvider.clearCart();
      EasyLoading.dismiss();
      shortSnack(context, 'Congratulations! Item has been purchased');
    }catch(e){
      EasyLoading.dismiss();
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    return Scaffold(
      backgroundColor: const Color(0xffE7EAEF),
      appBar: AppBar(
        toolbarHeight:80 ,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffE7EAEF),
        leading:IconButtonWidget(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)
        ),
        actions: [
          IconButtonWidget(
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const TransactionHistory();
                }));
              },
              icon: Icon(Icons.history)
          )
        ],
        title: const TextWidget(
          text: 'CART',
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      body:cartProvider.getItems.isNotEmpty?
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<CartProvider>(
              builder: (context, cartProvider, child){
                return Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.6,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade400
                              )
                          )
                      ),
                      child: ListView.builder(
                          itemCount: cartProvider.count,
                          itemBuilder: (context, index){
                            final cartItems = cartProvider.getItems[index];
                            print(cartProvider.itemNames);
                            return _listViewWidgets(cartItems, index);
                          }
                      ),
                    ),
                    const Space(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(text: 'Sub Total',
                          fontSize: 17,
                          ),
                          TextWidget(
                              text: '\$${cartProvider.totalPrice.toStringAsFixed(2)}',   //you use this if changes can be made in the context (in this case, increment and decrement). you can use one or the other
                                color: Colors.orange,
                                fontSize: 17
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: (){
                              cartProvider.clearCart();
                            },
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.red
                            ),
                            child: const TextWidget(
                              text: 'Clear Cart',
                                fontWeight: FontWeight.w500
                            )
                        )
                      ],
                    )
                  ],
                );
              }
          ),
        ),
      ): Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width+0.75,
          child: const TextWidget(
            text: 'You have no items in your Shopping Bag.',
            fontSize: 20,
            textAlign: TextAlign.center,

          ),
        ),
      ),
        bottomSheet:cartProvider.getItems.isEmpty?
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return HomePage();
            }));
          },
          child: _bottomContainer('Continue Shopping'),
        ):
       GestureDetector(
         onTap: ()async{
           await _buyItem(context);
         },
           child: _bottomContainer('Buy Now')
       )
    );
  }
  Widget _bottomContainer(String text){
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      child:  Center(
        child: TextWidget(
          text: text,
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _listViewWidgets(Cart cartItems, int index){
    final cartProvider = context.watch<CartProvider>();
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            'https://api.naijacp.com/naijacp/public/${cartItems.imageUrl}',
            height: 180,
            width: 150,
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextWidget(
                      text: 'Buy Now!',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )
                ),
                Text(cartItems.name,
                  style: GoogleFonts.tenorSans(
                    fontSize: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      IconButtonWidget(
                          onPressed:cartItems.quantity ==1? null
                              :(){
                            cartProvider.decrement(cartItems);
                          },
                          icon: Icon(Icons.remove)
                      ),
                      TextWidget(text:cartItems.quantity.toString()),
                      IconButtonWidget(
                          onPressed: cartItems.quantity ==
                              30? null
                              :(){
                            cartProvider.increment(cartItems);
                          },
                          icon:  const Icon(Icons.add)
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 13.0),
                  child: Text('\$${cartItems.price.toStringAsFixed(2)}',
                    style: GoogleFonts.tenorSans(
                        fontSize: 14,
                        color: Colors.orange
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        IconButtonWidget(
            onPressed: (){
              setState(() {
                cartProvider.getItems.removeAt(index);
              });
            }, icon: Icon(Icons.close)
        )
      ],
    );
  }
}
