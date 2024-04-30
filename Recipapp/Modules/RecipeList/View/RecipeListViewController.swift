//
//  RecipeListViewController.swift
//  Recipapp
//
//  Created by Mércia Maguerroski on 4/28/24.
//

import UIKit
import RxSwift
import RxCocoa

class RecipeListViewController: UIViewController {

    // MARK: Properties
    @IBOutlet private var tableView: UITableView!
    private var viewModel = RecipeViewModel()
    private var disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupPullToRefresh()
    }

    private func configureTableView() {
        tableView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
        bindTableData()
    }

    private func bindTableData() {
        viewModel.items.bind(
            to: tableView.rx.items(
                cellIdentifier: "RecipeCell",
                cellType: RecipeCell.self)
        ) { row, model, cell in
            cell.setCellValues(recipe: model.self)
        }.disposed(by: disposeBag)

        tableView.rx.modelSelected(Recipe.self).bind { recipe in
            print(recipe)
        }.disposed(by: disposeBag)

        viewModel.onFetchEnd.bind { onEnd in
            if onEnd {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }.disposed(by: disposeBag)

        viewModel.getAllRecipes()
    }

    private func setupPullToRefresh() {
        refreshControl.rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.refreshControl.beginRefreshing()
                self.viewModel.getAllRecipes()
            }).disposed(by: disposeBag)

        tableView.refreshControl = refreshControl
    }

}
