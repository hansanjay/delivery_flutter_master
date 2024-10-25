import 'package:delivery_flutter_master/models/sku_items_model.dart';
import 'package:delivery_flutter_master/services/sku_items_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cart_stepper/cart_stepper.dart';
import '../../utils/color_utils.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class SKUCollectItem extends StatefulWidget {
  final int routeId;
  const SKUCollectItem({Key? key, required this.routeId}) : super(key: key);
  @override
  State<SKUCollectItem> createState() => _SKUCollectItemState();
}

class _SKUCollectItemState extends State<SKUCollectItem> {
  int _selectedIndex = 0;
  List<String> _tabs = ['Collect', 'Collected'];
  late Future<SKUSummary> skuProducts;
  Map<int, int> _productQuantities = {};
  bool showButton=false, showHeading= false;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    skuProducts = SKUService().fetchSKUItemsById(widget.routeId);
    super.initState();
  }

  Future<void> markCollectItems() async {
    Map<String, dynamic> payload = {
      "routeId": 1,
      "products": _productQuantities.entries
          .map((entry) => {
                "productId": entry.key,
                "collected": entry.value,
              })
          .toList(),
    };

    try {
      await SKUService().collectSKUItems(payload, 1);
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        "Items marked collected",
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      skuProducts = SKUService().fetchSKUItemsById(widget.routeId);
      setState(() {
        _selectedIndex=1;
        showButton=false;
        showHeading=true;
      });
    } catch (e) {
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        e.toString(),
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      print('Error updating order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 20,
                ),
              ),
              surfaceTintColor: Colors.transparent,
              title: Text("SKU Items",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500)),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Color(0xffE8E6EA),
            body: Material(
              elevation: 1,
              color: ColorUtils.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _tabs.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedIndex = index;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: _selectedIndex == index
                                              ? Colors.black
                                              : Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          _tabs[index],
                                          style: TextStyle(
                                            color: _selectedIndex == index
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ])),
                  Divider(
                    height: 1,
                  ),
                  if (_selectedIndex != 0 && showHeading)
                    ListTile(
                        title: Text(
                          "Product",
                          style: TextStyle(
                              fontSize: 10, color: ColorUtils.black2D),
                        ),
                        trailing: Container(
                          width: 250,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 30,
                              ),
                              Text(
                                "Collected",
                                style: TextStyle(
                                    fontSize: 10, color: ColorUtils.black2D),
                              ),
                              Text(
                                "Delivered",
                                style: TextStyle(
                                    fontSize: 10, color: ColorUtils.black2D),
                              ),
                              Text(
                                "Available",
                                style: TextStyle(
                                    fontSize: 10, color: ColorUtils.black2D),
                              ),
                            ],
                          ),
                        )),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (_selectedIndex == 0)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FutureBuilder<SKUSummary>(
                                    future: skuProducts,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (snapshot.hasData &&
                                          snapshot.data!.status == "Pending") {
                                        Future.delayed(Duration.zero, () {
                                          setState(() {
                                            showButton = true;
                                          });
                                        });
                                        final data = snapshot.data!;
                                        final products = data.products;
                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              350,
                                          child: GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 2.0,
                                              mainAxisSpacing: 2.0,
                                            ),
                                            itemCount: products!.length,
                                            itemBuilder: (context, index) {
                                              final productDetail =
                                                  products[index];
                                              final product =
                                                  productDetail.product;
                                              final quantity =
                                                  productDetail.quantity;
                                              _productQuantities.putIfAbsent(
                                                  product!.id!,
                                                  () => quantity!.ordered ?? 0);
                                              return Card(
                                                  elevation: 3,
                                                  color: Colors.white,
                                                  surfaceTintColor:
                                                      Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          product.title ?? '',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          product.brand ?? '',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Mass:  ",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            Text(
                                                              product.unitDisplay ??
                                                                  '',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    ColorUtils
                                                                        .grey85,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Quantity:  ",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              quantity!.ordered
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    ColorUtils
                                                                        .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        CartStepperInt(
                                                          value:
                                                              _productQuantities[
                                                                  product.id],
                                                          size: 30,
                                                          style:
                                                              CartStepperStyle(
                                                            foregroundColor:
                                                                Colors.black,
                                                            activeForegroundColor:
                                                                Colors.black,
                                                            activeBackgroundColor:
                                                                Colors.white,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black),
                                                            radius: const Radius
                                                                .circular(20),
                                                            elevation: 0,
                                                            buttonAspectRatio:
                                                                1.5,
                                                          ),
                                                          didChangeCount:
                                                              (count) {
                                                            setState(() {
                                                              _productQuantities[
                                                                      product
                                                                          .id!] =
                                                                  count;
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ));
                                            },
                                            padding: EdgeInsets.all(5),
                                          ),
                                        );
                                      } else {
                                        return Center(
                                            child: Text('No data available'));
                                      }
                                    }),
                                if(showButton)
                                  Container(
                                    width: _width,
                                    height: 80,
                                    padding: const EdgeInsets.all(16),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorUtils.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            side: const BorderSide(
                                                color: ColorUtils.black),
                                          ),
                                        ),
                                        onPressed: () {
                                          markCollectItems();
                                        },
                                        child: Text(
                                          "CONFIRM AND COLLECT",
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.white),
                                        )),
                                  )
                              ],
                            )
                          else if (_selectedIndex == 1)
                            FutureBuilder<SKUSummary>(
                                future: skuProducts,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  } else if (snapshot.hasData &&
                                      snapshot.data!.status == "Collected") {
                                    final data = snapshot.data!;
                                    final products = data.products;
                                    return ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          Future.delayed(Duration.zero, () {
                                            setState(() {
                                              showHeading = true;
                                            });
                                          });
                                          final productDetail =
                                          products[index];
                                          final product =
                                              productDetail.product;
                                          return ListTile(
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product!.brand ?? '',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    product.title ?? '',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        product.unitDisplay ?? '',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: ColorUtils
                                                                .black2D),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              trailing: Container(
                                                width: 250,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width: 30,
                                                    ),
                                                    Text(
                                                      productDetail.quantity!.collected.toString(),
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              ColorUtils.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      productDetail.quantity!.delivered.toString(),
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              ColorUtils.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ((productDetail.quantity!.collected?? 0) - (productDetail.quantity!.delivered ?? 0)).toString(),
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              ColorUtils.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        },
                                        separatorBuilder: (context, index) =>
                                            Divider(
                                              thickness: 1,
                                              color: Colors.black12,
                                            ),
                                        itemCount: products!.length);
                                  } else {
                                    return Center(
                                        child: Text('No data available'));
                                  }
                                })
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
