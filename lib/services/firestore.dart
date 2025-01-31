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

  // DELETE: delete Todo's given a doc id
}
