import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import 'package:vote38/src/common/models/post.dart';

part 'timeline_view_model.g.dart';

class TimelineViewModel = _TimelineViewModel with _$TimelineViewModel;

abstract class _TimelineViewModel with Store {
  final FirebaseFirestore _firestore;

  _TimelineViewModel(this._firestore) {
    postStream();
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? firestoreSubscription;

  @observable
  bool isLoading = false;

  @observable
  ObservableList<Post> posts = ObservableList();

  @action
  void postStream() {
    firestoreSubscription = _firestore.collection('votechainupdate').doc('post').snapshots().listen((event) {
      if (event.data() == null) {
        return;
      }
      final docs = event.data()!;
      docs.forEach((key, value) {
        final post = Post.fromDocument(key, value as Map<String, dynamic>);
        posts.add(post);
      });
    });
  }

  @action
  Future<void> dispose() async {
    await firestoreSubscription?.cancel();
  }
}
