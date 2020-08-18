
import 'package:sqflite/sqflite.dart';

import 'DataModels.dart';

class AddToCategories
{

  addCategories(Database db, List<String> userCategories) async
  {
    userCategories.forEach((element)  async {
      if (element != "") {
        Category newCategory = Category();
        newCategory.name = element;

        var res = await db.insert("Categories", newCategory.toMap());
        print("new category added called " + newCategory.name);
      }
    });
  }

}

class GetFromCategories
{
  Future<List<String>> getAllCategories(Database db)
  async {
    var res = await
    db.query("Categories");

    List<Category> list =
    res.isNotEmpty ? res.map((c) => Category.fromMap(c)).toList() : [];

    List<String> allCategories = [];
    list.forEach((category) {
      allCategories.add(category.name);
    });

    return allCategories;
  }
}

class UpdateFromCategories
{
  void updateCategories(Database db, List<String> userCategories)
  {
    //It is most likely that if there are any changes it would be everything has to change
    DeleteFromCategories().deleteAll(db);
    AddToCategories().addCategories(db, userCategories);
  }
}

class DeleteFromCategories
{
  void deleteAll(Database db)
  {
    db.delete("Categories");
  }
}