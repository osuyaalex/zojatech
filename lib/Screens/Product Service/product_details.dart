import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zojatech_assignment/Provider/cart_provider.dart';
import 'package:zojatech_assignment/Screens/Product%20Service/cart.dart';
import 'package:zojatech_assignment/necessary%20widgets/icon_button_widget.dart';
import 'package:zojatech_assignment/necessary%20widgets/spacing.dart';
import 'package:zojatech_assignment/necessary%20widgets/text_widget.dart';

import '../../necessary widgets/elevated_button.dart';
import '../../utilities/shot_snackbar.dart';

class ProductDetails extends StatefulWidget {
  final dynamic details;
  const ProductDetails({super.key, this.details});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {


  @override
  Widget build(BuildContext context) {
   final cartProvider = Provider.of<CartProvider>(context, listen: false);
   Color transparent = Colors.transparent;
   Color grey = Colors.grey;
   double width = MediaQuery.of(context).size.width;
   return Scaffold(
      appBar: AppBar(
        backgroundColor: transparent,
        shadowColor: transparent,
        title: TextWidget(text: 'Details'),
        actions: [
          IconButtonWidget(
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const CartPage();
                }));
              }, icon: Icon(Icons.shopping_cart, color: grey,)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height*0.6,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage('https://api.naijacp.com/naijacp/public/${widget.details.imagePath!}'),
                fit: BoxFit.fill
                )
              ),
            ),
            const Space(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                      text: widget.details.title,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                  const Space(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: widget.details.price,
                        fontSize: 16,
                        color: const Color(0xffD397F8),
                        fontWeight: FontWeight.w600,
                      ),
                      TextWidget(
                          text: widget.details.genre,
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      )
                    ],
                  ),
                  Space(height: 10),
                  TextWidget(text: widget.details.description,
                  color: Colors.grey.shade500,
                  ),
                  const Space(height: 20),
                  Button(
                      buttonColor: const Color(0xffD397F8),
                      text: 'Add to cart',
                      onPressed: (){
                       cartProvider.addItem(
                           widget.details.title,
                           widget.details.imagePath,
                           1,
                          double.parse( widget.details.price),
                           );
                       shortSnack(context, 'item successfully added to cart');
                      },
                      textColor: Colors.white,
                      width: width,
                      height: width*0.14,
                      minSize: false,
                      textOrIndicator: false
                  ),
                  const Space(height: 30),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
