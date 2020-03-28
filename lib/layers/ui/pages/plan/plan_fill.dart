import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/pages/plan/plan_map.dart';

//mock data
final List<ListCardData> mockData = [
  ListCardData(
    title: "Москва",
    placeText: "12 точек: ~15 часов",
    url: "https://api.russpass.iteco.dev/attach/image?file=content/19593758953.jpeg",
  ),
  ListCardData(
    title: "Санкт-Петербург",
    placeText: "10 точек: ~18 часов",
    url:"https://api.russpass.iteco.dev/attach/image?file=content/1504352252.png",
  ),
  ListCardData(
    title: "Камчатка",
    placeText: "20 точек: ~38 часов",
    url: "https://api.russpass.iteco.dev/attach/image?file=content/1910165911.jpg",
  ),
];

class PlanFill extends StatelessWidget {
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
                Navigator.of(context).push(PlanMapPage.route(listCardData: mockData[index]));
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
  });

  final double borderRadius = 12;

  @override
  Widget build(BuildContext context) {

    return Container(
      child: GestureDetector(
        onTap: onTap,
        child:
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Container(
                margin: EdgeInsets.only(top: 16),
                height: 188,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(4.0),
                      topLeft: Radius.circular(4.0)),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(data.url),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundGray,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4.0),
                      bottomRight: Radius.circular(4.0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(data.title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: NamedFontWeight.bold,
                          color: AppColors.darkGray),),
                    Text(data.placeText,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: NamedFontWeight.regular,
                          color: AppColors.mediumGray),)
                  ],
                ),
              )
            ]
        )
      ),
    );
  }
}

class ListCardData {
  final String title;
  final String placeText;
  final String url;

  ListCardData({
    this.title,
    this.placeText,
    this.url,
  });
}
