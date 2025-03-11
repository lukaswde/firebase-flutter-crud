import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference todos =
      FirebaseFirestore.instance.collection('todos');

  // CREATE: add a new Todo
  Future<void> addTodo(String todo) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return todos.add({
      'todo': todo,
      'timestamp': Timestamp.now(),
      'userId': userId,
    });
  }

  // READ: get notes from database
  Stream<QuerySnapshot> getTodoStream() {
    String userId =
        FirebaseAuth.instance.currentUser!.uid; // FIXME check userId
    final todoStream = todos
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
    return todoStream;
  }

  // UPDATE: update Todo's given a doc id
  Future<void> updateTodo(String docId, String newTodo) {
    return todos.doc(docId).update({
      'todo': newTodo,
      'timestamp': Timestamp.now(),
    });
  }

  // DELETE: delete Todo's given a doc id
  Future<void> deleteTodo(String docId) {
    return todos.doc(docId).delete();
  }
}
