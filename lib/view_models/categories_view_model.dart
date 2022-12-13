import 'package:device_shop_admin/data/models/category.dart';
import 'package:device_shop_admin/data/repositories/categories_repository.dart';
import 'package:flutter/cupertino.dart';

class CategoriesViewModel extends ChangeNotifier {
  final CategoryRepository categoryRepository;

  CategoriesViewModel({required this.categoryRepository});

//  List<CategoryModel> categories = [];

  Stream<List<CategoryModel>> listenCategories() => categoryRepository.getCategories();

  addCategory(CategoryModel categoryModel) =>
      categoryRepository.addCategory(categoryModel: categoryModel);

  updateCategory(CategoryModel categoryModel) =>
      categoryRepository.updateCategory(categoryModel: categoryModel);

  deleteCategory(String docId) =>
      categoryRepository.deleteCategory(docId: docId);
}
