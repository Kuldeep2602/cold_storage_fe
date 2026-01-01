import 'api_client.dart';

class LedgerService {
  LedgerService(this._api);

  final ApiClient _api;

  Future<Map<String, dynamic>> fetchLedger({
    DateTime? dateFrom,
    DateTime? dateTo,
    int? personId,
    String? crop,
  }) async {
    final query = <String, String>{};
    if (dateFrom != null) query['date_from'] = dateFrom.toUtc().toIso8601String();
    if (dateTo != null) query['date_to'] = dateTo.toUtc().toIso8601String();
    if (personId != null) query['person'] = personId.toString();
    if (crop != null && crop.trim().isNotEmpty) query['crop'] = crop.trim();

    final res = await _api.getJson('/api/ledger/', query: query);
    return (res as Map).cast<String, dynamic>();
  }
}
