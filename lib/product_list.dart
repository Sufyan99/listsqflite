import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:listsqflite/cart_model.dart';
import 'package:listsqflite/cart_provider.dart';
import 'package:listsqflite/cart_screen.dart';
import 'package:listsqflite/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:listsqflite/cart_provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DBHelper dbHelper = DBHelper();
  List<String> productName = ['Mango' , 'Orange' , 'Grapes' , 'Banana' , 'Chery' , 'Peach','Mixed Fruit Basket',] ;
  List<String> productUnit = ['KG' , 'Dozen' , 'KG' , 'Dozen' , 'KG' , 'KG','KG',] ;
  List<int> productPrice = [10, 20 , 30 , 40 , 50, 60 , 70 ] ;
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg' ,
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg' ,
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg' ,
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612' ,
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612' ,
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612' ,
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612' ,
  ] ;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
        centerTitle: true,
        actions:  [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> CartScreen()));
            },
            child: Center(
              child: Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context , value , child){
                    return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white),);
                  }

                ),
                child:Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          SizedBox(width: 20,)
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child:  ListView.builder(
                itemCount: productName.length,
                  itemBuilder: (context,index){
                    return Card(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                height:100,
                                  width: 100,
                                  image: NetworkImage(productImage[index].toString())),
                              SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(productName[index].toString()),
                                  SizedBox(height: 5,),
                                  Text(productUnit[index].toString() + " "+r"$" + productPrice[index].toString()),
                                  SizedBox(height: 5,),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap:(){
                                        dbHelper.insert(Cart(
                                           id: index,
                                          productId: index.toString(),
                                          productName: productName[index].toString(),
                                          productPrice: productPrice[index],
                                          initialPrice: productPrice[index],
                                          quantity: 1,
                                          unitTag: productUnit[index].toString(),
                                          image: productImage[index].toString())
                                        ).then((value){
                                          print("Product is Added to Cart");
                                          cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                          cart.addCounter();
                                        }).onError((error, stackTrace){
                                          print(error.toString());
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 100,
                                        decoration:BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.green
                                        ) ,
                                        child: Center(child: Text("Add To Cart",style: TextStyle(color: Colors.white),)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),

                          ],)
                        ],
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}



