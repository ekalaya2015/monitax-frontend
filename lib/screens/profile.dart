import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monitax/widgets/display_image.dart';
import 'package:flutter/material.dart';
import 'package:monitax/provider/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:monitax/models/user.dart';
import 'package:monitax/screens/edit_name.dart';
import 'package:monitax/screens/edit_address.dart';
import 'package:monitax/screens/edit_phone.dart';
import 'package:monitax/screens/reset_password.dart';
import 'package:monitax/screens/device_map.dart';
import '../models/device.dart';
import 'package:monitax/screens/home.dart';
import 'package:image/image.dart' as img;
import 'package:monitax/services/user_api.dart';
import 'package:camera/camera.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureProvider<User?>(
        create: (context) => UserProvider().getUser,
        initialData: User(
            id: "loading ...",
            nik: "loading ...",
            first_name: "loading ...",
            last_name: "",
            picture: "",
            username: "loading ...",
            address: "loading ...",
            phone_no: "loading ...",
            role: "loading ...",
            devices: []),
        builder: (context, child) {
          final user = context.watch<User>();
          return DefaultTabController(
              length: 2,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const HomePage(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Icon(Icons.home),
                ),
                appBar: AppBar(
                  title: const Text('Profile'),
                  bottom: const TabBar(tabs: [
                    Tab(
                      icon: Icon(Icons.account_circle_rounded),
                    ),
                    Tab(
                      icon: Icon(Icons.devices_other_rounded),
                    )
                  ]),
                ),
                body: TabBarView(children: [
                  UserProfile(user: user),
                  DeviceProfile(user: user)
                ]),
              ));
        },
      ),
    );
  }
}

class DeviceProfile extends StatefulWidget {
  const DeviceProfile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<DeviceProfile> createState() => _DeviceProfileState();
}

class _DeviceProfileState extends State<DeviceProfile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                widget.user.devices[index].isExpanded = !isExpanded;
              });
            },
            children: widget.user.devices.map<ExpansionPanel>((Device device) {
              return ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                        title: Text(
                      device.name,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 12),
                    ));
                  },
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                color: Colors.grey.shade200,
                                child: SizedBox(
                                  height: 32,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Text(
                                    'Desc: ',
                                    softWrap: true,
                                    maxLines: 2,
                                    style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.grey.shade200,
                                child: SizedBox(
                                  height: 32,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                    device.description,
                                    softWrap: true,
                                    maxLines: 2,
                                    style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 32,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Text(
                                  'Serial#: ',
                                  style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 32,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  device.serial_num,
                                  style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                color: Colors.grey.shade200,
                                child: SizedBox(
                                  height: 32,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: Text(
                                    'Status: ',
                                    style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.grey.shade200,
                                child: SizedBox(
                                  height: 32,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                    device.status,
                                    style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 32,
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Text(
                                  'Location',
                                  style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height: 32,
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: InkWell(
                                        onTap: () {
                                          navigateSecondPage(
                                              context,
                                              DeviceMap(
                                                  name: device.name,
                                                  lat: device.lat,
                                                  lon: device.lon));
                                        },
                                        child: const Icon(
                                          Icons.pin_drop_outlined,
                                          size: 24,
                                        )),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  isExpanded: device.isExpanded);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class UserProfile extends StatefulWidget {
  const UserProfile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String strImage = '';
  bool loaded = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      loaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 20, left: 40),
      child: Column(
        children: [
          InkWell(
              onTap: () async {
                ImagePicker picker = ImagePicker();
                XFile? image =
                    await picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  final bytes = await io.File(image.path).readAsBytes();
                  img.Image? _img = img.decodeImage(bytes);
                  String tempPath = (await getTemporaryDirectory()).path;
                  io.File file = io.File('$tempPath/profile.jpg');
                  await file.writeAsBytes(bytes);
                  String _strimage = await UserApi().upload(file);
                  if (_strimage.isNotEmpty) {
                    setState(() {
                      loaded = true;
                      strImage = _strimage;
                    });
                  }
                }
              },
              child: DisplayImage(
                strimage: (loaded) ? strImage : widget.user.picture,
                onPressed: () {},
              )),
          Text(
            widget.user.role,
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          buildUserInfoDisplay(
              context,
              '${widget.user.first_name} ${widget.user.last_name}',
              'Name',
              true,
              EditName()),
          buildUserInfoDisplay(
              context, widget.user.username, 'Email', false, null),
          buildUserInfoDisplay(context, widget.user.nik, 'NIK', false, null),
          buildUserInfoDisplay(
              context, widget.user.address, 'Address', true, EditAddress()),
          buildUserInfoDisplay(
              context, widget.user.phone_no, 'Phone', true, EditPhone()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  child: ElevatedButton(
                onPressed: () {
                  navigateSecondPage(context, ResetPassword());
                },
                child: const Text('reset password'),
              )),
            ],
          )
        ],
      ),
    );
  }
}

Widget buildUserInfoDisplay(BuildContext context, String getValue, String title,
        bool canBeEdited, Widget? editpage) =>
    Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 48,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ))),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Expanded(
                      child: Text(
                    getValue,
                    // overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: true,
                    style: const TextStyle(fontSize: 11),
                  )),
                  canBeEdited
                      ? GestureDetector(
                          onTap: () {
                            navigateSecondPage(context, editpage);
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.grey,
                            size: 16.0,
                          ),
                        )
                      : const Icon(
                          Icons.lock,
                          color: Colors.grey,
                          size: 16,
                        )
                ]))
          ],
        ));

void navigateSecondPage(BuildContext context, editPage) {
  Route route = MaterialPageRoute(builder: (context) => editPage);
  Navigator.push(context, route).then(onGoBack);
}

FutureOr onGoBack(value) {}
