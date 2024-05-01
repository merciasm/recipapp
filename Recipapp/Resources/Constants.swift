//
//  Constants.swift
//  Recipapp
//
//  Created by Mércia Maguerroski on 4/29/24.
//

import Foundation

enum Constants {
    enum URL {
        static let baseUrl = "https://dummyjson.com/recipes/"
    }

    enum Endpoints {
        static let recipeDetails = URL.baseUrl + "/%d"
    }
}
