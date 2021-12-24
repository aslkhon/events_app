import 'package:events_app/data/models/event_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/reader.dart';

void main() {
  const event = EventModel(
      url: '/guide/188616',
      startDate: 'Dec 25, 2021',
      endDate: 'Dec 25, 2022',
      name: 'IO Fonteva Mobile Demo Event',
      icon:
          'https://s3.amazonaws.com/media.guidebook.com/service/SwYvINUDDPydDiVqvYPLKyNvvdrDxeSNnx29leHf/logo.png');

  test(
    'should return a valid model from json',
    () async {
      final result = EventModel.fromJson(fixture('event.json'));

      expect(result, event);
    },
  );
}
