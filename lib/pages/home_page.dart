import 'package:fire_crud/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_crud/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Login()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: firestoreService.getTodoStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List todoList = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = todoList[index];
                      String docID = document.id;
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String todoText = data['todo'];

                      TextEditingController textController =
                          TextEditingController(text: todoText);

                      return ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: textController,
                                onSubmitted: (newValue) {
                                  firestoreService.updateTodo(docID, newValue);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Edit todo',
                                  filled: true,
                                  fillColor: Colors.grey[800],
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                firestoreService.deleteTodo(docID);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: textController,
                  onSubmitted: (value) {
                    firestoreService.addTodo(value);
                    textController.clear();
                  },
                  decoration: InputDecoration(
                    hintText: 'Add something',
                    filled: true,
                    fillColor: Colors.grey[800],
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                firestoreService.addTodo(textController.text);
                textController.clear();
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
