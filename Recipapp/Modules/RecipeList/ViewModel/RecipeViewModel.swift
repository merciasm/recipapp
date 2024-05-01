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
import UIKit

class RecipeViewModel {
    /** This subject is used to emit sequences of Results<RecipeDTO>, which represent the results of querying the database for recipe items. Represents a live query result that automatically updates when the underlying data changes in Realm.
     The subject type depends on the project needs and/or project pattern

     **/

    // MARK: - Properties
    var items = PublishSubject<Results<RecipeDTO>>()
    var onDataChanged = PublishSubject<Bool>()

    private var notificationToken: NotificationToken?

    // MARK: - Init
    init() {
        notificationToken = DatabaseManager.shared.realm.observe({ notification, realm in
            self.items.onNext(DatabaseManager.shared.getAllItems())
        })

        DatabaseManager.shared.observerRealmError { error in
            debugPrint("Realm error", error as Any)
        }
    }

    // MARK: - Public functions

    func viewWillDisappear() {
        notificationToken?.invalidate()
        DatabaseManager.shared.stopObservingErrors(in: self)
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
                debugPrint(error)
                self?.items.onCompleted()
            }
        }
    }

    // MARK: - Private functions
    private func addRecipesOnDatabase(recipes: [Recipe]) {
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
                isPrepared: false,
                prepTimeString: "")
            DatabaseManager.shared.create(recipeDTO)
        }
    }

}

// MARK: - Routing
extension RecipeViewModel: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any? = nil) {
        guard let route = Route(rawValue: routeID) else {
            return
        }
        switch route {
        case .recipeDetail:
            guard let recipe = parameters as? RecipeDTO else { return }
            let viewModel = RecipeDetailViewModel(recipeDTO: recipe)
            let viewController = RecipeDetailsViewController.initModule(viewModel: viewModel)
            let navigationController = UINavigationController(rootViewController: viewController)
            context.present(navigationController, animated: true, completion: nil)
        }
    }
}
