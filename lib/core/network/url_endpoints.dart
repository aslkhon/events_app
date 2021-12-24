abstract class UrlEndpoints {
  const UrlEndpoints();

  String get baseUrl;

  Uri getEvents(int offset, int limit);
}

class UrlEnpointsImpl extends UrlEndpoints {
  const UrlEnpointsImpl();

  @override
  String get baseUrl => 'https://guidebook.com';

  @override
  Uri getEvents(int offset, int limit) => Uri.parse(
      '$baseUrl/service/v2/upcomingGuides/?offset=$offset&limit=$limit');
}
