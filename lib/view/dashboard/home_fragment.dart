import 'package:delivery_flutter_master/models/profile_model.dart';
import 'package:delivery_flutter_master/services/home_summary_service.dart';
import 'package:delivery_flutter_master/services/profile_service.dart';
import 'package:delivery_flutter_master/utils/icons_utils.dart';
import 'package:flutter/material.dart';
import '../delivery/reconsilation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:octo_image/octo_image.dart';
class HomeFragment extends StatefulWidget {
  const HomeFragment({Key? key}) : super(key: key);
  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  Future<Map<String, dynamic>>? homeSummary;
  String name="",mobno="";
  @override
  void initState() {
    homeSummary = HomeSummary().fetchDeliverySummary();
    fetchProfile();
    super.initState();
  }

  void fetchProfile() async {
    try {
      ProfileService profileService = ProfileService();
      Profile profile = await profileService.fetchProfile();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("FNAME", profile.firstName);
      prefs.setString("LNAME", profile.lastName);
      prefs.setString("MOBILE", profile.mobile);
      prefs.setString("EMAIL", profile.email);

      setState(() {
        name = profile.firstName + " " + profile.lastName;
        mobno = profile.mobile;
      });
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              leading: Padding(
                padding: EdgeInsets.only(left: 10, top: 8, bottom: 8),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: OctoImage(
                    height: 70,
                    image: AssetImage('assets/image/panda.png'),
                    progressIndicatorBuilder:
                        OctoProgressIndicator.circularProgressIndicator(),
                    imageBuilder: OctoImageTransformer.circleAvatar(),
                    errorBuilder: (context, ob, st) {
                      return IconsWidgets.deliveryMan;
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, ',
                        style: TextStyle(fontSize: 12.0, color: Colors.black87),
                      ),
                      SizedBox(width: 2),
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    mobno,
                    style: TextStyle(
                        fontSize: 11.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            // backgroundColor: Color(0xffE8E6EA),
            backgroundColor: Color(0xffE8E6EA),
            body: FutureBuilder<Map<String, dynamic>>(
                future: homeSummary,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    final deliveries = data['deliveries'];
                    final items = data['items'];
                    final pendingReconciliation = data['pendingReconciliation'];

                    return Column(children: [
                      Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 3, right: 3),
                              width: _width,
                              child: Card(
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "TODAY'S DELIVERY STATS:",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                GridView(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                  ),
                                                  children: [
                                                    Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xffffe7f4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                "assets/icon/delivery-bike.png",
                                                                height: 30,
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Total Delivery',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                deliveries[
                                                                        'total']
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                    Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xffe4ffeb),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                "assets/icon/shipped.png",
                                                                height: 30,
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Completed Delivery',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                deliveries[
                                                                        'delivered']
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                    Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xffffbaba),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                "assets/icon/time.png",
                                                                height: 30,
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Pending Delivery',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                deliveries[
                                                                        'pending']
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                  shrinkWrap: true,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ))),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 3, right: 3),
                              width: _width,
                              child: Card(
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "TODAY'S ITEMS STATS:",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                GridView(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                  ),
                                                  children: [
                                                    Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xfffaf7b2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                "assets/icon/shopping-bag.png",
                                                                height: 30,
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                'Total Items',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                items['total']
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                    Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xffd7e5ff),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                "assets/icon/delivered.png",
                                                                height: 30,
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                'Delivered Items',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 5),
                                                              Text(
                                                                items['delivered']
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                    Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xffdfc2ff),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                "assets/icon/dairy-products.png",
                                                                height: 30,
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                'Available Items',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                items['pending']
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                  shrinkWrap: true,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ))),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 3, right: 3),
                              width: _width,
                              child: Card(
                                  surfaceTintColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "RECONSILATION TILL DATE:",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                GridView(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                  ),
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ReconsilationScreen()));
                                                      },
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xffc8fcf1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          margin:
                                                              EdgeInsets.all(
                                                                  10),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                  "assets/icon/dairy-products.png",
                                                                  height: 30,
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  'Not Returned Items',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        10.0,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text(
                                                                  pendingReconciliation
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                    )
                                                  ],
                                                  shrinkWrap: true,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ))),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        )),
                      )
                    ]);
                  } else {
                    return Center(child: Text('No data available'));
                  }
                })));
  }
}
