import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/network/url_endpoints.dart';
import '../../../../domain/entities/event_entity.dart';
import '../../../../injection_container.dart';
import 'event.button.dart';
import '../../single_event/single_event_screen.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final Color backgroundColor;
  final EventEntity event;

  const EventCard(
      {Key? key, required this.backgroundColor, required this.event})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 256.0,
      padding: const EdgeInsets.all(20.0),
      color: backgroundColor,
      child: Column(
        children: [
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: Theme.of(context).textTheme.headline1,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Text(
                      event.date,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                ],
              )),
              Container(
                height: 48.0,
                width: 58.0,
                color: Colors.white,
                child: CachedNetworkImage(
                  imageUrl: event.iconUrl,
                  placeholder: (context, url) => const Center(
                    child: SizedBox(
                        height: 40.0,
                        width: 40.0,
                        child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.event),
                ),
              )
            ],
          )),
          Align(
            alignment: Alignment.centerRight,
            child: EventButton(
              onPressed: () => Navigator.of(context).pushNamed(
                SingleEventScreen.routeName,
                arguments: ScreenArguments(
                    title: event.name,
                    url: serviceLocator<UrlEndpoints>().baseUrl +
                        event.referenceUrl),
              ),
            ),
          )
        ],
      ),
    );
  }
}
