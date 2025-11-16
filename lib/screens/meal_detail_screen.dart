import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  const MealDetailScreen({required this.mealId, super.key});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  Meal? _meal;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final meal = await ApiService.lookupMeal(widget.mealId);
      setState(() => _meal = meal);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to load meal')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildIngredients() {
    if (_meal == null || _meal!.ingredients == null) return const SizedBox();
    final items = _meal!.ingredients!.entries.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            '- ${e.key} : ${e.value}',
            style: TextStyle(fontSize: 14, color: Colors.green[800]),
          ),
        ),
      )
          .toList(),
    );
  }

  Future<void> _openYoutube() async {
    final url = _meal?.strYoutube;
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final greenColor = Colors.green[800]!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent.shade200,
        title: Text(
          _meal?.strMeal ?? 'Рецепт',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.greenAccent.shade100,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _meal == null
            ? Center(
          child: Text(
            'Нема податоци',
            style: TextStyle(color: greenColor),
          ),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(_meal!.strMealThumb),
              ),
              const SizedBox(height: 12),
              Text(
                _meal!.strMeal,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: greenColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Instructions:',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: greenColor),
              ),
              const SizedBox(height: 8),
              Text(
                _meal!.strInstructions ?? '',
                style: TextStyle(fontSize: 16, color: greenColor),
              ),
              const SizedBox(height: 20),
              Text(
                'Ingredients:',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: greenColor),
              ),
              const SizedBox(height: 8),
              _buildIngredients(),
              const SizedBox(height: 24),
              if (_meal!.strYoutube != null && _meal!.strYoutube!.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: _openYoutube,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Open YouTube'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
