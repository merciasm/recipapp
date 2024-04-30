//
//  Recipe.swift
//  Recipapp
//
//  Created by Mércia Maguerroski on 4/29/24.
//

import Foundation
import RealmSwift

struct Recipe: Decodable {
    let id: Int
    let name: String
    let image: String
    let ingredients: List<String>
    let difficulty: String
    let cuisine: String
    let prepTimeMinutes: Int
    let cookTimeMinutes: Int
    let rating: Double
    let servings: Int
    let caloriesPerServing: Int
    let reviewCount: Int
    let instructions: List<String>
    let tags: List<String>
    let mealType: List<String>
}

class RecipeDTO: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var image: String
    @Persisted var ingredients: List<String>
    @Persisted var difficulty: String
    @Persisted var cuisine: String
    @Persisted var prepTimeMinutes: Int
    @Persisted var cookTimeMinutes: Int
    @Persisted var rating: Double
    @Persisted var servings: Int
    @Persisted var caloriesPerServing: Int
    @Persisted var reviewCount: Int
    @Persisted var instructions: List<String>
    @Persisted var tags: List<String>
    @Persisted var mealType: List<String>
    @Persisted var isPrepared: Bool

    convenience init(id: Int, name: String, image: String, ingredients: List<String>, difficulty: String, cuisine: String, prepTimeMinutes: Int, cookTimeMinutes: Int, rating: Double, servings: Int, caloriesPerServing: Int, reviewCount: Int, instructions: List<String>, tags: List<String>, mealType: List<String>, isPrepared: Bool) {
        self.init()
        self.id = id
        self.name = name
        self.image = image
        self.ingredients = ingredients
        self.difficulty = difficulty
        self.cuisine = cuisine
        self.prepTimeMinutes = prepTimeMinutes
        self.cookTimeMinutes = cookTimeMinutes
        self.rating = rating
        self.servings = servings
        self.caloriesPerServing = caloriesPerServing
        self.reviewCount = reviewCount
        self.instructions = instructions
        self.tags = tags
        self.mealType = mealType
        self.isPrepared = isPrepared
    }
}

struct RecipeList: Decodable {
    let recipes: [Recipe]
    let total: Int
    let skip: Int
    let limit: Int
}
