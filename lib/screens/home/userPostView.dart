import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_project/models/user.dart';
import 'package:school_project/screens/home/viewSpecificPost.dart';
import 'package:school_project/shared/loading.dart';



class UserPostView extends StatefulWidget {
  @override
  _UserPostViewState createState() => _UserPostViewState();
}

class _UserPostViewState extends State<UserPostView> {

  Color mainColor = Color.fromRGBO(0, 29, 38, 100);

  Color blueText = Color.fromRGBO(0, 207, 255, 100);

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  bool loading = false;
  Widget buildBody(BuildContext context, DocumentSnapshot ds) {
    var date = ds['postDate'].toDate();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewSpecificPost(userPost: ds),
          ),
          );
        },
          child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 124.0,
                decoration: new BoxDecoration(
                  color: new Color(0xFF333366),
                shape: BoxShape.rectangle,
                  borderRadius: new BorderRadius.circular(8.0),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(  
                      color: Colors.black12,
                      blurRadius: 10.0,
                      offset: new Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        if (ds['imageUrl'] != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                              backgroundImage: NetworkImage(ds['imageUrl']),
                              ),
                          ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                ds['subject'],
                                style: TextStyle(color: blueText, fontSize: 20.0),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(formattedDate, style: TextStyle(fontSize: 20.0, color: blueText),),
                            )
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget build (BuildContext context) {
    final currentUser = Provider.of<User>(context);
    final String currentUserId = currentUser.uid.toString();
    CollectionReference userDataRef = Firestore.instance.collection('posts').document(currentUserId).collection('userPosts');
    var filter = userDataRef.where('subject' + 'physics', isEqualTo: true);
    return loading ? Loading() : Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        title: Text(
          "Your posts",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('posts').document(currentUserId).collection('userPosts').orderBy('postDate', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
            itemExtent: 80.0,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
              buildBody(context, snapshot.data.documents[index]),
            );
          }
          else {
            return Loading();
          }
        }
      ),
    );
  }
}