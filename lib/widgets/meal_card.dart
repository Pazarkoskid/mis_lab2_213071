import 'package:flutter/material.dart';
import '../models/meal.dart';


class MealCard extends StatelessWidget {
  final Meal meal;
  const MealCard({required this.meal, super.key});


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), child: Image.network(meal.strMealThumb, fit: BoxFit.cover))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(meal.strMeal, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}