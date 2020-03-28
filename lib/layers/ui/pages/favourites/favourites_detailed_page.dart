import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rp_mobile/layers/bloc/routes/routes_models.dart';
import 'package:rp_mobile/layers/services/geo_objects.dart';
import 'package:rp_mobile/layers/ui/pages/favourites/tab1.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../themes.dart';

class FavouritesDetailedPage extends StatefulWidget {
  final ListCardData listCardData;

  const FavouritesDetailedPage({Key key, this.listCardData}) : super(key: key);

  static route({ListCardData listCardData}) => MaterialPageRoute(
        builder: (context) => FavouritesDetailedPage(listCardData: listCardData),
      );

  @override
  _FavouritesDetailedPageState createState() => _FavouritesDetailedPageState();
}

class _FavouritesDetailedPageState extends State<FavouritesDetailedPage> {
  YandexMapController yandexMapController;
  YandexMap _yandexMap;
  SheetController sheetController = SheetController();
  PanelController panelController = PanelController();

  double _initialLocationHeight;
  double _ratioOfOpenPanel = 0.55;
  double _panelHeightOpen;

  // NOTE(Kazbek): 88 here is defined height of the _Header widget
  // This needed to show only Header widget in collapsed mode of slider
  double _panelHeightClosed = 88;
  double _sliderValue = 1;
  double screenHeight;
  GeoObjectsService geoObjectsService;
  List<GeoObject> geoObjectList;
  GeoObject myLocationGeo;
  Point myLocationPoint;

  bool showLoading = true;

  @override
  void initState() {
    super.initState();
    geoObjectsService = GetIt.instance<GeoObjectsService>();
    _yandexMap = YandexMap(
      onMapCreated: (controller) async {
        print("asd");
        yandexMapController = controller;
        geoObjectsService.setYandexMapController(yandexMapController);
        myLocationPoint = await geoObjectsService.getCurrentGeoLocation();
        myLocationGeo = GeoObject(
          ref: "0",
          title: "My Location",
          latitude: myLocationPoint.latitude,
          longitude: myLocationPoint.longitude,
        );
        geoObjectList = await geoObjectsService.getMapGeoObjects();
        await geoObjectsService.moveCameraToBoundary(geoObjectList, false);
        _stopLoading();
      },
    );
  }

  void _stopLoading() async {
    setState(() {
      showLoading = false;
    });
  }

  _slidingFunction(double value) {
    setState(() {
      _sliderValue = value;
    });
  }

  double zoomButtonsTopCalculatingFunction() {
    return (screenHeight - (_sliderValue * (_panelHeightOpen - _panelHeightClosed))) / 2 -
        _panelHeightClosed;
  }

  double posButtonsTopCalculatingFunction() {
    return _initialLocationHeight + (1 - _sliderValue) * (_panelHeightOpen - _panelHeightClosed);
  }

  void _initVariablesForCalculation(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    screenHeight = mediaQuery.size.height;
    _panelHeightOpen = screenHeight * _ratioOfOpenPanel;
    _initialLocationHeight =
        230 * ((screenHeight - _panelHeightClosed) / (683 - _panelHeightClosed));
  }

