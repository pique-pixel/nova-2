import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rp_mobile/layers/ui/pages/favourites/favourites_page.dart';
import 'package:rp_mobile/layers/ui/pages/routes/routes.dart';
import 'package:rp_mobile/layers/ui/pages/plan/plans.dart';
import 'package:rp_mobile/layers/ui/pages/faq.dart';

class ExplorerPage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => ExplorerPage());

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final _url = 'https://web.dev.russpass.ru/';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      theme: AppThemes.materialAppTheme(),
      bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.explorer),
      body: WebView(
        initialUrl: _url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith("russpass://")) {
            RegExp exp = new RegExp(r"(russpass://)");
            String str = request.url;
            String res = str.replaceAll(exp, '');
            switch(res){
              case "favourites":
                Navigator.of(context).pushReplacement(FavouritesPage.route());
                break;
              case "plan":
                Navigator.of(context).pushReplacement(PlansPage.route());
                break;
              case "map":
                Navigator.of(context).pushReplacement(RoutesPage.route());
                break;
              case "faq":
                Navigator.of(context).pushReplacement(FaqPage.route());
                break;
            }
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        }
      ),
    );
  }
}
