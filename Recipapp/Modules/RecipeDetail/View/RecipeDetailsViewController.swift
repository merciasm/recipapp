//
//  RecipeDetailsViewController.swift
//  Recipapp
//
//  Created by Mércia Maguerroski on 4/30/24.
//

import Foundation
import UIKit
import RxSwift
import AlamofireImage

class RecipeDetailsViewController: UIViewController {
    
    // MARK: - IBoutlets
    @IBOutlet private var preparationButton: UIButton!
    @IBOutlet private var recipeImage: UIImageView!
    @IBOutlet private var recipeName: UILabel!
    @IBOutlet private var recipeCousine: UILabel!
    @IBOutlet private var recipeRating: UILabel!
    @IBOutlet private var servingsnumber: UILabel!
    @IBOutlet private var prepTime: UILabel!
    @IBOutlet private var ingredients: UILabel!
    @IBOutlet private var instructions: UILabel!
    
    private var viewModel: RecipeDetailViewModel!
    private let disposeBag = DisposeBag()

    // MARK: - Life Cycle
    static func initModule(viewModel: RecipeDetailViewModel) -> RecipeDetailsViewController {
        let storyboard = UIStoryboard(name: "RecipeDetails", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? RecipeDetailsViewController {
            viewController.viewModel = viewModel
            return viewController
        } else {
            fatalError("No storyboard for RecipeDetails")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stupBinders()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewWillDisappear()
    }

    // MARK: - Setup

    private func stupBinders() {
        viewModel.recipeSubject.subscribe(onNext: { [weak self] recipe in
            guard let self = self else { return }
            if let url = URL(string: recipe.image) {
                self.recipeImage.af.setImage(withURL: url)
            }
            self.recipeName.text = recipe.name
            self.recipeRating.text = "\(recipe.rating)"
            self.servingsnumber.text = "\(recipe.servings)"
            self.recipeCousine.text = recipe.cuisine
            self.prepTime.text = recipe.prepTimeString
            self.ingredients.text = "* " + recipe.ingredients.joined(separator: "\n* ")
            self.instructions.text = "* " + recipe.instructions.joined(separator: "\n* ")
            
            if recipe.isPrepared {
                preparationButton.setTitle("Prepared", for: .normal)
            } else {
                preparationButton.setTitle("Mark as prepared", for: .normal)
            }
            
        }).disposed(by: disposeBag)
    }

    // MARK: - Actions

    @IBAction func markAsPrepared(_ sender: Any) {
        viewModel.togglePrepared()
    }
    
}
