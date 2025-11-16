class Meal {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String? strInstructions;
  final String? strYoutube;
  final Map<String, String>? ingredients;

  Meal({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    this.strInstructions,
    this.strYoutube,
    this.ingredients,
  });

  factory Meal.fromJsonBrief(Map<String, dynamic> json) {
    return Meal(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
    );
  }

  factory Meal.fromJsonDetail(Map<String, dynamic> json) {
    final Map<String, String> ingredients = {};
    for (var i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients[ingredient.toString()] = measure?.toString().trim() ?? '';
      }
    }

    return Meal(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
      strInstructions: json['strInstructions'],
      strYoutube: json['strYoutube'],
      ingredients: ingredients,
    );
  }
}
