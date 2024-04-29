//
//  RecipeListViewController.swift
//  Recipapp
//
//  Created by Mércia Maguerroski on 4/28/24.
//

import UIKit

class RecipeListViewController: UIViewController {

    // MARK: Properties
    @IBOutlet private var tableView: UITableView!

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }


    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

}


extension RecipeListViewController: UITableViewDelegate {

}

extension RecipeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    

}
