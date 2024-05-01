//
//  RecipeCell.swift
//  Recipapp
//
//  Created by Mércia Maguerroski on 4/29/24.
//

import UIKit
import AlamofireImage

class RecipeCell: UITableViewCell {
    // MARK: - UI IBOUtlets
    @IBOutlet private var recipeRating: UILabel!
    @IBOutlet private var recipeName: UILabel!
    @IBOutlet private var recipeImage: UIImageView!
    @IBOutlet private var recipeDifficulty: UILabel!
    @IBOutlet private var recipeServingsNumber: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeRating.text = nil
        recipeName.text = nil
        recipeDifficulty.text = nil
        recipeServingsNumber.text = nil
        recipeImage.image = nil
    }

    // MARK: - Public functions

    func setCellValues(recipe: RecipeDTO) {
        recipeName.text = recipe.name
        recipeRating.text = "\(recipe.rating)"
        recipeDifficulty.text = "\(recipe.difficulty) to do"
        recipeServingsNumber.text = "\(recipe.servings)"
        
        setupImage(url: recipe.image)
    }

    // MARK: - Private functions

    private func setupImage(url: String) {
        if let url = URL(string: url) {
            recipeImage.af.setImage(withURL: url)
        }
    }
    
}
