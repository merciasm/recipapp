//
//  RecipeDetailViewModel.swift
//  Recipapp
//
//  Created by Mércia Maguerroski on 4/30/24.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class RecipeDetailViewModel {
    
    // MARK: - Properties
    let recipeSubject = BehaviorSubject(value: RecipeDTO())
    let recipe: RecipeDTO!

    private var notificationToken: NotificationToken?

    // MARK: - Init
    init(recipeDTO: RecipeDTO) {
        recipe = recipeDTO
        notificationToken = recipe.observe({ [weak self] change in
            guard let self = self else { return }
            switch change {
            case .error(let error):
                debugPrint(error)
            case .change(let object, _):
                guard let recipeDTO = object as? RecipeDTO else { return }
                self.recipeSubject.onNext(recipeDTO)
            case .deleted:
                debugPrint("\(String(describing: self.recipe)) deleted")
            }
        })

        DatabaseManager.shared.observerRealmError { error in
            debugPrint("Realm Error", error as Any)
        }
        formatPrepTime()
        
    }

    // MARK: - Public functions
    func viewWillDisappear() {
        notificationToken?.invalidate()
        DatabaseManager.shared.stopObservingErrors(in: self)
    }
    
    func togglePrepared() {
        updateField(recipeDTO: recipe, params: ["isPrepared": !recipe.isPrepared])
    }

    // MARK: - Private functions

    private func formatPrepTime() {
        let prepTime = recipe.prepTimeMinutes + recipe.cookTimeMinutes
        updateField(recipeDTO: recipe, params: ["prepTimeString": formatPrepTime(minutes: prepTime)])
    }

    private func formatPrepTime(minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        if hours > 0 && remainingMinutes > 0 {
            return "\(hours)h \(remainingMinutes)min"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(remainingMinutes)min"
        }
    }

    private func updateField(recipeDTO: RecipeDTO, params: [String : Any?]) {
        DatabaseManager.shared.update(recipeDTO, with: params)
    }
}
