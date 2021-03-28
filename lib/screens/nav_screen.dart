import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_ui/data.dart';
import 'package:flutter_youtube_ui/screens/home_screen.dart';
import 'package:flutter_youtube_ui/screens/video_screen.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:timeago/timeago.dart' as timeago;

final selectedVideoProvider = StateProvider<Video?>((ref) => null);
final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
        (ref) => MiniplayerController());

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  static const double _playerMinHeight = 60.0;
  int _selectedIndex = 0;

  final _screens = [
    HomeScreen(),
    const Scaffold(
      body: Center(
        child: Text("explore"),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text("add"),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text("subscription"),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text("library"),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, _) {
          final selectedVideo = watch(selectedVideoProvider).state;
          final miniplayerController =
              watch(miniPlayerControllerProvider).state;
          // ignore: unused_label
          return Stack(
            children: _screens
                .asMap()
                .map((i, screen) => MapEntry(
                    i, Offstage(offstage: _selectedIndex != i, child: screen)))
                .values
                .toList()
                  ..add(
                    Offstage(
                      offstage: selectedVideo == null,
                      child: Miniplayer(
                          minHeight: _playerMinHeight,
                          maxHeight: MediaQuery.of(context).size.height,
                          builder: (height, percentage) {
                            if (selectedVideo == null) {
                              return const SizedBox.shrink();
                            }
                            if (height <= _playerMinHeight + 50)
                              return Container(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.network(
                                            selectedVideo.thumbnailUrl,
                                            height: _playerMinHeight - 4.0,
                                            width: 120.0,
                                            fit: BoxFit.cover,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(
                                                      child: Text(
                                                    selectedVideo.title,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption!
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  )),
                                                  Flexible(
                                                      child: Text(
                                                    '${selectedVideo.author.username} ',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.play_arrow)),
                                          IconButton(
                                              onPressed: () {
                                                context
                                                    .read(selectedVideoProvider)
                                                    .state = null;
                                              },
                                              icon: Icon(Icons.close))
                                        ],
                                      ),
                                      const LinearProgressIndicator(
                                        value: 0.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.red),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            return VideoScreen();
                          }),
                    ),
                  ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: "Explore"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: "Add"),
          BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions_outlined),
              activeIcon: Icon(Icons.subscriptions),
              label: "Subscription"),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library_outlined),
              activeIcon: Icon(Icons.video_library),
              label: "Library")
        ],
      ),
    );
  }
}
