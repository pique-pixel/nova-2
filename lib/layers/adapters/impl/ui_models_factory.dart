import 'package:equatable/equatable.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/config.dart';
import 'package:rp_mobile/containers/image.dart';
import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/adapters/ui_models_factory.dart';
import 'package:rp_mobile/layers/bloc/single_ticket_content_details/single_ticket_content_details_models.dart';
import 'package:rp_mobile/layers/bloc/tickets/tickets_models.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';
import 'package:rp_mobile/locale/localized_string.dart';

class UiModelsFactoryImpl implements UiModelsFactory {
  final Config _config;

  UiModelsFactoryImpl(this._config);

  _absoluteImageUrl(String relativeUrl) {
    return '${_config.apiBaseUrl}/attach/image?file=$relativeUrl';
  }

  @override
  Page<TicketItemModel> createTicketsPage(
    TicketsListResponse response,
  ) {
    final items = <TicketItemModel>[];

    for (final content in response.content) {
      for (final item in content.items) {
        if (!item.item.offerContent.isPresent) {
          continue;
        }

        if (!content.qr.isPresent) {
          continue;
        }

        final ticket = createTicket(content, item);
        items.add(ticket);
      }
    }

    return Page(
      data: items,
      nextPage: response.last ? null : response.number + 2,
    );
  }

  @override
  TicketItemModel createTicket(
    TicketsListContentResponse content,
    TicketsListContentItemResponse response,
  ) {
    final offerContent = response.item.offerContent.value;
    return TicketItemModel(
      ref: offerContent.id,
      title: LocalizedString.fromString(offerContent.name.value),
      thumbnail: ImageEither.url(_absoluteImageUrl(offerContent.photo.url)),
    );
  }

  @override
  TicketInfoModel createTicketInfo(
    TicketsListContentResponse content,
    TicketsListContentItemResponse response,
  ) {
    final offerContent = response.item.offerContent.value;
    return TicketInfoModel(
      title: LocalizedString.fromString(offerContent.name.value),
      subTitle: LocalizedString.fromString('RUSSPASS'),
      qrCode: content.qr,
      hint: content.qr
          .map((_) => LocalizedString.fromString('Покажите QR код сотруднику'))
          .orElse(LocalizedString.fromString('')),
      thumbnail: Optional.empty(),
    );
  }

  @override
  SingleTicketContentDetails createSingleTicketContentDetails(
    OfferResponse response,
  ) {
    final sections = <SingleTicketContentSection>[];

    sections.add(
      SingleTicketContentAddressSection(
        address: Optional.of(response.place.address.toLocalizedString()),
        webSite: Optional.of(response.place.url),
      ),
    );

    final availabilities = <String>[];

    if (response.place.forSedentary) {
      availabilities.add('Сидячие инвалиды');
    }

    if (response.place.forVisually) {
      availabilities.add('Слепые');
    }

    if (response.place.forHearing) {
      availabilities.add('Глухие');
    }

    if (response.place.forMental) {
      availabilities.add('Ментальная инвалидность');
    }

    for (final schedule in response.schedules) {
      final fromDate = formatDate(schedule.fromDate);
      final toDate = formatDate(schedule.toDate);
      final scheduleString = <String>['$fromDate - $toDate:\n'];

      for (final details in schedule.details) {
        final grouped = groupWeekDays(details.dayOfWeeks, 2)
            .map((it) => it.show())
            .join(', ');

        final from = formatTime(details.fromTime, '.');
        final to = formatTime(details.toTime, '.');

        scheduleString.add('$grouped: $from - $to');
      }

      if (schedule.additionalInfos.isNotEmpty) {
        scheduleString.add('');
      }

      for (final additionalInfo in schedule.additionalInfos) {
        scheduleString.add(additionalInfo.name.value);
      }

      if (scheduleString.isNotEmpty) {
        sections.add(
          SingleTicketContentIconInfoSpoilerBarSection(
            icon: SingleTicketContentSectionIcon.calendar,
            text: schedule.name.toLocalizedString(),
            spoilerText: LocalizedString.fromString(scheduleString.join('\n')),
          ),
        );
      }
    }

    if (availabilities.isNotEmpty) {
      sections.add(
        SingleTicketContentIconInfoSpoilerBarSection(
          icon: SingleTicketContentSectionIcon.disabled,
          text: LocalizedString.fromString('Адаптирован для МГН'),
          spoilerText: LocalizedString.fromString(
              availabilities.map((it) => it).join('\n')),
        ),
      );
    }

    final price = response.prices.firstWhere(
      (it) => it.currency == 'RUB',
      orElse: () => null,
    );

    if (price != null) {
      String tariffName;

      if (price.type == 'ADULT') {
        tariffName = 'Тариф Взрослый';
      } else if (price.type == 'CHILD') {
        tariffName = 'Тариф Детский';
      }

      assert(tariffName != null);

      sections.add(
        SingleTicketContentInfoBarTariffSection(
          text: LocalizedString.fromString(tariffName),
          time: LocalizedString.fromString(
            '≈ ' + formatScheduleDuration(response.durationMin),
          ),
          price: LocalizedString.fromString('${price.value} р'),
        ),
      );
    }

    sections.add(
      SingleTicketContentMapSection(
        latitude: response.place.location.x,
        longitude: response.place.location.y,
      ),
    );

    sections.add(
      SingleTicketContentDescSection(
        text: response.description.toLocalizedString(),
      ),
    );

    return SingleTicketContentDetails(
      headerThumbnail: ImageEither.url(
        _absoluteImageUrl(response.place.headerPhoto.url),
      ),
      title: response.fullName.toLocalizedString(),
      tags: response.tags.map((it) => it.name.toLocalizedString()).toList(),
      sections: sections,
    );
  }
}

