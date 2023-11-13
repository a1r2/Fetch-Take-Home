# Fetch-Take-Home

https://github.com/a1r2/Fetch-Take-Home

a native iOS app that allows users to browse recipes using the
following API:
https://themealdb.com/api.php

• https://themealdb.com/api/json/v1/1/filter.php?c=Dessert for fetching the
list of meals in the
Dessert category.
• https://themealdb.com/api/json/v1/1/lookup.php?i=MEAL_ID for fetching
the meal details by its ID.

I used SwiftUI for it, MVVM and SOLID architecture principles.

The user should be shown the list of meals in the Dessert category, sorted
alphabetically. Check!

When the user selects a meal, they should be taken to a detail view that
includes:
• Meal name
• Instructions
• Ingredients/measurements

I added some more stuff: open Youtube video in another view or Safari to show source of recipe.

Models: Meals model is straight forward, MealsResponse is not as the API could return nil for anything, so I took the measure of treating all that as optionals and to create a DynamicCodingKeys structure and a ingredients Dictionary to handle the measurements.

Please read the following guidelines carefully before starting the coding
challenge:

• Be sure to filter out any null or empty values from the API before displaying
them. Check!

• UI/UX design is not what you’re being evaluated on, but the app should be
user friendly and should take basic app design principles into account. Check

• Project should compile using the latest version of Xcode. Check
