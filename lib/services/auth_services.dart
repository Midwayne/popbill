import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:popbill/models/group.dart';
import 'package:popbill/models/user_expense.dart';

class AuthService {
  // final uuid = const Uuid();
  void addUserDetailsToFirestore(BuildContext context, String email) async {
    try {
      CollectionReference expensesReference =
          FirebaseFirestore.instance.collection('users');

      await expensesReference.doc(FirebaseAuth.instance.currentUser!.uid).set({
        'email': email,
      });
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unexpected error occurred. Try again.'),
        ),
      );
    }
  }

  Future<UserCredential?> signUpWithEmail(BuildContext context,
      TextEditingController email, TextEditingController password) async {
    try {
      final firebase = FirebaseAuth.instance;
      final userCredentials = await firebase.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      if (FirebaseAuth.instance.currentUser != null) {
        addUserDetailsToFirestore(context, email.text);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }

      return userCredentials;
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
      return null;
    }
  }

  Future<UserCredential?> signInWithEmail(BuildContext context,
      TextEditingController email, TextEditingController password) async {
    try {
      final firebase = FirebaseAuth.instance;
      final userCredentials = await firebase.signInWithEmailAndPassword(
          email: email.text, password: password.text);

      if (FirebaseAuth.instance.currentUser != null) {
        //Remove the bottom line before production
        addUserDetailsToFirestore(context, email.text);
        Navigator.of(context).pop();
      }

      return userCredentials;
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
      return null;
    }
  }

  void forgotPassword(BuildContext context, TextEditingController email) async {
    try {
      final firebase = FirebaseAuth.instance;
      await firebase.sendPasswordResetEmail(email: email.text);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check your email for reset link.'),
        ),
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'An error occurred. Try again.'),
        ),
      );
    }
  }

  void signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      //Add the below code only once to firestore.
      String email = FirebaseAuth.instance.currentUser!.email.toString();
      addUserDetailsToFirestore(context, email);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Welcome!'),
        ),
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void deleteAccount(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deleted successfully!'),
        ),
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'An unexpected error occurred.'),
        ),
      );
    }
  }

  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid.toString();
  }

  Future<bool> addUserExpense(BuildContext context, UserExpense expense) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    try {
      CollectionReference expensesReference = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('expenses')
          .doc('${expense.date.year}')
          .collection('${expense.date.month}');

      await expensesReference.doc(expense.id).set({
        'id': expense.id,
        'title': expense.title,
        'amount': expense.amount,
        'date': {
          'day': expense.date.day,
          'month': expense.date.month,
          'year': expense.date.year,
        },
        'time': {
          'hour': expense.time.hour,
          'minute': expense.time.minute,
        },
      });

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<List<UserExpense>> getExpenses(
      {required int filterYear, required int filterMonth}) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    List<UserExpense> expenses = [];
    String id;
    String title;
    double amount;
    DateTime date;
    TimeOfDay time;
    try {
      CollectionReference expensesReference = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('expenses')
          .doc('$filterYear')
          .collection('$filterMonth');

      QuerySnapshot expensesSnapshot =
          await expensesReference.orderBy('date.day', descending: true).get();

      for (var expenseDoc in expensesSnapshot.docs) {
        var expense = expenseDoc.data() as dynamic;

        id = expense['id'];

        title = expense['title'];

        amount = expense['amount'];

        date = DateTime(expense['date']['year'], expense['date']['month'],
            expense['date']['day']);
        time = TimeOfDay(
            hour: expense['time']['hour'], minute: expense['time']['minute']);

        expenses.add(UserExpense(
            id: id, title: title, amount: amount, date: date, time: time));
      }

      return expenses;
    } catch (error) {
      return expenses;
    }
  }

  Future<int> removeUserExpense(
      BuildContext context, UserExpense expense) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('expenses')
          .doc('${expense.date.year}')
          .collection('${expense.date.month}')
          .doc(expense.id)
          .delete();

      return 1;
    } catch (error) {
      return 0;
    }
  }

  Future<bool> verifyIfUserExists({required String userId}) async {
    try {
      // Reference to the "users" collection
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      // Get the document snapshot
      DocumentSnapshot documentSnapshot =
          await usersCollection.doc(userId).get();

      return documentSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

  void createGroup(BuildContext context, Group group) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    try {
      CollectionReference groupsCollection =
          FirebaseFirestore.instance.collection('groups');

      await groupsCollection.doc(group.groupId).set({
        'id': group.groupId,
        'name': group.groupName,
        'users': group.users,
      });

      group.users.forEach((user) async {
        CollectionReference usersCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(user['id'])
            .collection('groups');

        await usersCollection.doc(group.groupId).set({
          'id': group.groupId,
          'name': group.groupName,
          'users': group.users,
        });
      });

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Group created.'),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'An unexpected error occurred while creating expense.\nPlease try again'),
        ),
      );
    }
  }

  Future<List<Group>> getGroups() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    List<Group> groups = [];
    String id;
    String name;
    List<Map<String, String>> users;
    try {
      CollectionReference groupsReference = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('groups');

      QuerySnapshot groupsSnapshot = await groupsReference.get();

      for (var groupsDoc in groupsSnapshot.docs) {
        var group = groupsDoc.data() as dynamic;

        String id = group['id'];
        String name = group['name'];
        List<Map<String, String>> users = [];

        List<dynamic>? usersList = group['users'];

        if (usersList != null) {
          for (var userMap in usersList) {
            if (userMap is Map<String, dynamic>) {
              String userId = userMap['id'];
              String userName = userMap['nickname'];

              users.add({
                'id': userId,
                'nickname': userName,
              });
            }
          }
        }

        Group newGroup = Group(
          groupId: id,
          groupName: name,
          users: users,
        );
        //print(newGroup);

        groups.add(newGroup);
      }

      return groups;
    } catch (error) {
      return groups;
    }
  }
}
