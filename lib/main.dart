import 'package:events_app/presentation/bloc/events_bloc.dart';
import 'package:events_app/presentation/screens/single_event/single_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'injection_container.dart' as di;

import 'presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const EventsApp());
}

class EventsApp extends StatelessWidget {
  const EventsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0),
          headline2:
              GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24.0),
          bodyText1: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
          button: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => BlocProvider<EventsBloc>(
              create: (context) =>
                  di.serviceLocator<EventsBloc>()..add(LoadEvents()),
              child: const HomeScreen(),
            ),
        SingleEventScreen.routeName: (context) => const SingleEventScreen()
      },
    );
  }
}
