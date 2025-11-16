import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';


class ApiService {
  static const _base = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<Category>> fetchCategories() async {
    final url = '$_base/categories.php';
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) {
      throw Exception('Failed to load categories');
    }
    final data = json.decode(resp.body);
    final List categoriesJson = data['categories'] ?? [];
    return categoriesJson.map((c) => Category.fromJson(c)).toList();
  }

  static Future<List<Meal>> fetchMealsByCategory(String category) async {
    final url = '$_base/filter.php?c=$category';
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) {
      throw Exception('Failed to load meals for category');
    }
    final data = json.decode(resp.body);
    final List mealsJson = data['meals'] ?? [];
    return mealsJson.map((m) => Meal.fromJsonBrief(m)).toList();
  }

  static Future<List<Meal>> searchMeals(String query) async {
    final url = '$_base/search.php?s=$query';
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) {
      throw Exception('Search failed');
    }
    final data = json.decode(resp.body);
    final List? mealsJson = data['meals'];
    if (mealsJson == null) return [];
    return mealsJson.map((m) => Meal.fromJsonDetail(m)).toList();
  }

  static Future<Meal> lookupMeal(String id) async {
    final url = '$_base/lookup.php?i=$id';
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) {
      throw Exception('Lookup failed');
    }
    final data = json.decode(resp.body);
    final List? mealsJson = data['meals'];
    if (mealsJson == null || mealsJson.isEmpty) {
      throw Exception('Meal not found');
    }
    return Meal.fromJsonDetail(mealsJson.first);
  }

  static Future<Meal> randomMeal() async {
    final url = '$_base/random.php';
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) {
      throw Exception('Random failed');
    }
    final data = json.decode(resp.body);
    final List? mealsJson = data['meals'];
    if (mealsJson == null || mealsJson.isEmpty) {
      throw Exception('No random meal');
    }
    return Meal.fromJsonDetail(mealsJson.first);
  }
}
