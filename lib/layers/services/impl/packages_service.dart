import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/bloc/services_package_details/services_package_details_models.dart';
import 'package:rp_mobile/layers/bloc/services_package_list/services_package_list_models.dart';
import 'package:rp_mobile/layers/services/packages_service.dart';
import 'package:rp_mobile/utils/future.dart';

class PackagesServiceImpl implements PackagesService {
  @override
  Future<Page<PackageItemModel>> getPackageItems([int page = 1]) async {
    await delay(1000);

    if (page == 1) {
      return Page(
        data: [
          PackageItemModel(
            ref: '1',
            title: 'Москва и Санкт-Петербург на 3 дня',
            thumbnailUrl: 'https://picsum.photos/800',
            type: 'Взрослый',
            untilDate: 'Получить до 26 декабря',
            soonWillEnd: true,
            openQRCode: false,
          ),
          PackageItemModel(
            ref: '2',
            title: 'Москва на 4 дня',
            thumbnailUrl: 'https://picsum.photos/900',
            type: 'Взрослый',
            untilDate: 'Получить до 28 декабря',
            soonWillEnd: false,
            openQRCode: true,
          ),
          PackageItemModel(
            ref: '3',
            title: 'Новосибирск на 5 дня',
            thumbnailUrl: 'https://picsum.photos/700',
            type: 'Взрослый',
            untilDate: 'Получить до 18 января',
            soonWillEnd: false,
            openQRCode: true,
          ),
        ],
        nextPage: 2,
      );
    } else if (page == 2) {
      return Page(
        nextPage: null,
        data: [
          PackageItemModel(
            ref: '4',
            title: 'Москва и Санкт-Петербург на 3 дня',
            thumbnailUrl: 'https://picsum.photos/1000',
            type: 'Взрослый',
            untilDate: 'Получить до 26 декабря',
            soonWillEnd: true,
            openQRCode: false,
          ),
          PackageItemModel(
            ref: '5',
            title: 'Москва на 4 дня',
            thumbnailUrl: 'https://picsum.photos/850',
            type: 'Взрослый',
            untilDate: 'Получить до 28 декабря',
            soonWillEnd: false,
            openQRCode: true,
          ),
          PackageItemModel(
            ref: '6',
            title: 'Новосибирск на 5 дня',
            thumbnailUrl: 'https://picsum.photos/750',
            type: 'Взрослый',
            untilDate: 'Получить до 18 января',
            soonWillEnd: false,
            openQRCode: true,
          ),
        ],
      );
    } else {
      return Page(data: [], nextPage: null);
    }
  }

  @override
  Future<List<SectionModel>> getPackageDetails(String ref) async {
    await delay(1000);
    final packageConstitution = PackageConstitutionSection(
      title: 'В составе пакета',
      items: [
        PackageConstitutionItem(
          title: 'Аэроэкспесс 1',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 2',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 3',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 4',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 5',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 6',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 7',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 8',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
      ],
    );

    final activities = ActivitiesSection(
      title: 'Локации и активности',
      description: 'Москва многолика. Царица, воплощающая русскую душу с ее '
          'широтой и щедростью. Как радушная хозяйка, она удивляет '
          'уютом старых улочек, тишиной парков, древней, с любовью '
          'оберегаемой архитектурой. В облике светской дамы проведет на '
          'выставку, в музей, на театральную премьеру. ',
      filters: [
        ActivityFilter(ref: 'f1', title: 'filter 1'),
        ActivityFilter(ref: 'f2', title: 'filter 2'),
        ActivityFilter(ref: 'f3', title: 'filter 3'),
        ActivityFilter(ref: 'f4', title: 'filter 4'),
        ActivityFilter(ref: 'f5', title: 'filter 5'),
        ActivityFilter(ref: 'f6', title: 'filter 6'),
      ],
      activities: [
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/400',
        ),
        ActivityModel(
          title: 'Московский зоопарк',
          thumbnailUrl: 'https://picsum.photos/500',
        ),
        ActivityModel(
          title: 'Музей археологии Москвы',
          thumbnailUrl: 'https://picsum.photos/600',
        ),
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/650',
        ),
      ],
    );

