import 'package:flutter/material.dart';
import 'package:kotha/model/constance/color_constant.dart';
import 'package:kotha/view/widgets/balance/topup_plan_card_widget.dart';

class BalanceCardWidgets extends StatefulWidget {
  const BalanceCardWidgets({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<BalanceCardWidgets> createState() => _BalanceCardWidgetsState();
}

class _BalanceCardWidgetsState extends State<BalanceCardWidgets> {
  late TextEditingController topUpBalanceCtr;
  bool isTopUpValueInValid = false;
  bool inValidTopUpValue = false;
  List isSelected = [20]; //if the list contains the amount then its selected;
  bool isCustomPackage = false;
  Map customPackage = {};
  int customBalance = 0;
  Map<String, dynamic> topUpPlan = {
    "20": {"message": 200, "voice": 20, "video": 00},
    "30": {"message": 300, "voice": 30, "video": 00},
    "40": {"message": 400, "voice": 40, "video": 00},
    "50": {"message": 500, "voice": 50, "video": 10},
    "100": {"message": 1000, "voice": 100, "video": 20},
    "200": {"message": 2000, "voice": 200, "video": 40},
    "300": {"message": 3000, "voice": 300, "video": 60},
    "500": {"message": 5000, "voice": 500, "video": 100},
  };

  getPaackage(int tk) {
    final sms = tk * 10;
    final voice = tk * 1;
    int video = 0;

    if (tk >= 50) {
      video = tk ~/ 5;
    }
    return {"message": sms, "voice": voice, "video": video};
  }

  @override
  void initState() {
    topUpBalanceCtr = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    topUpBalanceCtr.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          color: Color(0xffF2F2F2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select your top up plan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: widget.size.width * 0.04,
              ),
            ),
            SizedBox(height: widget.size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    isCustomPackage = false;
                    isSelected
                        .clear(); //clean the list add index to identify if selected or not.
                    setState(() {
                      isSelected.add(20);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected.contains(20)
                          ? KColors.secondaryColor
                          : Colors.white,
                    ),
                    child: Text(
                      "৳ 20",
                      style: TextStyle(
                        fontSize: widget.size.width * 0.04,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    isCustomPackage = false;
                    isSelected
                        .clear(); //clean the list add index to identify if selected or not.
                    setState(() {
                      isSelected.add(30);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected.contains(30)
                          ? KColors.secondaryColor
                          : Colors.white,
                    ),
                    child: Text(
                      "৳ 30",
                      style: TextStyle(
                        fontSize: widget.size.width * 0.04,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    isCustomPackage = false;
                    isSelected
                        .clear(); //clean the list add index to identify if selected or not.
                    setState(() {
                      isSelected.add(40);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected.contains(40)
                          ? KColors.secondaryColor
                          : Colors.white,
                    ),
                    child: Text(
                      "৳ 40",
                      style: TextStyle(
                        fontSize: widget.size.width * 0.04,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    isCustomPackage = false;
                    isSelected
                        .clear(); //clean the list add index to identify if selected or not.
                    setState(() {
                      isSelected.add(50);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected.contains(50)
                          ? KColors.secondaryColor
                          : Colors.white,
                    ),
                    child: Text(
                      "৳ 50",
                      style: TextStyle(
                        fontSize: widget.size.width * 0.04,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    isCustomPackage = false;
                    isSelected
                        .clear(); //clean the list add index to identify if selected or not.
                    setState(() {
                      isSelected.add(100);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected.contains(100)
                          ? KColors.secondaryColor
                          : Colors.white,
                    ),
                    child: Text(
                      "৳ 100",
                      style: TextStyle(
                        fontSize: widget.size.width * 0.04,
                        //  fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: widget.size.height * 0.02),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    isCustomPackage = false;
                    isSelected
                        .clear(); //clean the list add index to identify if selected or not.
                    setState(() {
                      isSelected.add(200);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected.contains(200)
                          ? KColors.secondaryColor
                          : Colors.white,
                    ),
                    child: Text(
                      "৳ 200",
                      style: TextStyle(
                        fontSize: widget.size.width * 0.04,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widget.size.width * 0.01,
                ),
                GestureDetector(
                  onTap: () {
                    isCustomPackage = false;
                    isSelected
                        .clear(); //clean the list add index to identify if selected or not.
                    setState(() {
                      isSelected.add(300);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected.contains(300)
                          ? KColors.secondaryColor
                          : Colors.white,
                    ),
                    child: Text(
                      "৳ 300",
                      style: TextStyle(
                        fontSize: widget.size.width * 0.04,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widget.size.width * 0.01,
                ),
                GestureDetector(
                  onTap: () {
                    isCustomPackage = false;
                    isSelected
                        .clear(); //clean the list add index to identify if selected or not.
                    setState(() {
                      isSelected.add(500);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected.contains(500)
                          ? KColors.secondaryColor
                          : Colors.white,
                    ),
                    child: Text(
                      "৳ 500",
                      style: TextStyle(
                        fontSize: widget.size.width * 0.04,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // editable text field
                Flexible(
                  child: Container(
                    width: widget.size.width * 0.30,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: TextFormField(
                        controller: topUpBalanceCtr,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Enter amount",
                          border: InputBorder.none,
                        ),
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty) {
                            if (value.contains(".") ||
                                value.contains("-") ||
                                value.contains(",")) {
                              setState(() {
                                inValidTopUpValue = true;
                              });
                            } else {
                              if (int.parse(value) < 20) {
                                setState(() {
                                  isTopUpValueInValid = true;
                                  inValidTopUpValue = false;
                                });
                              } else {
                                // valid input in tk.
                                setState(() {
                                  isTopUpValueInValid = false;
                                  inValidTopUpValue = false;
                                  isSelected.clear();
                                  isCustomPackage = true;
                                  customPackage
                                      .addAll(getPaackage(int.parse(value)));
                                  customBalance = int.parse(value);
                                });
                              }
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (isTopUpValueInValid)
              const Text(
                "Recharge amount must be at least 20",
                style: TextStyle(
                  color: Color.fromARGB(255, 233, 76, 45),
                  fontWeight: FontWeight.w600,
                ),
              ),

            if (inValidTopUpValue)
              const Text(
                "Recharge amount can not contain any symbol.",
                style: TextStyle(
                  color: Color.fromARGB(255, 233, 76, 45),
                  fontWeight: FontWeight.w600,
                ),
              ),

            SizedBox(height: widget.size.height * 0.02),

            ///=================================>>> top up plan
            TopUpPlanCardWidget(
              size: widget.size,
              topUpData: isCustomPackage
                  ? customPackage
                  : topUpPlan[isSelected[0].toString()],
              balance: isCustomPackage ? customBalance : isSelected[0],
            )
          ],
        ),
      ),
    ));
  }
}
