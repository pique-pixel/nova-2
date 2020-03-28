import 'package:rp_mobile/exceptions.dart';
import 'package:rp_mobile/layers/drivers/api/session.dart';
import 'package:rp_mobile/locale/localized_string.dart';

import 'model/registerResponse.dart';
import 'models.dart';

abstract class ApiGateway {
  Future<void> updateSession(Session session);

  Future<void> clearSession();

  Future<RegisterResposne> createSession(RegisterRequest request);

  Future<TokenResponse> token(TokenRequest request);

  Future<void> createConfirmEmail(String token);

  Future<TicketsListResponse> getTicketsList([int page = 0]);

  Future<OfferResponse> getOfferById(String id);
}

class ApiException implements LocalizeMessageException {
  final LocalizedString localizedMessage;
  final String message;

  ApiException(this.localizedMessage, this.message);
}

class ApiUnauthorizedException extends ApiException {
  ApiUnauthorizedException()
      : super(
          LocalizedString.fromString('Unauthorized'),
          'Unauthorized',
        );
}
