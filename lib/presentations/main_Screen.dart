import 'package:dolan_yuk/components/widgets/mainButton.dart';
import 'package:dolan_yuk/presentations/pages/profile_Page.dart';
import 'package:dolan_yuk/presentations/pages/schedule_Page.dart';
import 'package:dolan_yuk/presentations/pages/search_Page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/dolan_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController pageController = PageController();
  int currentPage = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 24,
        backgroundColor: Colors.deepPurple[50],
        title: Text("DolanYuk"),
      ),
      drawer: Drawer(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text("${context.watch<DolanProvider>().getLength}"),
              const Spacer(),
              MainButton(
                  onPressed: () {
                    context.goNamed('login');
                  },
                  title: "Logout")
            ],
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        children: const [SchedulePage(), SearchPage(), ProfilePage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
            pageController.animateToPage(currentPage,
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn);
          },
          backgroundColor: Colors.deepPurple[50],
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black38,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_today,
                  color: Colors.deepPurple,
                ),
                label: "Jadwal"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: Colors.deepOrange,
                ),
                label: "Cari"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_2_outlined,
                  color: Colors.blueGrey,
                ),
                label: "Profil")
          ]),
    );
  }
}
