import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: const FoodMenuPage(),
      ),
    );
  }
}

class FoodMenuPage extends StatelessWidget {
  const FoodMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // Keeping the Green Border you liked, but ensuring strict compliance inside
        height: 850, // Fixed height to make SpaceBetween work
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.green,
            width: 3.0,
          ),
          // borderRadius is removed, so corners are now sharp (rectangular)
        ),

        child: Column(
          // REQUIREMENT: "The Column( ) uses SpaceBetween for the layout"
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1 -> title
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                "BROWSE CATEGORIES",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: 2.0),
              ),
            ),

            // 2 -> description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Not sure about exactly which recipe you're looking for? Do a search, or dive into our most popular categories.",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),

            // 3-> header: By Meat
            const Text(
              "BY MEAT",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.5),
            ),

            // 4. Row: Meat Images
            // text written in the middle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFoodItem('assets/images/beef.jpg', 'BEEF'),
                _buildFoodItem('assets/images/chicken.jpg', 'CHICKEN'),
                _buildFoodItem('assets/images/pork.jpg', 'PORK'),
                _buildFoodItem('assets/images/seafood.jpg', 'SEAFOOD'),
              ],
            ),

            // 5. Header: By Course
            const Text(
              "BY COURSE",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.5),
            ),

            // 6. Row: Course Images
            // text is over top of the image and bottom center
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFoodItem('assets/images/main_dish.jpg', 'Main Dishes', textAtBottom: true),
                _buildFoodItem('assets/images/salad.jpg', 'Salad Recipes', textAtBottom: true),
                _buildFoodItem('assets/images/side_dish.jpg', 'Side Dishes', textAtBottom: true),
                _buildFoodItem('assets/images/crockpot.jpg', 'Crockpot', textAtBottom: true),
              ],
            ),

            // 7. Header: By Dessert
            const Text(
              "BY DESSERT",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.5),
            ),

            // 8. Row: Dessert Images
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFoodItem('assets/images/ice_cream.jpg', 'Ice Cream', textAtBottom: true),
                _buildFoodItem('assets/images/brownies.jpg', 'Brownies', textAtBottom: true),
                _buildFoodItem('assets/images/pies.jpg', 'Pies', textAtBottom: true),
                _buildFoodItem('assets/images/cookies.jpg', 'Cookies', textAtBottom: true),
              ],
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // --- STRICT REQUIREMENTS HELPER FUNCTION ---
  Widget _buildFoodItem(String imagePath, String label, {bool textAtBottom = false}) {
    // REQUIREMENT: "each image is itself a Stack()"
    return Stack(
      alignment: textAtBottom ? Alignment.bottomCenter : Alignment.center,
      children: [
        // REQUIREMENT: "use the CircleAvatar Widget"
        CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage(imagePath)
        ),

        // The Text overlay
        Padding(
          padding: textAtBottom ? const EdgeInsets.only(bottom: 8.0) : EdgeInsets.zero,
          child: Container(
            // I added a small background blur so the text is readable,
            // but kept it subtle to match the lab look.
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            color: textAtBottom ? Colors.white.withOpacity(0.7) : Colors.transparent,

            child: Text(
              label,
              style: TextStyle(
                // For the "Meat" row (center), text is white with shadow (standard for text-on-image)
                // For "Course" row (bottom), text is black because it's on the white/light background strip
                color: textAtBottom ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                // Only use shadow for the white text in the center so it pops against the food
                shadows: textAtBottom ? null : [const Shadow(blurRadius: 10, color: Colors.black)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}