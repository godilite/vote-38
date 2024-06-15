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

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? firestoreSubscription;

  @observable
  bool isLoading = false;

  @observable
  ObservableList<Post> posts = ObservableList();

  @action
  void postStream() {
    DocumentChange<Map<String, dynamic>>? change;
    firestoreSubscription = _firestore
        .collection('votechainupdate')
        .where('type', isEqualTo: 'post')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .listen((event) {
      change = event.docChanges.first;
      if (change!.type == DocumentChangeType.added) {
        final data = change!.doc.data();
        final post = Post.fromDocument(data ?? {});
        posts.add(post);
      }
    });
  }

  @action
  Future<void> dispose() async {
    await firestoreSubscription?.cancel();
  }
}
