import 'package:dio/dio.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/config.dart';
import 'package:rp_mobile/layers/drivers/api/gateway.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';
import 'package:rp_mobile/layers/drivers/api/session.dart';
import 'package:rp_mobile/layers/drivers/dio_client.dart';
import 'package:rp_mobile/layers/services/auth.dart';
import 'package:rp_mobile/layers/services/session.dart';

import 'model/registerResponse.dart';

class ApiGatewayImpl implements ApiGateway {
  Optional<Session> _session = const Optional.empty();
  final DioClient _client;
  final Config _config;

  ApiGatewayImpl(this._client, this._config);

  @override
  Future<void> updateSession(Session session) async {
    assert(session != null);
    _session = Optional.of(session);
  }

  @override
  Future<void> clearSession() async {
    _session = Optional.empty();
  }

  @override
  Future<void> createConfirmEmail(String token) async {
    await _client.get(
      '/user/users/confirm/create?token=$token',
      session: _session,
    );
  }

  @override
  Future<TokenResponse> token(TokenRequest request) async {
    assert(request != null);
    final response = await _client.post(
      '/sso/oauth/token?${request.toWWWFormUrlencoded()}',
      options: Options(
        headers: {'Authorization': 'Basic ${_config.apiBaseAuthToken}'},
      ),
    );
    return TokenResponse.fromJson(_client.getJsonBody(response));
  }

  @override
  Future<TicketsListResponse> getTicketsList([int page = 0]) async {
    final response = await _client.get(
      '/content/b/user/order/list?active=true&size=10&page=$page',
      session: _session,
    );
    return TicketsListResponse.fromJson(_client.getJsonBody(response));
  }

  @override
  Future<OfferResponse> getOfferById(String id) async {
    final response = await _client.get(
      '/content/offer/$id',
      session: _session,
    );
    return OfferResponse.fromJson(_client.getJsonBody(response));
  }

  @override
  Future<RegisterResposne> createSession(RegisterRequest request)async {
   final response =  await _client.post(
      '/user/users',
      data: request.toJson(),
    );
    return RegisterResposne.fromJson(_client.getJsonBody(response));
  }
}
