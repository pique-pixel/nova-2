import 'package:optional/optional.dart';
import 'package:rp_mobile/exceptions.dart';
import 'package:rp_mobile/locale/localized_string.dart';
import 'package:rp_mobile/utils/exceptions.dart';
import 'package:rp_mobile/utils/json.dart';

const availableDaysOfWeek = <String>{
  'MONDAY',
  'TUESDAY',
  'WEDNESDAY',
  'THURSDAY',
  'FRIDAY',
  'SATURDAY',
  'SUNDAY',
};

class TokenRequest {
  final String clientId;
  final String scope;
  final String secret;
  final String username;
  final String password;
  final String grantType;

  TokenRequest({
    this.clientId,
    this.scope,
    this.secret,
    this.username,
    this.password,
    this.grantType,
  }) {
    require(clientId != null, () => SchemeConsistencyException());
    require(scope != null, () => SchemeConsistencyException());
    require(secret != null, () => SchemeConsistencyException());
    require(username != null, () => SchemeConsistencyException());
    require(password != null, () => SchemeConsistencyException());
    require(grantType != null, () => SchemeConsistencyException());
  }

  String toWWWFormUrlencoded() {
    return 'client_id=$clientId&scope=$scope&secret=$secret&'
        'username=$username&password=$password&grant_type=$grantType';
  }
}

class TokenResponse {
  final String accessToken;
  final String tokenType;
  final String refreshToken;
  final int expiresIn;
  final String scope;
  final List<ScopeResponse> role;

  TokenResponse({
    this.accessToken,
    this.tokenType,
    this.refreshToken,
    this.expiresIn,
    this.scope,
    this.role,
  }) {
    require(accessToken != null, () => SchemeConsistencyException());
    require(tokenType != null, () => SchemeConsistencyException());
    require(refreshToken != null, () => SchemeConsistencyException());
    require(expiresIn != null, () => SchemeConsistencyException());
    require(scope != null, () => SchemeConsistencyException());
    require(role != null, () => SchemeConsistencyException());
  }

  TokenResponse.fromJson(Map<String, dynamic> json)
      : accessToken = getJsonValue(json, 'access_token'),
        tokenType = getJsonValue(json, 'token_type'),
        refreshToken = getJsonValue(json, 'refresh_token'),
        expiresIn = getJsonValue(json, 'expires_in'),
        scope = getJsonValue(json, 'scope'),
        role = transformJsonListOfMap(
          json,
          'role',
          (it) => ScopeResponse.fromJson(it),
        );
}

class ScopeResponse {
  final String authority;

  ScopeResponse(this.authority) {
    require(authority != null, () => SchemeConsistencyException());
  }

  ScopeResponse.fromJson(Map<String, dynamic> json)
      : authority = getJsonValue(json, 'authority');
}

class TicketsListResponse {
  final bool last;
  final int number;
  final List<TicketsListContentResponse> content;

  TicketsListResponse({
    this.last,
    this.content,
    this.number,
  }) {
    require(last != null, () => SchemeConsistencyException());
    require(content != null, () => SchemeConsistencyException());
  }

  TicketsListResponse.fromJson(Map<String, dynamic> json)
      : last = getJsonValue(json, 'last'),
        number = getJsonValue(json, 'number'),
        content = transformJsonListOfMap(
          json,
          'content',
          (it) => TicketsListContentResponse.fromJson(it),
        );
}

class TicketsListContentResponse {
  final Optional<String> qr;
  final List<TicketsListContentItemResponse> items;

  TicketsListContentResponse({
    this.qr,
    this.items,
  }) {
    require(qr != null, () => SchemeConsistencyException());
    require(items != null, () => SchemeConsistencyException());
  }

  TicketsListContentResponse.fromJson(Map<String, dynamic> json)
      : qr = getJsonValueOrEmpty(json, 'qr'),
        items = transformJsonListOfMap(
          json,
          'items',
          (it) => TicketsListContentItemResponse.fromJson(it),
        );
}

class TicketsListContentItemResponse {
  final int id;
  final TicketsListContentItemItemResponse item;

  TicketsListContentItemResponse({this.item, this.id}) {
    require(item != null, () => SchemeConsistencyException());
    require(id != null, () => SchemeConsistencyException());
  }

  TicketsListContentItemResponse.fromJson(Map<String, dynamic> json)
      : id = getJsonValue(json, 'id'),
        item = TicketsListContentItemItemResponse.fromJson(
          getJsonValue(json, 'item'),
        );
}

class TicketsListContentItemItemResponse {
  final String externalId;
  final Optional<OfferContentResponse> offerContent;

  TicketsListContentItemItemResponse({
    this.externalId,
    this.offerContent,
  }) {
    require(externalId != null, () => SchemeConsistencyException());
    require(offerContent != null, () => SchemeConsistencyException());
  }

  TicketsListContentItemItemResponse.fromJson(Map<String, dynamic> json)
      : externalId = getJsonValue(json, 'externalId'),
        offerContent = transformJsonValueOrEmpty(
          json,
          'offerContent',
          (it) => OfferContentResponse.fromJson(it),
        );
}

