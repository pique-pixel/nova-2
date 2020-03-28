import 'package:rp_mobile/containers/page.dart';
import 'package:rp_mobile/layers/bloc/single_ticket_content_details/single_ticket_content_details_models.dart';
import 'package:rp_mobile/layers/bloc/tickets/tickets_models.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';

abstract class UiModelsFactory {
  Page<TicketItemModel> createTicketsPage(
    TicketsListResponse response,
  );

  TicketItemModel createTicket(
    TicketsListContentResponse content,
    TicketsListContentItemResponse response,
  );

  TicketInfoModel createTicketInfo(
    TicketsListContentResponse content,
    TicketsListContentItemResponse response,
  );

  SingleTicketContentDetails createSingleTicketContentDetails(
    OfferResponse response,
  );
}
