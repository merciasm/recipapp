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
            if !model.isInvalidated {
                cell.setCellValues(recipe: model.self)
            }
        }.disposed(by: disposeBag)

        tableView.rx.modelSelected(RecipeDTO.self).bind { [weak self] recipe in
            guard let self = self else { return }
            self.viewModel.route(to: Route.recipeDetail.rawValue, from: self)
        }.disposed(by: disposeBag)

        viewModel.onDataChanged.bind { [weak self] onChanged in
            guard let self = self else { return }
            if onChanged {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }.disposed(by: disposeBag)

        viewModel.checkDataBase()
    }

    private func setupPullToRefresh() {
        refreshControl.rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.refreshControl.beginRefreshing()
                self.viewModel.getAllRecipes(refresh: true)
            }).disposed(by: disposeBag)

        tableView.refreshControl = refreshControl
    }

}