class OfferContentResponse {
  final String id;
  final TranslatableStringResponse name;
  final PhotoResponse photo;

  OfferContentResponse({
    this.id,
    this.name,
    this.photo,
  }) {
    require(name != null, () => SchemeConsistencyException());
    require(photo != null, () => SchemeConsistencyException());
  }

  OfferContentResponse.fromJson(Map<String, dynamic> json)
      : id = getJsonValue(json, 'id'),
        name = TranslatableStringResponse.fromJson(getJsonValue(json, 'name')),
        photo = PhotoResponse.fromJson(getJsonValue(json, 'photo'));
}

class PhotoResponse {
  final String url;
  final Optional<String> description;

  PhotoResponse({
    this.url,
    this.description,
  }) {
    require(url != null, () => SchemeConsistencyException());
    require(description != null, () => SchemeConsistencyException());
  }

  PhotoResponse.fromJson(Map<String, dynamic> json)
      : url = getJsonValue(json, 'url'),
        description = getJsonValueOrEmpty(json, 'description');
}

class TranslatableStringResponse {
  final List<LocalizedStringItemResponse> inOtherLang;
  final String value;

  TranslatableStringResponse({
    this.inOtherLang,
    this.value,
  }) {
    require(inOtherLang != null, () => SchemeConsistencyException());
    require(value != null, () => SchemeConsistencyException());
  }

  TranslatableStringResponse.fromJson(Map<String, dynamic> json)
      : inOtherLang = transformJsonListOfMap(
          json,
          'inOtherLang',
          (it) => LocalizedStringItemResponse.fromJson(it),
        ),
        value = getJsonValue(json, 'value');

  // TODO: Implement
  LocalizedString toLocalizedString() => LocalizedString.fromString(value);
}

class LocalizedStringItemResponse {
  final String value;
  final String language;

  LocalizedStringItemResponse({
    this.value,
    this.language,
  }) {
    require(value != null, () => SchemeConsistencyException());
    require(language != null, () => SchemeConsistencyException());
  }

  LocalizedStringItemResponse.fromJson(Map<String, dynamic> json)
      : value = getJsonValue(json, 'value'),
        language = getJsonValue(json, 'language');
}

class OfferResponse {
  final TranslatableStringResponse fullName;
  final PlaceResponse place;
  final List<TagResponse> tags;
  final TranslatableStringResponse description;
  final int durationMin;
  final List<OfferScheduleResponse> schedules;
  final List<BasePriceResponse> prices;

  OfferResponse.fromJson(Map<String, dynamic> json)
      : fullName = TranslatableStringResponse.fromJson(
          getJsonValue(json, 'fullName'),
        ),
        place = PlaceResponse.fromJson(getJsonValue(json, 'place')),
        tags = transformJsonListOfMap(
          json,
          'tags',
          (it) => TagResponse.fromJson(it),
        ),
        description = TranslatableStringResponse.fromJson(
          getJsonValue(json, 'description'),
        ),
        durationMin = getJsonValue(json, 'durationMin'),
        schedules = transformJsonListOfMap(
          json,
          'schedules',
          (it) => OfferScheduleResponse.fromJson(it),
        ),
        prices = transformJsonListOfMap(
          json,
          'prices',
          (it) => BasePriceResponse.fromJson(it),
        ) {
    require(
      fullName != null,
      () => SchemeConsistencyException('fullName is null'),
    );
    require(
      place != null,
      () => SchemeConsistencyException('place is null'),
    );
    require(
      tags != null,
      () => SchemeConsistencyException('tags is null'),
    );
    require(
      description != null,
      () => SchemeConsistencyException('description is null'),
    );
    require(
      durationMin != null,
      () => SchemeConsistencyException('durationMin is null'),
    );
    require(
      schedules != null,
      () => SchemeConsistencyException('schedules is null'),
    );
  }
}

class PlaceResponse {
  final String url;
  final LocationResponse location;
  final TranslatableStringResponse address;
  final PhotoResponse headerPhoto;

  final bool forSedentary;
  final bool forVisually;
  final bool forHearing;
  final bool forMental;

  PlaceResponse({
    this.url,
    this.location,
    this.address,
    this.headerPhoto,
    this.forSedentary,
    this.forVisually,
    this.forHearing,
    this.forMental,
  }) {
    require(url != null, () => SchemeConsistencyException());
    require(location != null, () => SchemeConsistencyException());
    require(address != null, () => SchemeConsistencyException());
    require(headerPhoto != null, () => SchemeConsistencyException());
    require(forSedentary != null, () => SchemeConsistencyException());
    require(forVisually != null, () => SchemeConsistencyException());
    require(forHearing != null, () => SchemeConsistencyException());
    require(forMental != null, () => SchemeConsistencyException());
  }

