import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class AuthService{
  Future<String?> registerUsers(String firstName,String lastName ,String email, String password, BuildContext context)async{
    try{
      UserCredential cred = await auth.createUserWithEmailAndPassword(email: email, password: password);
      await firestore.collection('Users').doc(cred.user!.uid).set({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password":password,
        "image":null
      });
      await firestore.collection('Transactions').doc(cred.user!.uid).set({
        "transactions":[]
      });
      return 'Account created successfully';
    }on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'This email is already in use.';
      }else if(e.code == 'weak-password'){
        return ' The given password is invalid. [ Password should be at least 6 characters ]';
      } else {
        return e.code;
      }
    } catch (e) {
      print(e);
      return 'An unknown error occurred.';
    }
  }

  Future<String?> loginUsers(String email, String password)async{
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return 'login Successful';
    }on FirebaseAuthException catch(e){
      if(e.code == 'invalid-credential'){
        return 'There are no valid credentials for this account. Please try signing up instead';
      }
      return e.code;
    }catch(e){
      return e.toString();
    }
  }

  Future logOut()async{
    await auth.signOut();
  }

  Future<String?> forgotPassword({required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return "Password reset sent to your email";
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}