import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/widgets/app/buttons.dart';
import 'package:rp_mobile/layers/ui/pages/plan/plan_empty.dart';
import 'package:rp_mobile/layers/ui/pages/plan/plan_fill.dart';


class PlansMain extends StatelessWidget {
  final bool isEmptyPlan;
  final int tabLength;
  final TabController tabController;

  PlansMain({Key key, @required this.isEmptyPlan, @required this.tabLength, @required this
      .tabController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _TabbedState(isEmptyPlan: isEmptyPlan, tabLength: tabLength,
        tabController:
    tabController);
  }
}

class _TabbedState extends StatelessWidget {
  final bool isEmptyPlan;
  final int tabLength;
  final TabController tabController;

  const _TabbedState({Key key, this.isEmptyPlan, this.tabLength, this
      .tabController}) : super
      (key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyleSelected = TextStyle(
      color: AppColors.darkGray,
      fontSize: 16,
//      fontFamily: GolosTextStyles.fontFamily,
      height: 1.25,
      letterSpacing: -0.1,
      fontWeight: FontWeight.w500,
    );
    TextStyle textStyleUnselected = TextStyle(
      color: AppColors.darkGray,
      fontSize: 16,
//      fontFamily: GolosTextStyles.fontFamily,
      height: 1.25,
      letterSpacing: -0.1,
      fontWeight: FontWeight.w400,
    );
    var tabsList = [Tab(child: Text("Предстоящие"))];
    if(tabLength == 2){
      tabsList.add(Tab(child: Text("Прошедшие")));
    }
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TabBar(
              indicatorPadding: EdgeInsets.all(0),
              controller: tabController,
              isScrollable: true,
              labelStyle: textStyleSelected,
              unselectedLabelStyle: textStyleUnselected,
              indicatorColor: AppColors.darkGray,
              labelPadding: EdgeInsets.symmetric(horizontal: 12),
              tabs: tabsList,
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  isEmptyPlan ?
                  PlanEmpty()
                  : PlanFill()
//                  SizedBox.shrink(),
                ],
              ),
            ),
          ],
        )
    );
  }
}



