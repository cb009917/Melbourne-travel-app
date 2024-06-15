import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:ionicons/ionicons.dart";
import 'package:ionicons/ionicons.dart';
import "package:like_button/like_button.dart";

class RiverCruise extends StatelessWidget {
  const RiverCruise({super.key});

  //Adding bookmark
  Future<void> addBookmark(String itemid) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('User_info').doc(user.uid);
      // Add the bookmark item
      await userDoc.collection('bookmark').doc(itemid).set({
        'name': itemid,
      });
    } else {
      print('No user is currently signed in.');
    }
    print(user?.uid);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('Assests/Icons/river_cruise.jpg'),
                          fit: BoxFit.cover)),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                )
              ]),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("River Cruise",
                    style: TextStyle(
                      fontSize: 28,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_sharp,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Open AT", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            Text("6 Days")
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Ratings", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            Text("4.2")
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Likes", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            Text("89")
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: const Text(
                  "Embark on a serene river cruise through the heart of Melbourne. Glide past iconic landmarks and stunning cityscapes on a peaceful journey along the Yarra River. This relaxing excursion offers a unique perspective of the city's beauty, combining leisure with sightseeing, perfect for those looking to unwind and explore Melbourne's charm from the water.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LikeButton(
                    size: 31,
                    circleColor: CircleColor(
                        start: Color(0xff00ddff), end: Color(0xff0099cc)),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Color(0xff33b5e5),
                      dotSecondaryColor: Color(0xff0099cc),
                    ),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 40,
                      );
                    },
                  ),
                  LikeButton(
                    onTap: (bool isLiked) async {
                      if (isLiked) {
                        return false;
                      } else {
                        addBookmark("A2");
                        return true;
                      }
                    },
                    size: 31,
                    circleColor: CircleColor(
                        start: Color(0xff00ddff), end: Color(0xff0099cc)),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Color(0xff33b5e5),
                      dotSecondaryColor: Color(0xff0099cc),
                    ),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.bookmark,
                        color: isLiked ? Colors.yellow : Colors.grey,
                        size: 40,
                      );
                    },
                  ),
                  Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green),
                    child: Center(
                      child: Text(
                        "AUD 75",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
