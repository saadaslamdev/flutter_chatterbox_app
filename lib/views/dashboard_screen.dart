import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:globatchat_app/views/create_group_screen.dart';
import 'package:globatchat_app/views/splash_screen.dart';
import 'package:provider/provider.dart';

import '../view_models/auth_viewmodel.dart';
import '../view_models/chat_viewmodel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    fetchUserData();
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
                  child: CircleAvatar(
                    radius: 20,
                    child: authViewModel.userModel!.profilePicture.isEmpty
                        ? Text(authViewModel.userModel!.name.substring(0, 1))
                        : ClipOval(
                            child: Image.network(
                              authViewModel.userModel!.profilePicture,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Text(authViewModel.userModel!.name
                                    .substring(0, 1));
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                  )),
            )),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
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
        floatingActionButton: FloatingActionButton.extended(
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Center(
          child: authViewModel.userModel == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(authViewModel.userModel!.name),
                    Text(authViewModel.userModel!.email),
                    Text(authViewModel.userModel!.id),
                    Text(authViewModel.userModel!.phoneNumber),
                    Text(
                        'profilePicture: ${authViewModel.userModel!.profilePicture}'),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.network(
                        authViewModel.userModel!.profilePicture,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: WidgetStateProperty.all(const Size(200, 50)),
                      ),
                      onPressed: () async {
                        await authViewModel.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SplashScreen(),
                          ),
                        );
                      },
                      child:
                          const Text('SIGNOUT', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
        ));
  }
}
