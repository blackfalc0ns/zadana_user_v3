import 'package:file_picker/file_picker.dart';
import 'package:zadana_user_v3/core/network/failures.dart';
import 'package:zadana_user_v3/feature/my_orders/domain/entities/order_details_entity.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/models/order_ui_model.dart';
import 'package:zadana_user_v3/feature/my_orders/presentation/widgets/order_details_shared.dart';

class OrderDetailsState {
  const OrderDetailsState({
    this.isLoading = false,
    this.order,
    this.failure,
    this.status,
    this.complaint = OrderComplaintState.none,
    this.message = '',
    this.attachments = const [],
    this.cancelReason,
    this.feedbackMessage,
  });

  static const _unset = Object();

  final bool isLoading;
  final OrderDetailsEntity? order;
  final Failure? failure;
  final OrderStatus? status;
  final OrderComplaintState complaint;
  final String message;
  final List<PlatformFile> attachments;
  final String? cancelReason;
  final String? feedbackMessage;

  OrderDetailsState copyWith({
    bool? isLoading,
    OrderDetailsEntity? order,
    Failure? failure,
    OrderStatus? status,
    OrderComplaintState? complaint,
    String? message,
    List<PlatformFile>? attachments,
    Object? cancelReason = _unset,
    Object? feedbackMessage = _unset,
    bool clearFailure = false,
    bool clearOrder = false,
  }) {
    return OrderDetailsState(
      isLoading: isLoading ?? this.isLoading,
      order: clearOrder ? null : order ?? this.order,
      failure: clearFailure ? null : failure ?? this.failure,
      status: status ?? this.status,
      complaint: complaint ?? this.complaint,
      message: message ?? this.message,
      attachments: attachments ?? this.attachments,
      cancelReason: identical(cancelReason, _unset)
          ? this.cancelReason
          : cancelReason as String?,
      feedbackMessage: identical(feedbackMessage, _unset)
          ? this.feedbackMessage
          : feedbackMessage as String?,
    );
  }
}
