//
//  StatesResponse.swift
//  OpenSkyDemo
//
//  Created by Ferdinand Urban on 16.03.2022.
//

import Foundation

struct StatesResponse: Decodable {
  let time: Int
  let states: [StateModel]
  
  enum CodingKeys: String, CodingKey {
    case time = "time"
    case states = "states"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    time = try container.decode(Int.self, forKey: CodingKeys.time)
    states = try container.decode([StateModel].self, forKey: CodingKeys.states)
  }
}
