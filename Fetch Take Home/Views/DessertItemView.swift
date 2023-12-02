//
//  DessertView.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import SwiftUI

struct DessertItemView: View {
    var meal: Meal
    
    var body: some View {
        AsyncImage(url: URL(string: meal.strMealThumb)) { phase in
            switch phase {
            case .empty:
                CustomProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        TextOverlayView(mealName: meal.strMeal),
                        alignment: .topTrailing
                    )
                    .cornerRadius(20)
            case .failure:
                fallbackImage
            @unknown default:
                EmptyView()
            }
        }
        .padding()
    }
    
    private var fallbackImage: some View {
        Image("DD")
            .resizable()
            .scaledToFit()
    }
    
    private struct TextOverlayView: View {
        var mealName: String
        
        var body: some View {
            Text(mealName)
                .font(.system(.headline, design: .default))
                .foregroundColor(.primary)
                .background(Color.gray.opacity(0.8))
                .padding(.top, 10)
                .padding(.trailing, 10)
        }
    }
}

struct DessertItemView_Previews: PreviewProvider {
    static var previews: some View {
        let mockMeal = Meal(
            strMeal: "White chocolate creme brulee",
            strMealThumb: "https://www.themealdb.com/images/media/meals/uryqru1511798039.jpg",
            idMeal: "52917")
        DessertItemView(meal: mockMeal)
    }
}
