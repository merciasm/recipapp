//
//  DatabaseManager.swift
//  Recipapp
//
//  Created by Mércia Maguerroski on 4/29/24.
//

import RealmSwift
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()

    let realm = try! Realm()

    private init() {}

    func create<T: Object>(_ object: T) {

        do {
            try realm.write {
                realm.add(object, update: .all)
            }

        } catch {
            print(error)
            postError(error)
        }

    }

    func update<T: Object>(_ object: T, with fields: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in fields {
                    object.setValue(value, forKey: key)
                }
            }

        } catch {
            postError(error)
        }

    }

    func remove<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }

        } catch {
            postError(error)
        }

    }

    func getAllItems() -> Results<RecipeDTO> {
        let recipeResults = realm.objects(RecipeDTO.self)
        return recipeResults
    }

    func postError(_ error: Error) {
        // TODO: Make it observable
        NotificationCenter.default.post(name: NSNotification.Name("Realm Error"), object: error)

    }
}
