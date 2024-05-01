//
//  RecipeDetailsViewController.swift
//  Recipapp
//
//  Created by Mércia Maguerroski on 4/30/24.
//

import Foundation
import UIKit

class RecipeDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func initModule() -> RecipeDetailsViewController {
        let storyboard = UIStoryboard(name: "RecipeDetails", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? RecipeDetailsViewController else {
            return RecipeDetailsViewController()
        }
        return viewController
    }

}
