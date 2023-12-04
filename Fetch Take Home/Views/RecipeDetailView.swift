//
//  RecipeDetailView.swift
//  Fetch Take Home
//
//  Created by Adriano Ramos on 11/10/23.
//

import SwiftUI

struct RecipeDetailView: View {
    @StateObject var viewModel: MealDetailViewModel
    @StateObject var youtubeHelper: YoutubeHelper
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ScrollView {
            switch viewModel.state {
            case .loading:
                ProgressView {
                    Text("fetching")
                        .font(.title2)
                }
            case .error:
                if let errorMessage = viewModel.errorMessage {
                    ContentUnavailableView(errorMessage, systemImage: "exclamationmark.triangle")
                }
            case .idle:
                if let followThisRecipe = viewModel.recipe?.meals.first {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        recipeImageView
                        
                        Text(followThisRecipe.strMeal.orEmpty)
                            .font(.title)
                            .padding(.top)
                        
                        Text("Category: \(followThisRecipe.strCategory.orEmpty)")
                        Text("Area: \(followThisRecipe.strArea.orEmpty)")
                        
                        if let source = followThisRecipe.strSource, let url = URL(string: source) {
                            Link("Recipe Source", destination: url)
                        }
                        
                        Text("Ingredients")
                            .font(.title2)
                            .padding(.top)
                        
                        if !followThisRecipe.ingredients.isEmpty {
                            ForEach(Array(followThisRecipe.ingredients.sorted(by: <).enumerated()), id: \.element.key) { index, pair in
                                HStack {
                                    Text(pair.key.capitalizeFirstLetter())
                                    Spacer()
                                    Text(pair.value)
                                }
                                .background(index % 2 == 0 ? Color.gray.opacity(0.2) : Color.clear)
                            }
                        } else {
                            Text("No ingredients available")
                        }
                        
                        Text("Instructions")
                            .font(.title2)
                            .padding(.top)
                        
                        Text(followThisRecipe.strInstructions ?? "")
                            .padding(.bottom)
                        
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Recipe Details")
        .onAppear {
            Task {
                await viewModel.fetch()
            }
        }
    }
    
    @ViewBuilder
    private var recipeImageView: some View {
        if let imageUrl = viewModel.recipe?.meals[0].strMealThumb.flatMap(URL.init) {
            AsyncImage(url: imageUrl) { phase in
                imagePhaseView(phase)
            }
        } else {
            CircularImageView(image: Image("DD"))
        }
    }
    
    @ViewBuilder
    private func imagePhaseView(_ phase: AsyncImagePhase) -> some View {
        switch phase {
        case .empty:
            CustomProgressView()
        case .success(let image):
            CircularImageView(image: image)
                .overlay(youtubePlayButtonOverlay)
                .sheet(isPresented: $youtubeHelper.isYoutubeViewAboutToBePresented) {
                    YouTubeSheetView
                }
        case .failure:
            CircularImageView(image: Image("DD"))
        @unknown default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var youtubePlayButtonOverlay: some View {
        if let youtubeID = viewModel.recipe?.meals[0].strYoutube, !youtubeID.isEmpty {
            Button(action: {
                feedbackGenerator.impactOccurred()
                DispatchQueue.main.async {
                    // Handle the action to open the YouTube video
                    youtubeHelper.isYoutubeViewAboutToBePresented = true
                    if let videoID = YoutubeHelper.getYoutubeVideoID(from: youtubeID) {
                        youtubeHelper.youtubeRef = videoID
                    }
                }
            }) {
                Image(systemName: "play.circle")
                    .font(.system(size: 50))
                    .foregroundColor(.red)
                    .background(Circle().fill(Color.white))
            }
            .shadow(radius: 5)
            .padding(.bottom, 20)
            .positionInCircleOverlay()
        }
    }
    
    @ViewBuilder
    private var YouTubeSheetView: some View {
        if !youtubeHelper.youtubeRef.isEmpty {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    Image(systemName: "video.bubble.fill")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("Swipe down to dismiss")
                        .foregroundColor(.gray)
                        .font(.system(size: 10, weight: .regular, design: .default))
                    YouTubeVideoView(videoId: youtubeHelper.youtubeRef)
                    // Assuming 16:9 aspect ratio
                        .frame(width: geometry.size.width, height: (geometry.size.width / 16 * 9))
                    Spacer()
                }
            }
        } else {
            Text("Video not available")
        }
    }
}

extension Optional where Wrapped == String {
    var orEmpty: String {
        self ?? ""
    }
}

// Example usage (assuming you have a valid 'recipe' object)
struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockMeal = Meal(
            strMeal: "White chocolate creme brulee",
            strMealThumb: "https://www.themealdb.com/images/media/meals/uryqru1511798039.jpg",
            idMeal: "52917")
        RecipeDetailView(viewModel: MealDetailViewModel(meal: mockMeal), youtubeHelper: YoutubeHelper())
    }
}
