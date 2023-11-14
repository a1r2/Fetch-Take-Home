//
//  DessertListContentView.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import SwiftUI

struct DessertListView: View {
    @ObservedObject var viewModel: MealsViewModel
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(viewModel.meals.filter {
                    searchText.isEmpty || $0.strMeal.localizedCaseInsensitiveContains(searchText.lowercased())
                }, id: \.self) { meal in
                    NavigationLink(destination: RecipeDetailView(viewModel: MealsDetailViewModel(meal: meal), youtubeHelper: YoutubeHelper())
                    ) {
                        DessertItemView(meal: meal)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        feedbackGenerator.impactOccurred()
                    })
                }
            }
            .navigationTitle("Take Home")
            .searchable(text: $searchText)
            .onAppear {
                viewModel.fetch()
            }
            .refreshable {
                viewModel.fetch()
            }
        }
    }
}

#Preview {
    DessertListView(viewModel: MealsViewModel(services: Services()))
}
