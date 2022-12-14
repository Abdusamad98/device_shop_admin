import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_shop_admin/data/models/category.dart';
import 'package:device_shop_admin/data/models/user_model.dart';
import 'package:device_shop_admin/utils/my_utils.dart';

class UsersRepository {
  final FirebaseFirestore _firestore;

  UsersRepository({required FirebaseFirestore firebaseFirestore})
      : _firestore = firebaseFirestore;


  Future<void> deleteUser({required String docId}) async {
    try {
      await _firestore.collection("users").doc(docId).delete();
      MyUtils.getMyToast(message: "User muvaffaqiyatli o'chirildi!");
    } on FirebaseException catch (er) {
      MyUtils.getMyToast(message: er.message.toString());
    }
  }

  Stream<List<UserModel>> getUsers() =>
      _firestore.collection("users").snapshots().map(
            (event1) => event1.docs
                .map((doc) => UserModel.fromJson(doc.data()))
                .toList(),
          );
}
