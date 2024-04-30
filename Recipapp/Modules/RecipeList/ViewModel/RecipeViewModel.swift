//
//  RecipeViewModel.swift
//  Recipapp
//
//  Created by Mércia Maguerroski on 4/29/24.
//

import Foundation
import RxSwift
import RealmSwift

class RecipeViewModel {
    var items = PublishSubject<Results<RecipeDTO>>()
    var onFetchEnd = PublishSubject<Bool>()

    private var recipes: Results<RecipeDTO>?

    func checkDataBase() {
        recipes = DatabaseManager.shared.getAllItems()
        if let recipes && recipes.isEmpty {
            if  {
                getAllRecipes()
            } else {
                items.onNext(recipes)
            }


    }

    func getAllRecipes() {
        guard let url = URL(string: Constants.URL.baseUrl) else { return }
        APIManager.shared.fetchData(from: url, responseModel: RecipeList.self) { [weak self] result in
            switch result {
            case .success(let list):
                if let recipeList = list as? RecipeList {
                    let recipes = recipeList.recipes
                    for recipe in recipes {
                        let recipeDTO = RecipeDTO()
                    }
                    self?.items.onNext(recipes)
                    self?.items.onCompleted()

                    self?.onFetchEnd.onNext(true)
                } else {
                    self?.items.onNext([])
                    self?.items.onCompleted()
                    self?.onFetchEnd.onNext(true)
                }
            case .failure(let error):
                self?.onFetchEnd.onNext(true)
            }
        }



    }

}
