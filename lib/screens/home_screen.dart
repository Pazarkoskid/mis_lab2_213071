import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import 'category_meals_screen.dart';
import '../models/meal.dart';
import 'meal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> _categories = [];
  List<Category> _filtered = [];
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
      final cats = await ApiService.fetchCategories();
      setState(() {
        _categories = cats;
        _filtered = cats;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onSearch(String v) {
    setState(() {
      _q = v;
      _filtered = _categories
          .where((c) => c.strCategory.toLowerCase().contains(v.toLowerCase()))
          .toList();
    });
  }

  Future<void> _showRandom() async {
    try {
      final Meal meal = await ApiService.randomMeal();
      if (!mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MealDetailScreen(mealId: meal.idMeal)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch random recipe')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade200,
        title: const Text(
          'Категории',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _showRandom,
            child: const Text(
              'Рандом рецепт на денот',
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearch,
              style: TextStyle(color: Colors.grey[800]), // text color gray
              decoration: InputDecoration(
                hintText: 'Пребарај категории...',
                hintStyle: TextStyle(color: Colors.grey[500]), // hint text gray
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white, // white background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey), // gray border
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey), // gray border when not focused
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!), // darker gray border when focused
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
              childAspectRatio: 0.85,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: _filtered.length,
            itemBuilder: (context, idx) {
              final c = _filtered[idx];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            CategoryMealsScreen(category: c.strCategory)),
                  );
                },
                child: CategoryCard(category: c),
              );
            },
          ),
        ),
      ),
    );
  }
}
