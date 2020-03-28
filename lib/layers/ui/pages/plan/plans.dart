import 'package:flutter/material.dart';
import 'package:division/division.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/widgets/app/buttons.dart';
import 'package:rp_mobile/layers/ui/pages/plan/plans_main.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';

import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

class PlansPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => PlansPage());

  @override
  _PlansPageState createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> with SingleTickerProviderStateMixin {
  //todo если сделать isEmptyMain и isEmptyPlan true будет пустая страница "У
  // вас пока нет поездок"
  bool isEmptyMain = false;
  bool isEmptyPlan = false;
  bool addPlan = false;
  int tabLength = 1;
  TabController tabContoller;
  SolidController solidController = SolidController();

  @override
  void initState() {
    super.initState();
    tabContoller = TabController(length: tabLength, initialIndex: 0, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        safeArea: false,
        theme: AppThemes.materialAppTheme(),
      body: SafeArea(
        child: Scaffold(
          bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.plan),
          body: Column(
              children: <Widget>[
                SizedBox(height: 36),
                _Header(
                  onPressed: () {
                    setState(() {
                      addPlan = true;
//                      isEmptyMain = !isEmptyMain;
                    });
                  },
                ),
                Expanded(
                  child:
                  Stack(
                      children: <Widget>[
                        isEmptyMain ?
                        _NoContentState()
                        : SizedBox.shrink(),

                        !isEmptyMain ?
                        PlansMain(
                          isEmptyPlan: isEmptyPlan,
                          tabLength: tabLength,
                          tabController: tabContoller,
                        )
                        : SizedBox.shrink(),
                  ]
                )
                ),
                /*Expanded(
                  child: PlansMain(
                    isEmpty: isEmptyMain,
                    tabController: tabContoller,
                  ),
                ),*/
              ],
          ),
          bottomSheet: addPlan ?
          buildNamePlan()
          : SizedBox.shrink(),
        ),
      ),
    );
  }


  Widget buildNamePlan() {
    return SolidBottomSheet(
      onHide: () {
        setState(() {
          addPlan = false;
          isEmptyPlan = false;
        });
      },
      controller: solidController,
      draggableBody: true,

//      elevation: 8,
      showOnAppear: true,
      minHeight: 0,
      maxHeight: 180,
      headerBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkGray.withOpacity(.2),
              blurRadius: 6.0, // soften the shadow
              spreadRadius: 0, //extend the shadow
              offset: Offset(
                0,
                -6,
              ),
            )
          ],
        ),
        height: 40,
        child: Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: rgba(203, 205, 204, 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
      body:
      Container(
          color: AppColors.white,
          child: SingleChildScrollView(
              child:
              Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 12),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child:
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child:
                              Text(
                                'Создать план поездки',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: NamedFontWeight.bold,
                                    color: AppColors.darkGray),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child:
                      Row(
                          children: <Widget>[
                            Expanded(
                              child:
                              TextFormField(
                                keyboardType: TextInputType.text,
                                onSaved: (value) {},
                              ),
                            ),
                            SizedBox(width: 4),
                            _CancelButton(),
                          ]
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child:
                      BigRedRoundedButton(
                        text: "Продолжить",
                        onPressed: () {
                          print("add plan");
                          setState(() {
                            addPlan = false;
                            isEmptyPlan = true;
                            isEmptyMain = false;
                          });
                        },
                      ),
                    )
                  ]))
      ),
    );
  }
}

class _NoContentState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "У вас пока нет поездок",
                style: TextStyle(
                    fontWeight: NamedFontWeight.bold,
                    fontSize: 20,
                    color: AppColors.darkGray
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: 230,
                child: RichText(
                  softWrap: true,
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: AppColors.darkGray,
                      height: 1.3,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: "Нажмите на ",
                      ),
                      WidgetSpan(
                        child: Icon(Icons.add,
                          color: AppColors.primaryRed,
                          size: 24,
                        ),
                      ),
                      TextSpan(
                        text: ", что бы добавить места или события в план "
                            "поездки",
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        BigRedRoundedButton(
          text: "Добавить новые места",
          onPressed: () {

          },
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final Function onPressed;

  const _Header({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Поездки",
            style: TextStyle(
                fontWeight: NamedFontWeight.bold,
                fontSize: 24,
                color: AppColors.darkGray
            ),
          ),
          _ButtonCreate(
            text: "Создать",
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

class _ButtonCreate extends StatelessWidget {
  final String text;
  final Function onPressed;

  const _ButtonCreate({Key key, @required this.text, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: AppColors.backgroundGray,
      child: Text(
        "Создать",
        style: TextStyle(
            fontWeight: NamedFontWeight.bold,
            fontSize: 14,
            color: AppColors.darkGray
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class _CancelButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CancelButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,),
        child:
        Align(
          alignment: Alignment.topCenter,
          child:
          SizedBox(
            height: 24.0,
            width: 24.0,
            child:
            IconButton(
              padding: EdgeInsets.all(0),
              icon: Icon(Icons.cancel, color: Colors.grey.withOpacity(0.6)),
              onPressed: () {

              },
            ),
          ),
        ),
      );
  }
}

