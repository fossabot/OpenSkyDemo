//
//  APIClient.swift
//  OpenSkyDemo
//
//  Created by Ferdinand Urban on 16.03.2022.
//

import Foundation

import Alamofire
import RxSwift

enum ApiError: Error {
  case forbidden              //Status code 403
  case notFound               //Status code 404
  case conflict               //Status code 409
  case internalServerError    //Status code 500
}

let BASE_URL: String = "https://opensky-network.org/api/"

class OpenSkyAPI: OpenSkyAPIProtocol {
  public static var shared = OpenSkyAPI()
  
  public func fetchStates() -> Observable<[StateModel]> {
    let url = URLRequest(url: URL(string: BASE_URL+"states/all?lamin=48.55&lomin=12.9&lamax=51.06&lomax=18.87")!)
    
    return Observable<[StateModel]>.create { observer in
      let request = AF.request(url).responseDecodable(of: StatesResponse.self) { response in
        switch response.result {
          case .success(let value):
            observer.onNext(value.states)
            observer.onCompleted()
          case .failure(let error):
            switch response.response?.statusCode {
              case 403:
                observer.onError(ApiError.forbidden)
              case 404:
                observer.onError(ApiError.notFound)
              case 409:
                observer.onError(ApiError.conflict)
              case 500:
                observer.onError(ApiError.internalServerError)
              default:
                observer.onError(error)
            }
        }
      }
      
      return Disposables.create {
        request.cancel()
      }
    }
  }
}
