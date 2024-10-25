import 'dart:convert';

import 'package:cart_stepper/cart_stepper.dart';
import 'package:delivery_flutter_master/models/client_orders_model.dart';
import 'package:delivery_flutter_master/models/sku_items_model.dart';
import 'package:delivery_flutter_master/services/client_orders_service.dart';
import 'package:delivery_flutter_master/services/sku_items_service.dart';
import 'package:delivery_flutter_master/view/delivery/delivery_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/color_utils.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class ViewOrder extends StatefulWidget {
  final int orderId, routeId;
  const ViewOrder({super.key, required this.orderId, required this.routeId});
  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

var id;
Map<int, int> productQuantities1 = {};
Map<int?, int?> productQuantities2 = {};
List<ProductD> products1 = [];
void removeProduct(int? productId) {
  products1.removeWhere((product) => product.product_id == productId);
}
class _ViewOrderState extends State<ViewOrder> {
  String number = "";
  bool showCounter = false;
  late Future<Order> orderFuture;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    super.initState();
    products1.clear();
    productQuantities2.clear();
    productQuantities1.clear();
    id = widget.routeId;
    orderFuture = OrderService().getOrderById(widget.routeId, widget.orderId);
  }
  Future<void> deliverOrder() async {
    Map<String, dynamic> payload = {
      "status": "D",
      "lines": productQuantities1.entries
          .map((entry) => {
        "product_id": entry.key,
        "quantity": entry.value,
      })
          .toList(),
    };

    var additionalLines = productQuantities2.entries
        .where((entry) => entry.value != null && entry.value != 0)
        .map((entry) => {
      "product_id": entry.key!,
      "quantity": entry.value!,
    })
        .toList();

    (payload["lines"] as List).addAll(additionalLines);

    print("Payload: "+payload.toString());

    try {
     await OrderService().deliverOrder(payload, widget.routeId,widget.orderId);
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        "Order delivered successful",
        type: AnimatedSnackBarType.success,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder:
                  (context) =>
                  DeliveryList(routeId: widget.routeId,)));
    } catch (e) {
      AnimatedSnackBar.material(
        duration: const Duration(seconds: 5),
        e.toString(),
        type: AnimatedSnackBarType.error,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      ).show(context);
      print('Error delivering order: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder:
                  //             (context) =>
                  //             DeliveryList(routeId: widget.routeId,)));
                  Navigator.pop(context);
                },
              ),
              title: const Text("Order Details",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500)),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.call,
                    color: Colors.green,
                    size: 25,
                  ),
                  onPressed: () {
                    _launchPhoneCall(number);
                  },
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
            backgroundColor: const Color(0xffE8E6EA),
            body: FutureBuilder<Order>(
                future: orderFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No order found'));
                  }
                  Future.delayed(Duration.zero, () {
                    setState(() {
                      number = snapshot.data!.customer_phone;
                    });
                  });
                  final order = snapshot.data!;
                  return Stack(children: [
                    Column(children: [
                      Expanded(
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                            Material(
                                elevation: 1,
                                color: ColorUtils.white,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 5),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${order.address.shortName}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              "assets/icon/google-maps.png",
                                              height: 25,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${order.address.line1}, ${order.address.city}, ${order.address.stateName}',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Material(
                                elevation: 1,
                                color: ColorUtils.white,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, top: 10),
                                          child: const Text(
                                            "Items",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const ListTile(
                                          title: Text(
                                            "Product Name",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.black),
                                          ),
                                          trailing: Text(
                                            "Quantity",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: ColorUtils.black2D),
                                          ),
                                        ),
                                        ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              final line = order.lines[index];
                                              productQuantities1.putIfAbsent(
                                                  line.productId,
                                                  () => line.quantity);
                                              return ListTile(
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        line.product.title,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            line.product
                                                                .unitDisplay,
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: ColorUtils
                                                                    .black2D),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  leading: Container(
                                                    width: 5,
                                                    height: 5,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  trailing: SizedBox(
                                                      width: 180,
                                                      height: 30,
                                                      child: Row(children: [
                                                        CartStepperInt(
                                                          value:
                                                              productQuantities1[
                                                                  line.productId],
                                                          size: 30,
                                                          style:
                                                              CartStepperStyle(
                                                            foregroundColor:
                                                                Colors.black87,
                                                            activeForegroundColor:
                                                                Colors.black87,
                                                            activeBackgroundColor:
                                                                Colors.white,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey),
                                                            radius: const Radius
                                                                .circular(20),
                                                            elevation: 0,
                                                            buttonAspectRatio:
                                                                1.2,
                                                          ),
                                                          didChangeCount:
                                                              (count) {
                                                            setState(() {
                                                              productQuantities1[
                                                                      line.productId] =
                                                                  count;
                                                            });
                                                          },
                                                        ),
                                                        const SizedBox(
                                                            width: 20),
                                                        Text(
                                                          line.quantity
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ])));
                                            },
                                            separatorBuilder:
                                                (context, index) =>
                                                    const Divider(
                                                      thickness: 1,
                                                      color: Colors.black12,
                                                    ),
                                            itemCount: order.lines.length)
                                      ],
                                    ))),
                            const SizedBox(
                              height: 10,
                            ),
                            if (products1.length > 0)
                              Column(
                                children: [
                                  Material(
                                      elevation: 1,
                                      color: ColorUtils.white,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0, vertical: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, top: 10),
                                                child: const Text(
                                                  "Extra Items",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              const ListTile(
                                                title: Text(
                                                  "Product Name",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.black),
                                                ),
                                                trailing: Text(
                                                  "Quantity",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: ColorUtils.black2D),
                                                ),
                                              ),
                                              ListView.separated(
                                                  shrinkWrap: true,
                                                  physics:
                                                  const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    final line2 = products1[index];
                                                    return ListTile(
                                                        title: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                              line2.product_title
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 13),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  line2
                                                                      .product_unitDisplay
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize: 10,
                                                                      color: ColorUtils
                                                                          .black2D),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        leading: Container(
                                                          width: 5,
                                                          height: 5,
                                                          decoration:
                                                          const BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        trailing: SizedBox(
                                                            width: 180,
                                                            height: 30,
                                                            child: Row(
                                                                children: [
                                                                  Spacer(),
                                                                  Text(
                                                                    line2.product_quantity
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                      fontSize: 14,
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                  Center(
                                                                    child: IconButton(onPressed: (){
                                                                      setState(() {
                                                                        removeProduct(line2.product_id);
                                                                      });
                                                                    }, icon: Icon(Icons.delete,color: Colors.red,)),
                                                                  )
                                                                ])));
                                                  },
                                                  separatorBuilder:
                                                      (context, index) =>
                                                  const Divider(
                                                    thickness: 1,
                                                    color: Colors.black12,
                                                  ),
                                                  itemCount: products1.length)
                                            ],
                                          ))),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            Material(
                              elevation: 1,
                              color: ColorUtils.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const ListTile(
                                      title: Text(
                                        "Add more items",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10.0),
                                      child: Container(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            productQuantities2.clear();
                                            products1.clear();
                                            showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (ctx) {
                                                  return ShowModal();
                                                });
                                          },
                                          icon: const Icon(
                                              Icons.add),
                                          label: const Text("ADD",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                          ])))
                    ]),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 90,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                          ),
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Container(
                            width: width,
                            padding: const EdgeInsets.all(16),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorUtils.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side:
                                      const BorderSide(color: ColorUtils.black),
                                ),
                              ),
                              onPressed: () {
                                deliverOrder();
                              },
                              child: const Text(
                                "CONFIRM AND DELIVER",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]);
                })));
  }

  void _launchPhoneCall(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(phoneLaunchUri.toString())) {
      await launch(phoneLaunchUri.toString());
    } else {
      throw 'Could not launch $phoneLaunchUri';
    }
  }
}

