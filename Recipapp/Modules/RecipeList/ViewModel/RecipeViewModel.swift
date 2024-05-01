//
//  RecipeViewModel.swift
//  Recipapp
//
//  Created by Mércia Maguerroski on 4/29/24.
//

import Foundation
import RxSwift
import RealmSwift
import RealmCoreResources

class RecipeViewModel {
    var items = PublishSubject<Results<RecipeDTO>>()
    var onDataChanged = PublishSubject<Bool>()

    var notificationToken: NotificationToken?

    init() {
        notificationToken = DatabaseManager.shared.realm.observe({ notification, realm in
            self.items.onNext(DatabaseManager.shared.getAllItems())
        })
    }

    func viewWillDisappear() {
        notificationToken?.invalidate()
    }

    func checkDataBase() {
        let recipesResults = DatabaseManager.shared.getAllItems()
            if recipesResults.isEmpty == true {
                getAllRecipes()
            } else {
                items.onNext(recipesResults)
                items.onCompleted()
            }
    }

    func getAllRecipes(refresh: Bool = false) {
        guard let url = URL(string: Constants.URL.baseUrl) else { return }
        APIManager.shared.fetchData(from: url, responseModel: RecipeList.self) { [weak self] result in
            switch result {
            case .success(let list):
                if let recipeList = list as? RecipeList {
                    self?.addRecipesOnDatabase(
                        recipes: recipeList.recipes)
                    if refresh {
                        self?.onDataChanged.onNext(true)
                    }
                } else {
                    self?.items.onCompleted()
                }
            case .failure(let error):
                print(error)
                self?.items.onCompleted()
            }
        }
    }



    func addRecipesOnDatabase(recipes: [Recipe]) {
        for recipe in recipes {
            let recipeDTO = RecipeDTO(
                id: recipe.id,
                name: recipe.name,
                image: recipe.image,
                ingredients: recipe.ingredients,
                difficulty: recipe.difficulty,
                cuisine: recipe.cuisine,
                prepTimeMinutes: recipe.prepTimeMinutes,
                cookTimeMinutes: recipe.cookTimeMinutes,
                rating: recipe.rating,
                servings: recipe.servings,
                caloriesPerServing: recipe.caloriesPerServing,
                reviewCount: recipe.reviewCount,
                instructions: recipe.instructions,
                tags: recipe.tags,
                mealType: recipe.mealType,
                isPrepared: false)
            DatabaseManager.shared.create(recipeDTO)
        }


    }

}
