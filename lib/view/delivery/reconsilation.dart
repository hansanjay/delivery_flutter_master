import 'package:delivery_flutter_master/models/reconciliation_model.dart';
import 'package:delivery_flutter_master/services/reconciliation_service.dart';
import 'package:delivery_flutter_master/view/modal/reconsilation_product_list.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../utils/color_utils.dart';

class ReconsilationScreen extends StatefulWidget {
  const ReconsilationScreen({Key? key}) : super(key: key);
  @override
  State<ReconsilationScreen> createState() => _ReconsilationScreenState();
}
class _ReconsilationScreenState extends State<ReconsilationScreen> {
  late Future<List<DailyItems>> futureDailyItems;
  bool isLoading = true;
  @override
  void initState() {
    futureDailyItems = ReconciliationService().getAllItems();
    futureDailyItems.then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
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
              title: Text("Reconciliation List",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500)),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
            ),
          backgroundColor: Color(0xffE8E6EA),
          body: FutureBuilder<List<DailyItems>>(
            future: futureDailyItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No data available'));
              } else {
                List<DailyItems> dailyItems = snapshot.data!;
                return Column(
                  children: [
                    Container(
                      width: _width,
                      child: Material(
                        elevation: 1,
                        color: ColorUtils.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Items: ${dailyItems.fold<int>(0, (previousValue, element) => previousValue + element.items.length)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(height: 1),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: dailyItems
                              .map((dateGroup) => showDelivered(context, dateGroup))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
    );
  }
  Widget showDelivered(context, DailyItems orders) {
    return Column(
      children: List.generate(1, (index) {
        return InkWell(
          onTap: () async {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (ctx) {
                return ReconsilationModal(
                    orders: orders
                );
              },
            );
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
                    Row(
                      children: [
                        Text(
                          "Date:",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          " ${orders.date}",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Total Items: ${orders.items.length}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Divider(height: 1),
                    ListTile(
                      leading: Text(
                        "Items",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 25,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (ctx) {
                              return ReconsilationModal(
                                orders: orders
                              );
                            },
                          );
                        },
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
}