    switch (ref) {
      case '1':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/800',
            title: 'Москва и Санкт-Петербург на 3 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(ref: '1', name: 'Москва', isSelected: true),
              CityModel(ref: '2', name: 'Санкт петербург', isSelected: false),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '2':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/900',
            title: 'Москва на 4 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Получить до 28 декабря', SubTitleGrade.grade1),
            ],
            cities: [
              CityModel(ref: '1', name: 'Москва', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '3':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/700',
            title: 'Новосибирск на 5 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(ref: '1', name: 'Новосибирск', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '4':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/1000',
            title: 'Москва и Санкт-Петербург на 3 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(ref: '1', name: 'Москва', isSelected: true),
              CityModel(ref: '2', name: 'Санкт петербург', isSelected: false),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '5':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/850',
            title: 'Москва на 4 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Получить до 28 декабря', SubTitleGrade.grade1),
            ],
            cities: [
              CityModel(ref: '1', name: 'Москва', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '6':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/750',
            title: 'Новосибирск на 5 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(ref: '1', name: 'Новосибирск', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      default:
        throw AssertionError();
    }
  }

  @override
  Future<ActivitiesSection> getAllPackageActivities(
    String ref, [
    List<String> filter = const [],
  ]) async {
    await delay(1000);
    return ActivitiesSection(
      isLoadedAllItems: true,
      title: 'Локации и активности',
      description: 'Москва многолика. Царица, воплощающая русскую душу с ее '
          'широтой и щедростью. Как радушная хозяйка, она удивляет '
          'уютом старых улочек, тишиной парков, древней, с любовью '
          'оберегаемой архитектурой. В облике светской дамы проведет на '
          'выставку, в музей, на театральную премьеру. ',
      filters: [
        ActivityFilter(
          ref: 'f1',
          title: 'filter 1',
          isActive: filter.contains('f1'),
        ),
        ActivityFilter(
          ref: 'f2',
          title: 'filter 2',
          isActive: filter.contains('f2'),
        ),
        ActivityFilter(
          ref: 'f3',
          title: 'filter 3',
          isActive: filter.contains('f3'),
        ),
        ActivityFilter(
          ref: 'f4',
          title: 'filter 4',
          isActive: filter.contains('f4'),
        ),
        ActivityFilter(
          ref: 'f5',
          title: 'filter 5',
          isActive: filter.contains('f5'),
        ),
        ActivityFilter(
          ref: 'f6',
          title: 'filter 6',
          isActive: filter.contains('f6'),
        ),
      ],
      activities: [
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/400',
        ),
        ActivityModel(
          title: 'Московский зоопарк',
          thumbnailUrl: 'https://picsum.photos/500',
        ),
        ActivityModel(
          title: 'Музей археологии Москвы',
          thumbnailUrl: 'https://picsum.photos/600',
        ),
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/650',
        ),
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/400',
        ),
        ActivityModel(
          title: 'Московский зоопарк',
          thumbnailUrl: 'https://picsum.photos/500',
        ),
        ActivityModel(
          title: 'Музей археологии Москвы',
          thumbnailUrl: 'https://picsum.photos/600',
        ),
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/650',
        ),
      ],
    );
  }

  @override
  Future<ActivitiesSection> filterPackageActivities(
    String ref,
    List<String> filters,
    bool loadAllActivities,
  ) async {
    await delay(1000);
    return ActivitiesSection(
      isLoadedAllItems: true,
      title: 'Локации и активности',
      description: 'Москва многолика. Царица, воплощающая русскую душу с ее '
          'широтой и щедростью. Как радушная хозяйка, она удивляет '
          'уютом старых улочек, тишиной парков, древней, с любовью '
          'оберегаемой архитектурой. В облике светской дамы проведет на '
          'выставку, в музей, на театральную премьеру. ',
      filters: [
        ActivityFilter(
          ref: 'f1',
          title: 'filter 1',
          isActive: filters.contains('f1'),
        ),
        ActivityFilter(
          ref: 'f2',
          title: 'filter 2',
          isActive: filters.contains('f2'),
        ),
        ActivityFilter(
          ref: 'f3',
          title: 'filter 3',
          isActive: filters.contains('f3'),
        ),
        ActivityFilter(
          ref: 'f4',
          title: 'filter 4',
          isActive: filters.contains('f4'),
        ),
        ActivityFilter(
          ref: 'f5',
          title: 'filter 5',
          isActive: filters.contains('f5'),
        ),
        ActivityFilter(
          ref: 'f6',
          title: 'filter 6',
          isActive: filters.contains('f6'),
        ),
      ],
      activities: [
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/400',
        ),
        ActivityModel(
          title: 'Московский зоопарк',
          thumbnailUrl: 'https://picsum.photos/500',
        ),
        ActivityModel(
          title: 'Музей археологии Москвы',
          thumbnailUrl: 'https://picsum.photos/600',
        ),
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/650',
        ),
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/400',
        ),
        ActivityModel(
          title: 'Московский зоопарк',
          thumbnailUrl: 'https://picsum.photos/500',
        ),
        ActivityModel(
          title: 'Музей археологии Москвы',
          thumbnailUrl: 'https://picsum.photos/600',
        ),
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/650',
        ),
      ],
    );
  }

  @override
  Future<List<SectionModel>> getPackageDetailsForCity(
    String ref,
    String cityRef,
  ) async {
    await delay(1000);
    final packageConstitution = PackageConstitutionSection(
      title: 'В составе пакета',
      items: [
        PackageConstitutionItem(
          title: 'Аэроэкспесс 1',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 2',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 3',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 4',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 5',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 6',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 7',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
        PackageConstitutionItem(
          title: 'Аэроэкспесс 8',
          description: 'В Шереметьево, Домодедово, Внуково и обратно',
        ),
      ],
    );

    final activities = ActivitiesSection(
      title: 'Локации и активности',
      description: 'Москва многолика. Царица, воплощающая русскую душу с ее '
          'широтой и щедростью. Как радушная хозяйка, она удивляет '
          'уютом старых улочек, тишиной парков, древней, с любовью '
          'оберегаемой архитектурой. В облике светской дамы проведет на '
          'выставку, в музей, на театральную премьеру. ',
      filters: [
        ActivityFilter(ref: 'f1', title: 'filter 1'),
        ActivityFilter(ref: 'f2', title: 'filter 2'),
        ActivityFilter(ref: 'f3', title: 'filter 3'),
        ActivityFilter(ref: 'f4', title: 'filter 4'),
        ActivityFilter(ref: 'f5', title: 'filter 5'),
        ActivityFilter(ref: 'f6', title: 'filter 6'),
      ],
      activities: [
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/400',
        ),
        ActivityModel(
          title: 'Московский зоопарк',
          thumbnailUrl: 'https://picsum.photos/500',
        ),
        ActivityModel(
          title: 'Музей археологии Москвы',
          thumbnailUrl: 'https://picsum.photos/600',
        ),
        ActivityModel(
          title: 'Усадьба Коломенское',
          thumbnailUrl: 'https://picsum.photos/650',
        ),
      ],
    );

    switch (ref) {
      case '1':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/800',
            title: 'Москва и Санкт-Петербург на 3 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(
                ref: '1',
                name: 'Москва',
                isSelected: cityRef == '1',
              ),
              CityModel(
                ref: '2',
                name: 'Санкт петербург',
                isSelected: cityRef == '2',
              ),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '2':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/900',
            title: 'Москва на 4 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Получить до 28 декабря', SubTitleGrade.grade1),
            ],
            cities: [
              CityModel(ref: '1', name: 'Москва', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '3':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/700',
            title: 'Новосибирск на 5 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(ref: '1', name: 'Новосибирск', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '4':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/1000',
            title: 'Москва и Санкт-Петербург на 3 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(ref: '1', name: 'Москва', isSelected: true),
              CityModel(ref: '2', name: 'Санкт петербург', isSelected: false),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '5':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/850',
            title: 'Москва на 4 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Получить до 28 декабря', SubTitleGrade.grade1),
            ],
            cities: [
              CityModel(ref: '1', name: 'Москва', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      case '6':
        return <SectionModel>[
          HeaderSection(
            thumbnailUrl: 'https://picsum.photos/750',
            title: 'Новосибирск на 5 дня',
            subTitle: [
              SubTitle('Взрослый'),
              SubTitle('Действует 2 дня 16 часов'),
            ],
            cities: [
              CityModel(ref: '1', name: 'Новосибирск', isSelected: true),
            ],
          ),
          packageConstitution,
          activities,
        ];

      default:
        throw AssertionError();
    }
  }
}
