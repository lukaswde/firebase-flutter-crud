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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Return an empty stream if not logged in
      return Stream<QuerySnapshot>.empty();
    }

    try {
      return todos
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .snapshots();
    } catch (e) {
      print('Error getting todo stream: $e');
      return Stream<QuerySnapshot>.empty();
    }
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
