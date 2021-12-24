import '../../bloc/events_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/event_card.dart';
import 'widgets/event_card_shimmer.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  static const _colors = [Colors.blue, Colors.green, Colors.red];

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        BlocProvider.of<EventsBloc>(context).add(LoadEvents());
      }
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text.rich(
                const TextSpan(children: [
                  TextSpan(
                      text: 'events.', style: TextStyle(color: Colors.blue)),
                  TextSpan(text: 'app')
                ]),
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Expanded(
              child: BlocConsumer<EventsBloc, EventsState>(
                listener: (context, state) {
                  if (state is! EventsInitial || state.error == null) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                          state.error!.message,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        backgroundColor: state.error!.color.withOpacity(0.5)),
                  );
                },
                builder: (context, state) {
                  if (state.events.isEmpty &&
                      ((state is EventsInitial && state.error == null) ||
                          state is LoadEvents)) {
                    final shimmer = SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          for (int i = 0; i < 3; i++)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 24.0),
                              child: SizedBox(
                                  width: double.infinity,
                                  child: EventCardShimmer()),
                            )
                        ],
                      ),
                    );
                    return shimmer;
                  }

                  if (state.events.isEmpty && state is EventsInitial) {
                    return SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: TextButton(
                          onPressed: () => BlocProvider.of<EventsBloc>(context)
                              .add(LoadEvents()),
                          child: Text(
                            'Could not load. Press to Retry',
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      if (index == state.events.length) {
                        if (state is Loading) {
                          return const SizedBox(
                            height: 72.0,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          );
                        } else {
                          return const SizedBox(
                            height: 24.0,
                          );
                        }
                      }
                      return EventCard(
                          backgroundColor: _colors[index % _colors.length],
                          event: state.events[index]);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 24.0);
                    },
                    itemCount: state.events.length + 1,
                    shrinkWrap: false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
