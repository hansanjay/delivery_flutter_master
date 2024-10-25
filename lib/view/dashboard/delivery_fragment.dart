import 'package:delivery_flutter_master/view/delivery/delivery_list.dart';
import 'package:flutter/material.dart';

import '../../models/delivery_route_model.dart';
import '../../services/delivery_route_service.dart';
import '../../utils/color_utils.dart';
import '../../utils/variable_utils.dart';

class DeliveryFragment extends StatefulWidget {
  const DeliveryFragment({Key? key}) : super(key: key);
  @override
  State<DeliveryFragment> createState() => _DeliveryFragmentState();
}

class _DeliveryFragmentState extends State<DeliveryFragment> {
  late Future<List<Routes>> _routesFuture;
  @override
  void initState() {
    _routesFuture = RoutesService().fetchAllRoutes();
    super.initState();
  }
  void openDeliveryList(int routeId){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DeliveryList(routeId:routeId,)));
  }
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              title: Text("Journey Plans",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500)),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Color(0xffE8E6EA),
            body: FutureBuilder<List<Routes>>(
              future: _routesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No routes available'));
                }

                List<Routes> routes = snapshot.data!;

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(routes.length, (index) {
                          Routes route = routes[index];
                          return InkWell(
                              onTap: () async {
                                openDeliveryList( route.id);
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
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 3),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Journey Plan #${index + 1}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Colors.grey[700],
                                                  )),
                                              Text(route.deliveries.delivered.toString()+"/"+route.deliveries.total.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Colors.grey[700],
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Divider(
                                            height: 1,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ListTile(
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    route.title ?? '',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          route.desc ?? '',
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[700],
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              trailing: IconButton(
                                                icon: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 15,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {},
                                              ))
                                        ],
                                      )),
                                ),
                              ));
                        }),
                      )),
                    )
                  ],
                );
              },
            )));
  }
}