  PlaceResponse.fromJson(Map<String, dynamic> json)
      : url = getJsonValue(json, 'url'),
        location = LocationResponse.fromJson(getJsonValue(json, 'location')),
        address = TranslatableStringResponse.fromJson(
          getJsonValue(json, 'address'),
        ),
        headerPhoto = PhotoResponse.fromJson(
          getJsonValue(json, 'headerPhoto'),
        ),
        forSedentary = getJsonValue(json, 'forSedentary'),
        forVisually = getJsonValue(json, 'forVisually'),
        forHearing = getJsonValue(json, 'forHearing'),
        forMental = getJsonValue(json, 'forMental');
}

class TagResponse {
  final TranslatableStringResponse name;

  TagResponse(this.name);

  TagResponse.fromJson(Map<String, dynamic> json)
      : name = TranslatableStringResponse.fromJson(getJsonValue(json, 'name'));
}

class LocationResponse {
  final double x;
  final double y;

  LocationResponse({this.x, this.y}) {
    require(x != null, () => SchemeConsistencyException());
    require(y != null, () => SchemeConsistencyException());
  }

  LocationResponse.fromJson(Map<String, dynamic> json)
      : x = getJsonValue(json, 'x'),
        y = getJsonValue(json, 'y');
}

class OfferScheduleResponse {
  final TranslatableStringResponse name;
  final List<int> fromDate;
  final List<int> toDate;
  final List<OfferScheduleDetailsResponse> details;
  final List<OfferScheduleExcludeResponse> excludes;
  final List<OfferAdditionalInfoResponse> additionalInfos;

  OfferScheduleResponse.fromJson(Map<String, dynamic> json)
      : name = TranslatableStringResponse.fromJson(getJsonValue(json, 'name')),
        fromDate = getJsonList<int>(json, 'fromDate'),
        toDate = getJsonList<int>(json, 'toDate'),
        excludes = transformJsonListOfMap(
          json,
          'excludes',
          (it) => OfferScheduleExcludeResponse.fromJson(it),
        ),
        details = transformJsonListOfMap(
          json,
          'details',
          (it) => OfferScheduleDetailsResponse.fromJson(it),
        ),
        additionalInfos = transformJsonListOfMap(
          json,
          'additionalInfos',
          (it) => OfferAdditionalInfoResponse.fromJson(it),
        ) {
    require(name != null, () => SchemeConsistencyException('name is null'));
    require(
      details != null,
      () => SchemeConsistencyException('details is null'),
    );
    require(
      fromDate.length == 3,
      () => SchemeConsistencyException('fromDate.length != 3'),
    );
    require(
      toDate.length == 3,
      () => SchemeConsistencyException('toDate.length != 3'),
    );
  }
}

class OfferScheduleDetailsResponse {
  final List<int> fromTime;
  final List<int> toTime;
  final List<String> dayOfWeeks;

  OfferScheduleDetailsResponse.fromJson(Map<String, dynamic> json)
      : fromTime = getJsonList(json, 'fromTime'),
        toTime = getJsonList(json, 'toTime'),
        dayOfWeeks = getJsonList(json, 'dayOfWeeks') {
    require(
      fromTime != null,
      () => SchemeConsistencyException('fromTime is null'),
    );
    require(
      toTime != null,
      () => SchemeConsistencyException('toTime is null'),
    );
    require(
      availableDaysOfWeek.containsAll(dayOfWeeks),
      () => SchemeConsistencyException(
        'dayOfWeeks contains invalid value: $dayOfWeeks',
      ),
    );
    require(fromTime.length >= 2,
        () => SchemeConsistencyException('fromTime.length < 2'));
    require(toTime.length >= 2,
        () => SchemeConsistencyException('toTime.length < 2'));
  }
}

class OfferScheduleExcludeResponse {
  final String date;
  final List<String> dayOfWeeks;

  OfferScheduleExcludeResponse.fromJson(Map<String, dynamic> json)
      : date = getJsonValue(json, 'date'),
        dayOfWeeks = getJsonList(json, 'dayOfWeeks') {
    require(
      date != null,
      () => SchemeConsistencyException('date is null'),
    );
    require(
      availableDaysOfWeek.containsAll(dayOfWeeks),
      () => SchemeConsistencyException(
        'dayOfWeeks contains invalid value: $dayOfWeeks',
      ),
    );
  }
}

class OfferAdditionalInfoResponse {
  final TranslatableStringResponse name;

  OfferAdditionalInfoResponse.fromJson(Map<String, dynamic> json)
      : name = TranslatableStringResponse.fromJson(getJsonValue(json, 'name')) {
    require(
      name != null,
      () => SchemeConsistencyException('name is null'),
    );
  }
}

class BasePriceResponse {
  final String currency;
  final String type;
  final double value;

  BasePriceResponse.fromJson(Map<String, dynamic> json)
      : currency = getJsonValue(json, 'currency'),
        type = getJsonValue(json, 'type'),
        value = getJsonValue(json, 'value') {
    require(
      currency != null,
      () => SchemeConsistencyException('currency is null'),
    );
    require(
      type != null,
      () => SchemeConsistencyException('type is null'),
    );
    require(
      value != null,
      () => SchemeConsistencyException('value is null'),
    );
    require(
      ['CHILD', 'ADULT'].contains(type),
      () => SchemeConsistencyException('type contains invalid value: $type'),
    );
  }
}
