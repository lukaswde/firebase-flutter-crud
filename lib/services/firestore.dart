import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get Todo's
  final CollectionReference todos =
      FirebaseFirestore.instance.collection('todos');

  // CREATE: add a new Todo
  Future<void> addTodo(String todo) {
    return todos.add({
      'todo': todo,
      'timestamp': Timestamp.now(),
    });
  }

  // READ: get notes from database
  Stream<QuerySnapshot> getTodoStream() {
    final todoStream = todos.orderBy('timestamp', descending: true).snapshots();

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
