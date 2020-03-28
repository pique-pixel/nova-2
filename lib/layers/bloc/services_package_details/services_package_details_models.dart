import 'package:equatable/equatable.dart';

abstract class SectionModel extends Equatable {}

class HeaderSection extends SectionModel {
  final String thumbnailUrl;
  final String title;
  final List<SubTitle> subTitle;
  final List<CityModel> cities;

  HeaderSection({
    this.thumbnailUrl,
    this.title,
    this.subTitle,
    this.cities = const [],
  })  : assert(thumbnailUrl != null),
        assert(title != null),
        assert(subTitle != null),
        assert(cities != null);

  @override
  List<Object> get props => [title, subTitle, cities];
}

class PackageConstitutionSection extends SectionModel {
  final String title;
  final List<PackageConstitutionItem> items;

  PackageConstitutionSection({
    this.title,
    this.items = const [],
  })  : assert(title != null),
        assert(items != null);

  @override
  List<Object> get props => [title, items];
}

class PackageConstitutionItem extends Equatable {
  final String title;
  final String description;

  PackageConstitutionItem({this.title, this.description})
      : assert(title != null),
        assert(description != null);

  @override
  List<Object> get props => [title, description];
}

class ActivitiesSection extends SectionModel {
  final String title;
  final String description;
  final List<ActivityFilter> filters;
  final List<ActivityModel> activities;
  final bool isLoadedAllItems;

  ActivitiesSection({
    this.title,
    this.filters,
    this.activities = const [],
    this.description,
    this.isLoadedAllItems = false,
  })  : assert(title != null),
        assert(filters != null),
        assert(activities != null),
        assert(description != null),
        assert(isLoadedAllItems != null);

  @override
  List<Object> get props => [
        title,
        description,
        filters,
        activities,
        isLoadedAllItems,
      ];

  @override
  String toString() {
    return '$ActivitiesSection($title, $description, $filters, $activities, '
        '$isLoadedAllItems)';
  }

  ActivitiesSection copyWith({
    title,
    filters,
    activities,
    description,
    isExpanded,
  }) {
    return ActivitiesSection(
      title: title ?? this.title,
      filters: filters ?? this.filters,
      activities: activities ?? this.activities,
      description: description ?? this.description,
      isLoadedAllItems: isExpanded ?? this.isLoadedAllItems,
    );
  }
}

class ActivityModel extends Equatable {
  final String thumbnailUrl;
  final String title;

  ActivityModel({this.thumbnailUrl, this.title})
      : assert(thumbnailUrl != null),
        assert(title != null);

  @override
  List<Object> get props => [thumbnailUrl, title];

  @override
  String toString() {
    return '$ActivityModel($thumbnailUrl, $title)';
  }
}

class ActivityFilter extends Equatable {
  final String ref;
  final String title;
  final bool isActive;

  ActivityFilter({this.ref, this.title, this.isActive = false})
      : assert(title != null),
        assert(isActive != null);

  @override
  List<Object> get props => [title, isActive];

  ActivityFilter copyWith({ref, title, isActive}) {
    return ActivityFilter(
      ref: ref ?? this.ref,
      title: title ?? this.title,
      isActive: isActive ?? this.isActive,
    );
  }
}

enum SubTitleGrade {
  normal,
  grade1,
}

class SubTitle extends Equatable {
  final String data;
  final SubTitleGrade subTitleGrade;

  SubTitle(this.data, [this.subTitleGrade = SubTitleGrade.normal])
      : assert(data != null),
        assert(subTitleGrade != null);

  @override
  List<Object> get props => [data, subTitleGrade];
}

class CityModel extends Equatable {
  final String ref;
  final String name;
  final bool isSelected;

  CityModel({this.ref, this.name, this.isSelected})
      : assert(ref != null),
        assert(name != null),
        assert(isSelected != null);

  @override
  List<Object> get props => [name, isSelected];
}
