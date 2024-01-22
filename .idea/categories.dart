import 'package:flutter/material.dart';

import '../../data/dummy_data.dart';
import '../../models/meal.dart';
import '../../widgets/category_grid_item.dart';
import './meals.dart';
import '../../models/category.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.availableMeals,
  });

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  //take away single keyword for multiple animations
  late AnimationController
      _animationController; // late can be used to delay the creation of a variable till it is going to be used

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0, //dictates where animation plays
      upperBound:
          1, // upper and lower bound must always be specified for explicit animation
    );

    _animationController
        .forward(); //tells the animation to begin when page is rebuilt
  }

  @override
  void dispose() {
    _animationController
        .dispose(); //disposes animation after it has finished playing

    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    ); // Navigator.push(context, route)
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          // availableCategories.map((category) => CategoryGridItem(category: category)).toList()
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            )
        ],
      ),
      builder: (context, child) => SlideTransition(
        position: _animationController.drive(
          Tween(
            //describes transition beTween two values
            begin: const Offset(0, 0.3),
            //values are a percent and describe the points they start and end at
            end: const Offset(0, 0), // with zero
          ),//describes how animation is shown
        ),
        child: child,
      ),
    );
  }
}