// TODO: Move to another module
class WeeksGroup extends Equatable {
  final String from;
  final String to;

  WeeksGroup(this.from, this.to)
      : assert(from != null),
        assert(to != null);

  @override
  List<Object> get props => [from, to];

  @override
  String toString() => 'WeeksGroup($from - $to)';

  // TODO: Use LocalizedString
  String show() {
    final weekDays = <String, String>{
      'MONDAY': 'Пн',
      'TUESDAY': 'Вт',
      'WEDNESDAY': 'Ср',
      'THURSDAY': 'Чт',
      'FRIDAY': 'Пт',
      'SATURDAY': 'Сб',
      'SUNDAY': 'Вс',
    };

    if (from == to) {
      return weekDays[from];
    } else {
      return '${weekDays[from]} - ${weekDays[to]}';
    }
  }
}

List<WeeksGroup> groupWeekDays(List<String> weekDays, [int length = 1]) {
  final ordered = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  final res = <WeeksGroup>[];
  String fromWeek;
  String toWeek;
  int lastWeight;

  pushGroup() {
    final delta = ordered.indexOf(toWeek) - ordered.indexOf(fromWeek);

    if (delta >= length || delta == 0) {
      res.add(WeeksGroup(fromWeek, toWeek));
    } else {
      res.add(WeeksGroup(fromWeek, fromWeek));
      res.add(WeeksGroup(toWeek, toWeek));
    }
  }

  for (int i = 0; i < 7; i += 1) {
    final week = ordered[i];
    final contains = weekDays.contains(week);

    if (lastWeight == null && contains) {
      fromWeek = week;
      toWeek = week;
      lastWeight = i;
      continue;
    }

    if (lastWeight == null) {
      continue;
    }

    if (lastWeight + 1 == i && contains) {
      lastWeight = i;
      toWeek = week;
    } else {
      pushGroup();

      lastWeight = null;
      fromWeek = null;
      toWeek = null;
    }
  }

  if (fromWeek != null) {
    pushGroup();
  }

  return res;
}

String formatTime(List<int> time, [delimiter = ':']) {
  assert(time.length >= 2);

  var hours = time[0].toString();
  var minutes = time[1].toString();

  if (time[1] < 10) {
    minutes = '0$minutes';
  }

  return '$hours$delimiter$minutes';
}

String formatDate(List<int> date, [delimiter = '.']) {
  assert(date.length >= 2);

  var day = date[2].toString();
  var month = date[1].toString();
  var year = date[0].toString();

  if (date[2] < 10) {
    day = '0$day';
  }

  if (date[1] < 10) {
    month = '0$month';
  }

  return '$day$delimiter$month$delimiter$year';
}

String formatScheduleDuration(int durationInMinutes) {
  final hours = (durationInMinutes / 60).floor();
  final minutes = (durationInMinutes - (hours * 60)).floor();

  if (minutes <= 0) {
    return '$hours ч';
  } else {
    return '$hours ч $minutes м';
  }
}
