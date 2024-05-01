//
//  DatabaseManager.swift
//  Recipapp
//
//  Created by Mércia Maguerroski on 4/29/24.
//

import RealmSwift
import Foundation
import UIKit

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

    // This could be done using other aproaches: such as with RxSwift or Combine

    func postError(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("Realm Error"), object: error)
    }

    func observerRealmError(completion: @escaping (Error?) -> Void) {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("Realm Error"),
            object: nil,
            queue: nil) { notification in
                completion(notification.object as? Error)
            }
    }

    func stopObservingErrors(in observer: Any) {
        NotificationCenter.default.removeObserver(
            observer,
            name: NSNotification.Name("Realm Error"),
            object: nil)
    }
}
