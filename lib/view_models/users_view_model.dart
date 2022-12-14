import 'package:device_shop_admin/data/models/category.dart';
import 'package:device_shop_admin/data/models/user_model.dart';
import 'package:device_shop_admin/data/repositories/categories_repository.dart';
import 'package:device_shop_admin/data/repositories/users_repository.dart';
import 'package:flutter/cupertino.dart';

class UsersViewModel extends ChangeNotifier {
  final UsersRepository usersRepository;

  UsersViewModel({required this.usersRepository});

//  List<CategoryModel> categories = [];

  Stream<List<UserModel>> listenUsers() => usersRepository.getUsers();


  deleteUser(String docId) =>
      usersRepository.deleteUser(docId: docId);
}
