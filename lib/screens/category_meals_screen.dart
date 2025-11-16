import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class CategoryMealsScreen extends StatefulWidget {
  final String category;
  const CategoryMealsScreen({required this.category, super.key});

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  List<Meal> _meals = [];
  List<Meal> _filtered = [];
  bool _loading = true;
  String _q = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final meals = await ApiService.fetchMealsByCategory(widget.category);
      setState(() {
        _meals = meals;
        _filtered = meals;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _search(String q) async {
    setState(() => _q = q);
    if (q.trim().isEmpty) {
      setState(() => _filtered = _meals);
      return;
    }
    try {
      final results = await ApiService.searchMeals(q);
      final filtered = results.where((m) => m.idMeal.isNotEmpty).toList();
      setState(() {
        _filtered = filtered
            .where((m) => m.strMeal.toLowerCase().contains(q.toLowerCase()))
            .toList();
      });
    } catch (e) {
      setState(() => _filtered = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade200,
        title: Text(
          widget.category,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _search,
              style: TextStyle(color: Colors.grey[800]),
              decoration: InputDecoration(
                hintText: 'Пребарај јадења...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.greenAccent.shade100,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: _load,
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: _filtered.length,
            itemBuilder: (context, idx) {
              final m = _filtered[idx];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              MealDetailScreen(mealId: m.idMeal)));
                },
                child: MealCard(meal: m),
              );
            },
          ),
        ),
      ),
    );
  }
}
