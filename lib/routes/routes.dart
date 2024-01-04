import 'package:dolan_yuk/models/room.dart';
import 'package:dolan_yuk/presentations/login_Screen.dart';
import 'package:dolan_yuk/presentations/main_Screen.dart';
import 'package:dolan_yuk/presentations/pages/addSchedule_Page.dart';
import 'package:dolan_yuk/presentations/roomChat.dart';
import 'package:dolan_yuk/presentations/register_Screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/register',
    name: 'register',
    builder: (context, state) => const RegisterScreen(),
  ),
  GoRoute(
      path: '/',
      name: 'main',
      builder: (context, state) {
        return const MainScreen();
      },
      routes: [
        GoRoute(
          path: 'add',
          name: 'add',
          builder: (context, state) => const AddSchedulePage(),
        ),
        GoRoute(
            path: 'room',
            name: 'room',
            builder: (context, state) {
              Object? object = state.extra;
              if (object != null && object is Room) {
                return RoomChat(room: object);
              } else {
                return RoomChat(
                    room: Room(
                        username: "no name", id_schedule: 0, name: "no name"));
              }
            })
      ])
], initialLocation: '/login');
