import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_media/res/color.dart';
import 'package:tech_media/res/component/round_button.dart';
import 'package:tech_media/utils/routes/route_name.dart';
import 'package:tech_media/view/dashboard/profile/profile_controller.dart';
import 'package:tech_media/view/services/session_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ref = FirebaseDatabase.instance.ref('User');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ChangeNotifierProvider(
        create: (_) => ProfileController(),
        child: Consumer<ProfileController>(
          builder: ((context, provider, child) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: StreamBuilder(
                  stream:
                      ref.child(SessionController().userId.toString()).onValue,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Container(
                                    height: 130,
                                    width: 130,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(500),
                                        child: provider.image == null
                                            ? map['profile'].toString() == ''
                                                ? Icon(
                                                    Icons.person,
                                                    size: 45,
                                                  )
                                                : Image(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        map['profile']
                                                            .toString()),
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    },
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Container(
                                                        child: Icon(
                                                          Icons.error_outline,
                                                          color: AppColors
                                                              .alertColor,
                                                        ),
                                                      );
                                                    },
                                                  )
                                            : Stack(
                                                children: [
                                                  Image.file(
                                                      File(provider.image!.path)
                                                          .absolute),
                                                  Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ],
                                              )),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.primaryTextTextColor,
                                        width: 5,
                                      ),
                                      //   borderRadius: BorderRadius.circular(200),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  provider.pickImage(context);
                                },
                                child: const CircleAvatar(
                                  radius: 14,
                                  backgroundColor: AppColors.primaryIconColor,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          GestureDetector(
                            onTap: () {
                              provider.showUserNameDialogAlert(
                                  context, map['userName']);
                            },
                            child: ReusableRow(
                                title: 'Username',
                                iconData: Icons.person_outline,
                                value: map['userName']),
                          ),
                          GestureDetector(
                            onTap: () {
                              provider.showPhoneDialogAlert(
                                  context, map['phone']);
                            },
                            child: ReusableRow(
                              title: 'Phone',
                              iconData: Icons.phone_outlined,
                              value: map['phone'] == ''
                                  ? 'xxx-xxx-xxx'
                                  : map['phone'],
                            ),
                          ),
                          ReusableRow(
                            title: 'Email',
                            iconData: Icons.email_outlined,
                            value: map['email'],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          RoundButton(
                              title: 'Log out',
                              onPress: () {
                                Navigator.pushNamed(
                                    context, RouteName.loginView);
                              }),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text(
                          'Something went wrong',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      );
                    }
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title, value;
  final IconData iconData;
  const ReusableRow(
      {super.key,
      required this.title,
      required this.iconData,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          leading: Icon(
            iconData,
            color: AppColors.primaryIconColor,
          ),
          trailing: Text(
            value,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        Divider(
          color: AppColors.dividedColor.withOpacity(0.5),
        )
      ],
    );
  }
}
