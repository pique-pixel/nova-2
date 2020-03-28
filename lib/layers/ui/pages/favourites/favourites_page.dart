import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/pages/favourites/body.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';

import 'package:rp_mobile/layers/ui/themes.dart';

class FavouritesPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => FavouritesPage());

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> with SingleTickerProviderStateMixin {
  bool isEmptyMain = true;
  TabController tabContoller;

  @override
  void initState() {
    super.initState();
    tabContoller = TabController(length: 3, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      theme: AppThemes.materialAppTheme(),
      bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.favourites),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            SizedBox(height: 36),
            _Header(
              onPressed: () {
                print("Pressed Создать");
                setState(() {
                  isEmptyMain = !isEmptyMain;
                });
              },
            ),
            Expanded(
              child: FavouritesBody(
                isEmpty: isEmptyMain,
                tabController: tabContoller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Function onPressed;

  const _Header({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Избранное",
            style: GolosTextStyles.h1size30(golosTextColors: GolosTextColors.grayDarkVery),
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
      color: AppColors.white80,
      child: Text(
        "Создать",
        style: GolosTextStyles.buttonStyleSize14(golosTextColors: GolosTextColors.grayDarkVery),
      ),
      onPressed: onPressed,
    );
  }
}
