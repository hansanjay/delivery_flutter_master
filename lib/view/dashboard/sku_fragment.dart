import 'package:delivery_flutter_master/models/delivery_route_model.dart';
import 'package:delivery_flutter_master/services/delivery_route_service.dart';
import 'package:delivery_flutter_master/view/sku/sku_collect_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SKUFragment extends StatefulWidget {
  const SKUFragment({Key? key}) : super(key: key);
  @override
  State<SKUFragment> createState() => _SKUFragmentState();
}

class _SKUFragmentState extends State<SKUFragment> {
  late Future<List<Routes>> _routesFuture;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    _routesFuture = RoutesService().fetchAllRoutes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              title: Text("SKU Routes",
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
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => SKUCollectItem(routeId :route.id)));
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
                                              left: 10, right: 10, top: 10, bottom: 3),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Journey Plan #${index + 1}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,color: Colors.grey[700],)
                                              ),
                                              SizedBox(height: 10,),
                                              Divider(height: 1,),
                                              SizedBox(height: 10,),
                                              ListTile(
                                                  title: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        route.title ?? '',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              route.desc ?? '',
                                                              maxLines: 3,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors.grey[700],
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500),
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
                                                  )
                                              )
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
