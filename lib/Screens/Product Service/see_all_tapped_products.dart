import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:zojatech_assignment/Screens/Product%20Service/product_details.dart';


import '../../Provider/products_provider.dart';
import '../../class/product_class.dart';
import '../../necessary widgets/text_widget.dart';
import 'home_page.dart';

class SeeAllTappedProduct extends StatefulWidget {
  const SeeAllTappedProduct({super.key});

  @override
  State<SeeAllTappedProduct> createState() => _SeeAllTappedProductState();
}

class _SeeAllTappedProductState extends State<SeeAllTappedProduct> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        title: const TextWidget(text: 'Recently Viewed'),
      ),
      body:   Consumer<ProductProvider>(
          builder: (context, productProvider, child){
          return StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 12,
              itemCount: productProvider.count,
              itemBuilder: (context, index){
                var data = productProvider.getItems[index];
                return _builderContainer(data, context);
              },
              staggeredTileBuilder: (context) => const StaggeredTile.fit(1)
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
          backgroundColor: Colors.red,
          onPressed: (){
            productProvider.clearCart();
          },
          child: TextWidget(text:'Clear',
          color: Colors.white,
              fontWeight: FontWeight.w600,
          ),
      ),
    );
  }
}
String cutUnwantedPart(String name) {
  if (name.length > 15) {
    return name.trim().replaceRange(15, null, '...');
  }
  return name;
}
Widget _builderContainer(Product data, BuildContext context){
  return GestureDetector(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return ProductDetails(details: data,);
      }));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.5,
            height: MediaQuery.of(context).size.height*0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                    image: NetworkImage('https://api.naijacp.com/naijacp/public/${data.imagePath}'),
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
                  text: cutUnwantedPart(data.title),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                TextWidget(
                  text: "\$ ${formatNumberInDouble(data.price)}",
                )
              ],
            ),
          )

        ],
      ),
    ),
  );
}
