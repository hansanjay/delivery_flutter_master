import 'package:delivery_flutter_master/models/reconciliation_model.dart';
import 'package:flutter/material.dart';
import '../../utils/color_utils.dart';
import '../../utils/variable_utils.dart';

class ReconsilationModal extends StatelessWidget {
  final DailyItems orders;
  const ReconsilationModal({Key? key, required this.orders});

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
                "Items",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(Icons.close, size: 30),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              title: Text(
                "Product Name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              trailing: Text(
                "Quantity",
                style: TextStyle(fontSize: 10, color: ColorUtils.black2D),
              ),
            ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = orders.items[index];
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.prdTitle,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Row(
                            children: [
                              Text(
                                "1 ltr",
                                style: TextStyle(
                                    fontSize: 10, color: ColorUtils.black2D),
                              ),
                            ],
                          ),
                        ],
                      ),
                      leading: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Text(
                        "${item.pendingQty}",
                        style:
                            TextStyle(fontSize: 10, color: ColorUtils.black2D),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                        thickness: 1,
                        color: Colors.black12,
                      ),
                  itemCount: orders.items.length),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
