import 'package:flutter/material.dart';

import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Container(
              color: Colors.grey.withOpacity(0.5),
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Email: email@stud.fci-cu.edu.eg',
                      softWrap: true,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black,
                          fontSize: 16,
                          height: 1.8),
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: Text(
                      'ID: 20220424',
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.black, fontSize: 16, height: 1.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(100)),
            child: Icon(
              Icons.person,
              color: Colors.grey,
              size: 60,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                "Upload a photo",
                style: TextStyle(color: Colors.black, fontSize: 20),
              )),
          SizedBox(
            height: 10,
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                "Edit Profile",
                style: TextStyle(color: Colors.black, fontSize: 20),
              )),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.red,
                  size: 20,
                ),
                SizedBox(
                  width: 3,
                ),
                TextButton(
                  onPressed: () async {
                    // await MyCache.clear();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  },
                  child: Text(
                    "Log out",
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
