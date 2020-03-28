import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';

class FavouritesTabView2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "Туристические пакеты",
          style: GolosTextStyles.h2size20(golosTextColors: GolosTextColors.grayDarkVery),
        ),
      ),
    );
  }
}
