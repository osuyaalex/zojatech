import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';


import '../../Provider/products_provider.dart';
import '../../Services/json/product_json.dart';
import '../../Services/product_services.dart';
import '../../necessary widgets/text_widget.dart';
import 'home_page.dart';

class SeeAllProducts extends StatefulWidget {
  const SeeAllProducts({super.key});

  @override
  State<SeeAllProducts> createState() => _SeeAllProductsState();
}

class _SeeAllProductsState extends State<SeeAllProducts> {
  List<Data>? _productList;
  final ProductServices _productServices = ProductServices();

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProducts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        title: const TextWidget(text: 'Available Products'),
      ),
      body: _productList != null?StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          itemCount: _productList!.length,
          itemBuilder: (context, index){
            var data = _productList![index];
            return _builderContainer(data, context);
          },
          staggeredTileBuilder: (context) => const StaggeredTile.fit(1)
      ):const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
Widget _builderContainer(Data? data, BuildContext context){
  final productProvider = Provider.of<ProductProvider>(context);
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
          'N/A',
          data.description!,
          data.genre!
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.35,
            height: MediaQuery.of(context).size.height*0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                image: DecorationImage(
                    image: NetworkImage('https://api.naijacp.com/naijacp/public/${data!.imagePath!}'),
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
                  text: 'N/A',
                )
              ],
            ),
          )

        ],
      ),
    ),
  );
}
