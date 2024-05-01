//
//  Router.swift
//  Recipapp
//
//  Created by Mércia Maguerroski on 4/30/24.
//

import Foundation
import UIKit

protocol Router {
   func route(
      to routeID: String,
      from context: UIViewController,
      parameters: Any?
   )
}

enum Route: String {
   case recipeDetail
}
