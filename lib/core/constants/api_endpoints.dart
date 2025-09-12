class ApiEndpoints {
  // Base URLs - these should be configured per environment
  static const String baseUrl = ''; // Relative to AppConfig.baseUrl (AppConfig already has /api)
  
  // Authentication endpoints
  static const String auth = '$baseUrl/auth';
  static const String login = '$auth/login';
  
  // Helper methods for query parameters (kept for future use)
  static String withQuery(String endpoint, Map<String, dynamic> params) {
    if (params.isEmpty) return endpoint;
    
    final queryString = params.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');
        
    return queryString.isEmpty ? endpoint : '$endpoint?$queryString';
  }
  
  // Common query parameter methods (kept for future use)
  static String withPagination(String endpoint, {int? page, int? limit}) {
    return withQuery(endpoint, {
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
    });
  }
  
  static String withFilters(String endpoint, Map<String, dynamic> filters) {
    return withQuery(endpoint, filters);
  }
}