class ApiConstants {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String posts = '/posts';

  // Pagination
  static const int postsPerPage =  10;

  // Endpoints
  static String getPostDetails(int id) => '$baseUrl$posts/$id';

}

class NetworkConstants {
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int maxRetries = 3;
}