  @override
  Widget build(BuildContext context) {
    _initVariablesForCalculation(context);

    return AppScaffold(
      theme: AppThemes.materialAppTheme(),
      body: Stack(
        children: <Widget>[
          SlidingUpPanel(
            defaultPanelState: PanelState.OPEN,
            isDraggable: true,
            slideDirection: SlideDirection.UP,
            panelSnapping: true,
            body: _Body(
              yandexMap: _yandexMap,
              showLoading: showLoading,
            ),
            panelBuilder: (ScrollController sC) => SlidingPanel(
              scrollController: sC,
              heightOfHeader: _panelHeightClosed,
            ),
            controller: panelController,
            color: Colors.white,
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            onPanelSlide: _slidingFunction,
            parallaxEnabled: true,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            parallaxOffset: 0.50,
          ),
          Positioned(
            top: 26,
            left: 16,
            child: _BackButton(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: 26,
            right: 16,
            child: _SearchButton(
              onTap: () async {
                print("Make Search");
              },
            ),
          ),
          Positioned(
            top: zoomButtonsTopCalculatingFunction(),
            right: 16,
            child: _ZoomButtons(
              onTapZoomIn: () async {
                print("ZoomIN");
                await yandexMapController.zoomIn();
              },
              onTapZoomOut: () async {
                print("ZoomOUT");
                await yandexMapController.zoomOut();
              },
            ),
          ),
          Positioned(
            top: posButtonsTopCalculatingFunction(),
            right: 16,
            child: _MyLocationButton(
              onTap: () async {
                print("Go to My location");
                myLocationPoint = await geoObjectsService.getCurrentGeoLocation();
                await yandexMapController.move(
                  point: myLocationPoint,
                  animation: MapAnimation(duration: 1, smooth: true),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final bool showLoading;
  final YandexMap yandexMap;

  const _Body({
    Key key,
    @required this.showLoading,
    @required this.yandexMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        yandexMap,
        showLoading
            ? Container(
                constraints: BoxConstraints.expand(),
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()),
              )
            : Container(),
      ],
    );
  }
}

class _ZoomButtons extends StatelessWidget {
  final Function onTapZoomIn;
  final Function onTapZoomOut;

  const _ZoomButtons({Key key, this.onTapZoomIn, this.onTapZoomOut}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _ButtonBaseForMap(
          onTap: onTapZoomIn,
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 30,
          ),
        ),
        SizedBox(height: 4),
        _ButtonBaseForMap(
          onTap: onTapZoomOut,
          child: Icon(
            Icons.remove,
            color: Colors.black,
            size: 30,
          ),
        ),
      ],
    );
  }
}

class _ButtonBaseForMap extends StatelessWidget {
  final Widget child;
  final Function onTap;

  const _ButtonBaseForMap({Key key, @required this.child, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      backgroundColor: Colors.white,
      onPressed: onTap,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      mini: true,
      child: child,
    );
  }
}

class SlidingPanel extends StatelessWidget {
  final ScrollController scrollController;
  final double heightOfHeader;

  const SlidingPanel({
    Key key,
    @required this.scrollController,
    @required this.heightOfHeader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      constraints: BoxConstraints.tightFor(),
      child: Column(
        children: <Widget>[
          _Header(heightOfHeader: heightOfHeader),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: mockData.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return _BottomSliderSheetCard(
                    bottomSliderSheetData: mockData[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final Function onTap;

  const _BackButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ButtonBaseForMap(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 2),
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  final Function onTap;

  const _SearchButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ButtonBaseForMap(
      onTap: onTap,
      child: Image.asset(
        "images/search_icon.png",
        scale: 0.9,
      ),
    );
  }
}

class _MyLocationButton extends StatelessWidget {
  final Function onTap;

  const _MyLocationButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ButtonBaseForMap(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 2, top: 2),
        child: Image.asset(
          'images/my_location.png',
          color: Colors.black,
          alignment: Alignment.center,
          scale: 0.95,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final double heightOfHeader;

  const _Header({Key key, @required this.heightOfHeader}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: heightOfHeader,
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _GrayMark(),
          _HeaderTitle(),
        ],
      ),
    );
  }
}

class _GrayMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      height: 4,
      width: 32,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Москва",
                style: GolosTextStyles.h2size20(golosTextColors: GolosTextColors.grayDarkVery),
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.more_horiz,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
          Text(
            "20 собыйтий, 40 мест",
            style: GolosTextStyles.additionalSize14(golosTextColors: GolosTextColors.grayDark),
          ),
          SizedBox(height: 8),
          Divider(
            height: 0,
            color: Colors.black26,
          )
        ],
      ),
    );
  }
}

class BottomSliderSheetData {
  final String title;
  final String subtitle;
  final String urlPic;

  BottomSliderSheetData({this.title, this.subtitle, this.urlPic});
}

class _BottomSliderSheetCard extends StatelessWidget {
  final BottomSliderSheetData bottomSliderSheetData;

  const _BottomSliderSheetCard({Key key, this.bottomSliderSheetData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageSide = 80;
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: imageSide,
                width: imageSide,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(bottomSliderSheetData.urlPic),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      bottomSliderSheetData.title,
                      style: TextStyle(
                        color: GolosTextColors.grayDarkVery,
                        fontWeight: FontWeight.w500,
                        fontFamily: GolosTextStyles.fontFamily,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      bottomSliderSheetData.subtitle,
                      style: GolosTextStyles.additionalSize14(
                          golosTextColors: GolosTextColors.grayDark),
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.more_horiz,
                  color: Colors.black38,
                ),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Divider(
            height: 0,
            color: Colors.black26,
          ),
        ],
      ),
    );
  }
}

//mock Data
final List<BottomSliderSheetData> mockData = [
  BottomSliderSheetData(
    title: "Затейливая роспись глав Храма Василия Блаженного",
    subtitle: "Москва, Красная площадь",
    urlPic: "https://api.russpass.iteco.dev/attach/image?file=content/4672835612.jpg",
  ),
  BottomSliderSheetData(
    title: "Канатная дорога на Воробьевых горах",
    subtitle: "Москва, Ул. Косыгина, д. 28",
    urlPic: "https://api.russpass.iteco.dev/attach/image?file=content/4672835640.jpg",
  ),
  BottomSliderSheetData(
    title: "Музей-заповедник Царицино",
    subtitle: "Москва, ул. Дольская, д. 1",
    urlPic: "https://api.russpass.iteco.dev/attach/image?file=content/799417174.jpg",
  ),
  BottomSliderSheetData(
    title: "Смотровая площадка телебашни Останкино",
    subtitle: "Москва, пр-т Мира, 119",
    urlPic: "https://api.russpass.iteco.dev/attach/image?file=content/800340695.jpg",
  ),
  BottomSliderSheetData(
    title: "Затейливая роспись глав Храма Василия Блаженного",
    subtitle: "Москва, Красная площадь",
    urlPic: "https://api.russpass.iteco.dev/attach/image?file=content/4672835612.jpg",
  ),
  BottomSliderSheetData(
    title: "Затейливая роспись глав Храма Василия Блаженного",
    subtitle: "Москва, Красная площадь",
    urlPic: "https://api.russpass.iteco.dev/attach/image?file=content/4672835612.jpg",
  ),
];
