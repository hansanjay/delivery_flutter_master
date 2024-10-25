import 'package:delivery_flutter_master/utils/color_utils.dart';
import 'package:delivery_flutter_master/utils/variable_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/icons_utils.dart';
import '../delivery/reconsilation.dart';
import 'package:octo_image/octo_image.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:delivery_flutter_master/view/login/login_screen.dart';

class AccountFragment extends StatefulWidget {
  const AccountFragment({Key? key}) : super(key: key);
  @override
  State<AccountFragment> createState() => _AccountFragmentState();
}

class _AccountFragmentState extends State<AccountFragment> {
  String name="",mob="",email="";
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    getSP();
    super.initState();
  }
  void getSP() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("FNAME")! + " " + prefs.getString("LNAME")!;
      mob = prefs.getString("MOBILE")!;
      email = prefs.getString("EMAIL")!;
    });
  }
  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("Token");
    prefs.remove("Expiry");
    prefs.remove("Login");
    AnimatedSnackBar.material(
      duration: const Duration(seconds: 3),
      "Logout success",
      type: AnimatedSnackBarType.success,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    ).show(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              title: Text(VariableUtils.myAccount,
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
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 1,
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            width: _width,
                            child: Card(
                                surfaceTintColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                color: Colors.white,
                                child: Padding(
                                    padding: EdgeInsets.all(2),
                                    child: ListTile(
                                        leading: CircleAvatar(
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
                                        title: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(name,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              mob,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(email,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                    ))),
                          ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
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
                                      // InkWell(
                                      //   onTap: () {
                                      //
                                      //   },
                                      //   child: ListTile(
                                      //     leading: Container(
                                      //       width: 40,
                                      //       height: 40,
                                      //       decoration: BoxDecoration(
                                      //         shape: BoxShape.circle,
                                      //         color: Color(0xFFDEDEDE),
                                      //       ),
                                      //       child: Center(
                                      //         child: Icon(
                                      //           Icons.history,
                                      //           color: ColorUtils.black,
                                      //           size: 20,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     title: Text(
                                      //       "History",
                                      //       style: TextStyle(
                                      //         fontSize: 15,
                                      //         fontWeight: FontWeight.w500,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      // Divider(
                                      //   height: 1,
                                      // ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context, MaterialPageRoute(builder: (context) => ReconsilationScreen()));
                                        },
                                        child: ListTile(
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFFDEDEDE),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.assignment_returned_rounded,
                                                color: ColorUtils.black,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            "Reconciliation",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        height: 1,
                                      ),
                                      InkWell(
                                        onTap: () {

                                        },
                                        child: ListTile(
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFFDEDEDE),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.contact_support,
                                                color: ColorUtils.black,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            "Support",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          width: _width,
                          child: Card(
                              surfaceTintColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(2),
                                child: ListTile(
                                  onTap: (){
                                    _logout();
                                  },
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFDEDEDE),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.logout,
                                        color: ColorUtils.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    VariableUtils.logOut,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            VariableUtils.appVersion,
                            style: TextStyle(
                                color: Color(0xFF565656),
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                      ],
                    )),
              )
            ])));
  }
}