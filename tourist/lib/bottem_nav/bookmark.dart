import "dart:convert";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class BookMark extends StatefulWidget {
  const BookMark({super.key});

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  final user = FirebaseAuth.instance.currentUser;
  List items = [];

  Future<List<Map<String, dynamic>>> getBookmarks(String userID) async {
    try {
      // Reference to the user's document
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('User_info').doc(userID);

      // Get the bookmarks subcollection
      QuerySnapshot bookmarkSnapshot =
          await userDoc.collection('bookmark').get();

      // Extract the data from the documents
      List<Map<String, dynamic>> bookmarks = bookmarkSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return bookmarks;
    } catch (e) {
      print('Error getting bookmarks: $e');
      return [];
    }
  }

  Future<void> getbookmark() async {
    final String response =
        await rootBundle.loadString('Assests/activities.json');
    final data = await json.decode(response);
    List<dynamic> allItems = data["items"];

    List<Map<String, dynamic>> userBookmarks = await getBookmarks(user!.uid);
    List<String> bookmarkIds =
        userBookmarks.map((bookmark) => bookmark['name'] as String).toList();

    List<dynamic> filteredItems = allItems.where((item) {
      return bookmarkIds.contains(item['id']);
    }).toList();

    // Update state with filtered items
    setState(() {
      items = filteredItems;
    });
  }

  void getdata() async {
    List<Map<String, dynamic>> userBookmarks = await getBookmarks(user!.uid);

    for (var bookmark in userBookmarks) {
      print(bookmark['name']); // Print each bookmark's name
    }
  }

  @override
  void initState() {
    super.initState();
    getbookmark();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Bookmarks'),
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: items.isEmpty
                  ? Center(child: Text("No bookmarks available"))
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        print(items[index]['img']);
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, items[index]['link']);
                          },
                          child: Container(
                            height: 180, // Specify the height of the card
                            width: double
                                .maxFinite, // Specify the width of the card
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Card(
                              elevation: 0.5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(13),
                                      child: Image.asset(
                                        items[index]['img'],
                                        height: 150,
                                        width: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 180,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              items[index]['name'],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.location_pin,
                                                    color: Colors.red),
                                                Expanded(
                                                  child: Text(
                                                      items[index]['address'],
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .grey[600])),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow,
                                                    ),
                                                    Text(
                                                        items[index]['rating']),
                                                  ],
                                                ),
                                                Text(
                                                  items[index]['price'],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.green),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ));
  }
}
