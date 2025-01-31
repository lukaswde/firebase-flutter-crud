import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_crud/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Firestore
  final FirestoreService firestoreService = FirestoreService();

  // TextController
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        // backgroundColor: Theme.of(context).colorScheme.primary,
      ),

      // Body
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getTodoStream(),
        builder: (context, snapshot) {
          // if there is data get all the documents
          if (snapshot.hasData) {
            List todoList = snapshot.data!.docs;

            // display a list of todos
            return ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                // get each individual document
                DocumentSnapshot document = todoList[index];
                String docID = document.id;

                // get todo from each document
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String todoText = data['todo'];

                // display as a ListTile
                return ListTile(
                  title: Text(todoText),
                );
              },
            );
          }

          // if there is no data return nothing
          else {
            return const Text("No Todo's...");
          }
        },
      ),

      // Footer
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: textController,
                  cursorColor: Colors.white54,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add something',
                    hintStyle: const TextStyle(color: Colors.white54),
                    focusColor: Colors.white,
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
                // add a new todo
                firestoreService.addTodo(textController.text);

                // clear the textController
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