class ShowModal extends StatefulWidget {
  @override
  _ShowModalState createState() => _ShowModalState();
}

class _ShowModalState extends State<ShowModal> {
  late Future<SKUSummary> futureSKUItems;
  @override
  void initState() {
    super.initState();
    productQuantities2.clear();
    futureSKUItems = SKUService().fetchSKUItemsById(id);
  }

  void addOrUpdateProduct(ProductD newProduct) {
    bool productExists = false;

    for (var product in products1) {
      if (product.product_id == newProduct.product_id) {
        product.product_quantity += 1;
        productExists = true;
        break;
      }
    }
    if (!productExists) {
      products1.add(newProduct);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 20),
            ListTile(
              title: Text(
                'Add products from bag',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(Icons.close, size: 30),
              onTap: () {
                Navigator.pop(context);
                productQuantities2.clear();
                products1.clear();
              },
            ),
            ListTile(
              title: Text(
                "Product Name",
                style: TextStyle(fontSize: 11, color: Colors.black),
              ),
              trailing: Text(
                "Available Quantity",
                style: TextStyle(fontSize: 11, color: ColorUtils.black2D),
              ),
            ),
            FutureBuilder<SKUSummary>(
                future: futureSKUItems,
                builder: (context, snapshot1) {
                  if (snapshot1.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot1.hasError) {
                    return Center(child: Text('Error: ${snapshot1.error}'));
                  } else if (snapshot1.hasData &&
                      snapshot1.data!.status == "Collected") {
                    final data = snapshot1.data!;
                    final products = data.products!.where((product) => !productQuantities1.containsKey(product.product!.id!)).toList();
                    return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {

                          final productDetail = products[index];
                          final product = productDetail.product;
                          productQuantities2.putIfAbsent(product!.id, () => 0);
                          return ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        product.unitDisplay ?? '',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: ColorUtils.black2D),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              leading: Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                              ),
                              trailing: SizedBox(
                                  width: 180,
                                  height: 30,
                                  child: Row(children: [
                                    productQuantities2[product.id]! > 0
                                        ? CartStepperInt(
                                            value:
                                                productQuantities2[product.id],
                                            size: 25,
                                            style: CartStepperStyle(
                                              foregroundColor: Colors.black,
                                              activeForegroundColor:
                                                  Colors.black,
                                              activeBackgroundColor:
                                                  Colors.white,
                                              border: Border.all(
                                                  color: Colors.black),
                                              radius: const Radius.circular(20),
                                              elevation: 0,
                                              buttonAspectRatio: 1.2,
                                            ),
                                            didChangeCount: (count) {
                                              setState(() {
                                                if (((productDetail.quantity!
                                                                .collected ??
                                                            0) -
                                                        (productDetail.quantity!
                                                                .delivered ??
                                                            0)) >=
                                                    count ) {
                                                  productQuantities2[
                                                      product.id] = count;
                                                  addOrUpdateProduct(ProductD(
                                                      product_id: product.id,
                                                      product_title:
                                                      product.title,
                                                      product_unitDisplay:
                                                      product.unitDisplay,
                                                      product_quantity: 1));
                                                } else {
                                                  AnimatedSnackBar.material(
                                                    duration: const Duration(
                                                        seconds: 5),
                                                    "Cannot add more than available quantity",
                                                    type: AnimatedSnackBarType
                                                        .error,
                                                    mobileSnackBarPosition:
                                                        MobileSnackBarPosition
                                                            .bottom,
                                                  ).show(context);
                                                }
                                              });
                                            },
                                          )
                                        : Container(
                                            height: 30,
                                            child: OutlinedButton(
                                              child: Text(
                                                "Add To Cart",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                              ),
                                              onPressed: () {
                                                productQuantities2[product.id] =
                                                    1;
                                                addOrUpdateProduct(ProductD(
                                                    product_id: product.id,
                                                    product_title:
                                                        product.title,
                                                    product_unitDisplay:
                                                        product.unitDisplay,
                                                    product_quantity: 1));
                                              },
                                            )),
                                    const SizedBox(width: 20),
                                    Text(
                                      ((productDetail.quantity!.collected ??
                                                  0) -
                                              (productDetail
                                                      .quantity!.delivered ??
                                                  0))
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ])));
                        },
                        separatorBuilder: (context, index) => const Divider(
                              thickness: 1,
                              color: Colors.black12,
                            ),
                        itemCount: products!.length);
                  } else {
                    return Center(child: Text('No data available'));
                  }
                }),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorUtils.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: ColorUtils.black),
                  ),
                ),
                onPressed: () {
                  AnimatedSnackBar.material(
                    duration: const Duration(seconds: 5),
                    "Extra items added to order",
                    type: AnimatedSnackBarType.success,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  ).show(context);
                  Navigator.pop(context);
                },
                child: Text(
                  "ADD TO ORDER",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductD {
  final int? product_id;
  final String? product_title;
  final String? product_unitDisplay;
  int product_quantity;
  ProductD({
    required this.product_id,
    required this.product_title,
    required this.product_unitDisplay,
    required this.product_quantity,
  });

  factory ProductD.fromJson(Map<String, dynamic> json) {
    return ProductD(
      product_id: json['id'],
      product_title: json['title'],
      product_unitDisplay: json['unitDisplay'],
      product_quantity: json['id'],
    );
  }
}
