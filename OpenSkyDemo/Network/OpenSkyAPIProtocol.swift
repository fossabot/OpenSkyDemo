//
//  OpenSkyAPI.swift
//  OpenSkyDemo
//
//  Created by Ferdinand Urban on 16.03.2022.
//

import Foundation
import RxSwift

protocol OpenSkyAPIProtocol {
  func fetchStates() -> Observable<[StateModel]>
}
