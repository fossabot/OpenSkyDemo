//
//  StatesViewModel.swift
//  OpenSkyDemo
//
//  Created by Ferdinand Urban on 16.03.2022.
//

import Foundation
import RxSwift

class StatesViewModel {
  let apiClient: OpenSkyAPIProtocol
  let states: PublishSubject<[StateModel]> = PublishSubject<[StateModel]>()
  let statesCount: Observable<String>
  
  var disposeBag = DisposeBag()
  
  init(client: OpenSkyAPIProtocol = OpenSkyAPI.shared) {
    self.apiClient = client

    statesCount = states.map { "Planes in area: \($0.count)" }
  }
  
  func fetchStatesPeriodically(disposedBy aBag: DisposeBag) {
    Observable<Int>.timer(.seconds(0),
                          period: .seconds(Constants.DataRefreshRate),
                          scheduler: SerialDispatchQueueScheduler(qos: .background))
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        self?.fetchStates()
      })
      .disposed(by: aBag)
  }
                 
  private func fetchStates() {
    apiClient.fetchStates()
      .observe(on: MainScheduler.instance)
      .subscribe { [weak self] anEvent in
        guard let theSelf = self else {
          return
        }
        switch anEvent {
          case .next(let aValue):
            Logger.info("Received \(aValue.count) items.")
            theSelf.states.onNext(aValue)
          case .error(let anError):
            Logger.error(anError.localizedDescription)
          default: ()
        }
      }
      .disposed(by: disposeBag)
  }
}
