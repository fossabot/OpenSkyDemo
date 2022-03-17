//
//  ViewController.swift
//  OpenSkyDemo
//
//  Created by Ferdinand Urban on 16.03.2022.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class StatesViewController: UIViewController, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var bottomView: UIView!
  @IBOutlet weak var infoLabel: UILabel!
  
  private var disposeBag = DisposeBag()
  private var viewModel = StatesViewModel()
  
  override func viewWillAppear(_ animated: Bool) {
    viewModel.fetchStatesPeriodically(disposedBy: disposeBag)
    bindTableView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillDisappear(_ animated: Bool) {
    disposeBag = DisposeBag()
  }
  
  func bindTableView() {
    tableView.rx.setDelegate(self).disposed(by: disposeBag)
    
    viewModel.states.asObservable()
      .bind(to: tableView.rx.items(cellIdentifier: "stateCell",
                                   cellType: StateCell.self)) { index, viewModel, cell in
        cell.content = viewModel
      }.disposed(by: disposeBag)
    
    viewModel.statesCount
      .bind(to: infoLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
}
