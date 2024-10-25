import 'package:delivery_flutter_master/models/client_orders_model.dart';
import 'package:delivery_flutter_master/services/client_orders_service.dart';
import 'package:delivery_flutter_master/view/dashboard/dashboard.dart';
import 'package:delivery_flutter_master/view/delivery/view_order.dart';

import 'package:flutter/material.dart';

import '../../utils/color_utils.dart';

class DeliveryList extends StatefulWidget {
  final int routeId;
  const DeliveryList({Key? key, required this.routeId}) : super(key: key);
  @override
  State<DeliveryList> createState() => _DeliveryListState();
}

class _DeliveryListState extends State<DeliveryList> {
  int _selectedIndex = 0;
  List<String> _tabs = ['Pending', 'Delivered'];
  late Future<RouteOrders> futureOrders;
  @override
  void initState() {
    super.initState();
  }
  void openViewOrder(int orderId,int routeId){
    Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => ViewOrder(orderId: orderId, routeId: routeId,)));
  }
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              surfaceTintColor: Colors.transparent,
              title: Text("Delivery List",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500)),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Color(0xffE8E6EA),
            body: Column(children: [
              Material(
                elevation: 1,
                color: ColorUtils.white,
                child: Padding(
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
                                        borderRadius: BorderRadius.circular(20),
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
              ),
              Divider(
                height: 1,
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedIndex==1)
                      showDelivered(context)
                    else if (_selectedIndex==0)
                      showPending(context)
                  ]
                )),
              )
            ])));
  }
  Widget showDelivered(BuildContext context) {
    return FutureBuilder<RouteOrders>(
      future: OrderService().fetchAllOrders(widget.routeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.orders.isEmpty) {
          return Center(child: Text('No pending orders found.'));
        } else {
          final pendingOrders = snapshot.data!.orders.where((order) => order.status == "D").toList();
          return Column(
            children: List.generate(pendingOrders.length, (index) {
              final order = pendingOrders[index];
              return InkWell(
                onTap: () async {
                  // Navigator.push(context,  MaterialPageRoute(builder: (context) => ViewOrder()));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: Card(
                    elevation: 2,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Delivery #${index + 1}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "Delivered",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(height: 1),
                          SizedBox(height: 10),
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.address.shortName ?? 'Unknown',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/icon/google-maps.png",
                                      height: 20,
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        '${order.address.line1}, ${order.address.line2}, ${order.address.line3}, ${order.address.city}' ?? 'Unknown address',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Divider(height: 1),
                                SizedBox(height: 5),
                                Text(
                                  "Total Items: ${order.lines.length}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }
      },
    );
  }
  Widget showPending(BuildContext context) {
    return FutureBuilder<RouteOrders>(
      future: OrderService().fetchAllOrders(widget.routeId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.orders.isEmpty) {
          return Center(child: Text('No pending orders found.'));
        } else {
          final pendingOrders= snapshot.data!.orders.where((order) => order.status == "P").toList();
          // if(_selectedIndex==0){
          //
          // }
          // else if(_selectedIndex==1)
          //   {
          //     orderList=snapshot.data!.orders.where((order) => order.status == "D").toList();
          //   }
          return Column(
            children: List.generate(pendingOrders.length, (index) {
              final order = pendingOrders[index];
              return InkWell(
                onTap: () async {
                  openViewOrder(order.id, widget.routeId);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: Card(
                    elevation: 2,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Delivery #${index + 1}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.yellow[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "Pending",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(height: 1),
                          SizedBox(height: 10),
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.address.shortName ?? 'Unknown',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/icon/google-maps.png",
                                      height: 20,
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        '${order.address.line1}, ${order.address.line2}, ${order.address.line3}, ${order.address.city}' ?? 'Unknown address',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Divider(height: 1),
                                SizedBox(height: 5),
                                Text(
                                  "Total Items: ${order.lines.length}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }
      },
    );
  }
}
