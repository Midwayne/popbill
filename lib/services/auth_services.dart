import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:popbill/models/group.dart';
import 'package:popbill/models/group_expense.dart';
import 'package:popbill/models/group_item.dart';
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
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  void signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'An unexpected error occurred.'),
        ),
      );
    }
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
    CollectionReference groupsCollection =
        FirebaseFirestore.instance.collection('groups');

    await groupsCollection.doc(group.groupId).set({
      'id': group.groupId,
      'name': group.groupName,
      'users': group.users,
      'timestamp': group.timestamp.toString(),
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
  }

  Future<List<Group>> getGroups() async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    List<Group> groups = [];
    String id;
    String name;
    String timestamp;
    List<Map<String, String>> users;
    try {
      CollectionReference userGroupsReference = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('groups');

      QuerySnapshot userGroupsSnapshot = await userGroupsReference.get();

      CollectionReference groupsReference =
          FirebaseFirestore.instance.collection('groups');

      for (var groupsDoc in userGroupsSnapshot.docs) {
        var userGroup = groupsDoc.data() as dynamic;

        String documentId = userGroup['id'];

        DocumentSnapshot groupsSnapshot =
            await groupsReference.doc(documentId).get();

        var group = groupsSnapshot.data() as dynamic;
        id = group['id'];
        name = group['name'];
        timestamp = group['timestamp'];
        users = [];

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
          timestamp: DateTime.parse(timestamp),
        );

        groups.add(newGroup);
      }

      // Sort the list of groups based on timestamp in descending order
      groups.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return groups;
    } catch (error) {
      return groups;
    }
  }

  void addGroupExpense(GroupExpense expense) async {
    CollectionReference groupsTransactionReference = FirebaseFirestore.instance
        .collection('groups')
        .doc(expense.groupId)
        .collection('transactions');

    Map<String, dynamic> expenseData = {
      'groupId': expense.groupId,
      'expenseId': expense.expenseId,
      'title': expense.title,
      'totalAmount': expense.totalAmount,
      'paidBy': expense.paidBy,
      'date': {
        'day': expense.date.day,
        'month': expense.date.month,
        'year': expense.date.year,
      },
      'time': {
        'hour': expense.time.hour,
        'minute': expense.time.minute,
      },
      'items': expense.items
          .map((item) => {
                'itemTitle': item.itemTitle,
                'itemPrice': item.itemPrice,
                'itemQuantity': item.itemQuantity,
                'consumerProportions': item.consumerProportions,
              })
          .toList(),
    };

    await groupsTransactionReference.doc(expense.expenseId).set(expenseData);
  }

  Future<List<GroupExpense>> getGroupExpenses(String groupId) async {
    try {
      CollectionReference groupsCollection =
          FirebaseFirestore.instance.collection('groups');

      CollectionReference groupsTransactionReference =
          groupsCollection.doc(groupId).collection('transactions');

      QuerySnapshot expensesSnapshot = await groupsTransactionReference.get();

      List<GroupExpense> expenses = [];

      for (var expenseDoc in expensesSnapshot.docs) {
        var expenseData = expenseDoc.data() as Map<String, dynamic>;

        GroupExpense expense = GroupExpense(
          groupId: expenseData['groupId'],
          expenseId: expenseData['expenseId'],
          title: expenseData['title'],
          totalAmount: expenseData['totalAmount'],
          paidBy: expenseData['paidBy'],
          date: DateTime(
            expenseData['date']['year'],
            expenseData['date']['month'],
            expenseData['date']['day'],
          ),
          time: TimeOfDay(
            hour: expenseData['time']['hour'],
            minute: expenseData['time']['minute'],
          ),
          items: (expenseData['items'] as List<dynamic>).map((item) {
            return GroupItem(
              itemTitle: item['itemTitle'],
              itemPrice: item['itemPrice'],
              itemQuantity: item['itemQuantity'],
              consumerProportions:
                  (item['consumerProportions'] as List<dynamic>)
                      .map((consumer) {
                return {
                  'id': consumer['id'],
                  'share': consumer['share'],
                };
              }).toList(),
            );
          }).toList(),
        );

        expenses.add(expense);
      }

      return expenses;
    } catch (error) {
      print(error);
      return [];
    }
  }
}
