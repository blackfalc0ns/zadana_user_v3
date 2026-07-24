import 'package:zadana_user_v3/core/di/di.dart';
import 'package:zadana_user_v3/core/network/api_services.dart';
import 'package:zadana_user_v3/feature/profile/data/models/legal_document_dto.dart';

class LegalDocumentLoader {
  LegalDocumentLoader._();

  /// Always requests the latest document when the page is opened.
  static Future<LegalDocumentDto> load(String documentType) =>
      getIt<ApiServices>().getLegalDocument(documentType);
}
