import 'package:equatable/equatable.dart';

class BasePagination extends Equatable {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPages;

  const BasePagination({
    this.page,
    this.limit,
    this.total,
    this.totalPages,
  });

  factory BasePagination.fromJson(Map<String, dynamic> json) {
    return BasePagination(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
    };
  }

  @override
  List<Object?> get props => [page, limit, total, totalPages];
}

class MultiMessage extends Equatable {
  final Map<String, List<String>>? fields;
  final List<String>? general;

  const MultiMessage({
    this.fields,
    this.general,
  });

  factory MultiMessage.fromJson(Map<String, dynamic> json) {
    return MultiMessage(
      fields: json['fields'] != null 
          ? Map<String, List<String>>.from(
              json['fields'].map((key, value) => MapEntry(key, List<String>.from(value)))
            )
          : null,
      general: json['general'] != null ? List<String>.from(json['general']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fields': fields,
      'general': general,
    };
  }

  @override
  List<Object?> get props => [fields, general];
}

class BaseResponseData<T> extends Equatable {
  final bool? success;
  final T? data;
  final String? message;
  final BasePagination? pagination;
  final bool? error;
  final String? url;
  final int? statusCode;
  final String? statusMessage;
  final List<String>? stack;
  final MultiMessage? messages;
  final List<String>? details;

  const BaseResponseData({
    this.success,
    this.data,
    this.message,
    this.pagination,
    this.error,
    this.url,
    this.statusCode,
    this.statusMessage,
    this.stack,
    this.messages,
    this.details,
  });

  factory BaseResponseData.fromJson(
    Map<String, dynamic> json, 
    T Function(dynamic)? fromJsonT,
  ) {
    return BaseResponseData<T>(
      success: json['success'],
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : json['data'],
      message: json['message'],
      pagination: json['pagination'] != null 
          ? BasePagination.fromJson(json['pagination']) 
          : null,
      error: json['error'],
      url: json['url'],
      statusCode: json['statusCode'],
      statusMessage: json['statusMessage'],
      stack: json['stack'] != null ? List<String>.from(json['stack']) : null,
      messages: json['messages'] != null 
          ? MultiMessage.fromJson(json['messages']) 
          : null,
      details: json['details'] != null ? List<String>.from(json['details']) : null,
    );
  }

  Map<String, dynamic> toJson({Object? Function(T)? toJsonT}) {
    return {
      'success': success,
      'data': data != null && toJsonT != null ? toJsonT(data as T) : data,
      'message': message,
      'pagination': pagination?.toJson(),
      'error': error,
      'url': url,
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'stack': stack,
      'messages': messages?.toJson(),
      'details': details,
    };
  }

  bool get isSuccess => success == true && error != true;
  bool get hasError => error == true || success == false;
  String get errorMessage => message ?? statusMessage ?? 'Unknown error occurred';

  @override
  List<Object?> get props => [
    success,
    data,
    message,
    pagination,
    error,
    url,
    statusCode,
    statusMessage,
    stack,
    messages,
    details,
  ];
}

// Helper class for list responses
class BaseListResponse<T> extends BaseResponseData<List<T>> {
  const BaseListResponse({
    super.success,
    super.data,
    super.message,
    super.pagination,
    super.error,
    super.url,
    super.statusCode,
    super.statusMessage,
    super.stack,
    super.messages,
    super.details,
  });

  factory BaseListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    List<T>? dataList;
    if (json['data'] is List) {
      dataList = (json['data'] as List)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList();
    }

    return BaseListResponse<T>(
      success: json['success'],
      data: dataList,
      message: json['message'],
      pagination: json['pagination'] != null 
          ? BasePagination.fromJson(json['pagination']) 
          : null,
      error: json['error'],
      url: json['url'],
      statusCode: json['statusCode'],
      statusMessage: json['statusMessage'],
      stack: json['stack'] != null ? List<String>.from(json['stack']) : null,
      messages: json['messages'] != null 
          ? MultiMessage.fromJson(json['messages']) 
          : null,
      details: json['details'] != null ? List<String>.from(json['details']) : null,
    );
  }
}