import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_viewmodel.dart';
import '../view_models/chat_viewmodel.dart';
import '../views/create_group_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _fabOpacity;
  late Animation<Offset> _fabPosition;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _fabAnimationController();
  }

  void _fabAnimationController() {
    _scrollController = ScrollController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fabOpacity =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
    _fabPosition = Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1))
        .animate(_animationController);

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_animationController.isCompleted) return;
        _animationController.forward();
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_animationController.isDismissed) return;
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    var authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    if (authViewModel.userModel == null) {
      print('fetching user data');
      await authViewModel.fetchUserData(authViewModel.userModel!.user!);
    }

    if (authViewModel.userModel!.profilePicture.isEmpty) {
      print('getting profile picture');
      await authViewModel.getProfilePicture();
    }
  }

  @override
  Widget build(BuildContext context) {
    var authViewModel = Provider.of<AuthViewModel>(context);
    var chatViewModel = Provider.of<ChatViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatterBox'),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            //scaffoldKey.currentState!.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 25,
              child: authViewModel.userModel!.profilePicture.isEmpty
                  ? Text(authViewModel.userModel!.name.substring(0, 1))
                  : ClipOval(
                      child: Image.network(
                        authViewModel.userModel!.profilePicture,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(authViewModel.userModel!.name[0]);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
            ),
            Row(children: [
              IconButton(
                icon: const Icon(Icons.contacts),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ]),
          ],
        ),
      ),
      floatingActionButton: SlideTransition(
        position: _fabPosition,
        child: FadeTransition(
          opacity: _fabOpacity,
          child: FloatingActionButton.extended(
            backgroundColor: Theme.of(context)
                .elevatedButtonTheme
                .style!
                .backgroundColor
                ?.resolve({WidgetState.pressed}),
            elevation: 4.0,
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Start a Chat'),
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const CreateGroupScreen();
              })).then((value) {
                if (value == 'refresh') {
                  //refresh chatrooms
                }
              });
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                //controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Color(0xFF211f26),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: chatViewModel.chatRooms.length,
                itemBuilder: (context, index) {
                  var chatRoom = chatViewModel.chatRooms[index];
                  return InkWell(
                    onLongPress: () => {},
                    onTap: () {
                      //_deleteNote(index);
                    },
                    child: ListTile(
                      style: ListTileStyle.list,
                      leading: CircleAvatar(
                        backgroundImage: chatRoom.profilePictureURL!.isEmpty
                            ? null
                            : NetworkImage(chatRoom.profilePictureURL!),
                        child: chatRoom.profilePictureURL!.isEmpty
                            ? Text(chatRoom.name[0])
                            : null,
                      ),
                      title: Text(
                        chatRoom.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Just a dummy last message because I am lazy',
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        '12:00 PM',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
