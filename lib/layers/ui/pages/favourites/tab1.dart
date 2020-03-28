import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/pages/favourites/favourites_detailed_page.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';

//mock data
final List<ListCardData> mockData = [
  ListCardData(
    title: "Моя Москва",
    placeNumber: 30,
    urls: [
      "https://api.russpass.iteco.dev/attach/image?file=content/4672835612.jpg",
      "https://api.russpass.iteco.dev/attach/image?file=content/12953898024.jpg",
      "https://api.russpass.iteco.dev/attach/image?file=content/4672835628.jpg",
    ],
  ),
  ListCardData(
    title: "Прогулка",
    placeNumber: 12,
    urls: [
      "https://api.russpass.iteco.dev/attach/image?file=content/504224405.jpg",
      "https://api.russpass.iteco.dev/attach/image?file=content/2121620071.jpg",
      "https://api.russpass.iteco.dev/attach/image?file=content/51345961.jpg",
    ],
  ),
  ListCardData(
    title: "Парки",
    placeNumber: 5,
    urls: [
      "https://api.russpass.iteco.dev/attach/image?file=content/4765187730.jpg",
      "https://api.russpass.iteco.dev/attach/image?file=content/4949891928.jpg",
      "https://api.russpass.iteco.dev/attach/image?file=content/1702139669.jpg",
    ],
  ),
];

class FavouritesTabView1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => _ListCard(
              data: mockData[index],
              onTap: () {
                print("Tapped: ${mockData[index].title}");
                Navigator.of(context)
                    .push(FavouritesDetailedPage.route(listCardData: mockData[index]));
              },
            ),
            itemCount: mockData.length,
          ),
        ),
      ],
    );
  }
}

class _ListCard extends StatelessWidget {
  final ListCardData data;
  final Function onTap;

  _ListCard({
    Key key,
    @required this.data,
    this.onTap,
  }) : assert(data.urls.length > 0 && data.urls.length < 4, 'Accepted only 3 picture url');

  final double borderRadius = 12;

  @override
  Widget build(BuildContext context) {

    return Container(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 8),
            Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.5,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _CustomContainer(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(borderRadius),
                            bottomLeft: Radius.circular(borderRadius),
                          ),
                          url: data.urls[0],
                        ),
                        flex: 2,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: _CustomContainer(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(borderRadius),
                                ),
                                url: data.urls[1],
                              ),
                            ),
                            SizedBox(height: 4),
                            Expanded(
                              child: _CustomContainer(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(borderRadius),
                                ),
                                url: data.urls[2],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 8),
            Text(
              data.title,
              style: GolosTextStyles.h3size16(golosTextColors: GolosTextColors.grayDarkVery),
            ),
            SizedBox(height: 4),
            Text(
              "${data.placeNumber} точек",
              style:
                  GolosTextStyles.mainTextSize16(golosTextColors: GolosTextColors.grayDark),
            ),
            SizedBox(height: 8),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class _CustomContainer extends StatelessWidget {
  final BorderRadius borderRadius;
  final String url;

  const _CustomContainer({Key key, @required this.borderRadius, @required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
        return Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: imageProvider,
            ),
          ),
        );
      },
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

class ListCardData {
  final String title;
  final int placeNumber;
  final List<String> urls;

  ListCardData({
    this.title,
    this.placeNumber,
    this.urls,
  });
}
