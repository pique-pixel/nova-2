import 'dart:convert';
import 'dart:io';
import 'package:matcher/matcher.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:optional/optional_internal.dart';
import 'package:rp_mobile/exceptions.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';

void main() {
  test('TicketsListResponse - success', () async {
    final file = File('test_resources/tickets_list.json');
    final json = jsonDecode(await file.readAsString());
    final model = TicketsListResponse.fromJson(json);

    expect(model.last, false);
    expect(model.content.length, 20);
    expect(model.content[3].qr, Optional.of('R23409odjfkjs4'));
    expect(
      model.content[1].items[0].item.externalId,
      '5df9fb46779af50001d26094',
    );
    expect(
      model.content[0].items[0].item.offerContent,
      Optional.empty(),
    );
    expect(
      model.content[1].items[0].item.offerContent.value.name.value,
      'Каток Mega Ice',
    );
    expect(
      model.content[1].items[0].item.offerContent.value.photo.url,
      'content/75594233670.jpg',
    );
    expect(
      model.content[1].items[0].item.offerContent.value.photo.description,
      Optional.empty(),
    );
  });

  test('TicketsListResponse - fail', () async {
    final file = File('test_resources/tickets_list_bad.json');
    final json = jsonDecode(await file.readAsString());

    expect(
      () => TicketsListResponse.fromJson(json),
      throwsA(const TypeMatcher<SchemeConsistencyException>()),
    );
  });

  test('OfferResponse - success', () async {
    final file = File('test_resources/offer_details.json');
    final json = jsonDecode(await file.readAsString());
    final model = OfferResponse.fromJson(json);

    expect(model.fullName.value, 'Центральный военно-морской музей');
    expect(model.durationMin, 90);
    expect(model.place.url, 'http://navalmuseum.ru');
    expect(model.place.headerPhoto.url, 'content/7559423369.jpg');
    expect(model.place.headerPhoto.description.value, 'Some description');
    expect(model.tags.length, 3);
    expect(model.tags[2].name.value, 'история');
  });

  test('OfferResponse - fail', () async {
    final file = File('test_resources/tickets_list.json');
    final json = jsonDecode(await file.readAsString());

    expect(
      () => OfferResponse.fromJson(json),
      throwsA(const TypeMatcher<SchemeConsistencyException>()),
    );
  });
}
