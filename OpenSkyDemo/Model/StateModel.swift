//
//  StateModel.swift
//  OpenSkyDemo
//
//  Created by Ferdinand Urban on 16.03.2022.
//

import Foundation

enum PositionSource: Int, Decodable {
  case ADSB = 0
  case ASTERIX = 1
  case MLAT = 2
}

struct StateModel: Decodable {
  let icao: String?
  let callSign: String?
  let originCountry: String?
  let timePosition: Int?
  let lastContact: Int?
  let latitude: Double?
  let longitude: Double?
  let baroAlt: Float?
  let onGround: Bool?
  let velocity: Float?
  let trueTrack: Float?
  let verticalRate: Float?
  let sensors:[Int]?
  let geoAlt: Float?
  let squawk: String?
  let spi: Bool?
  let positionSource: PositionSource?
  
  init(from decoder: Decoder) throws {
    var container = try decoder.unkeyedContainer()
    icao = try? container.decode(String.self)
    callSign = try? container.decode(String.self)
    originCountry = try? container.decode(String.self)
    timePosition = try? container.decode(Int.self)
    lastContact = try? container.decode(Int.self)
    longitude = try? container.decode(Double.self)
    latitude = try? container.decode(Double.self)    
    baroAlt = try? container.decode(Float.self)
    onGround = try? container.decode(Bool.self)
    velocity = try? container.decode(Float.self)
    trueTrack = try? container.decode(Float.self)
    verticalRate = try? container.decode(Float.self)
    sensors = try? container.decode([Int].self)
    geoAlt = try? container.decode(Float.self)
    squawk = try? container.decode(String.self)
    spi = try? container.decode(Bool.self)
    positionSource = try? container.decode(PositionSource.self)
  }
}

extension StateModel {
  
  public var debugDescription: String {
    return """
     icao: \(icao ?? "n/a"), callsign: \(callSign ?? "n/a"), latitude: \(latitude ?? Double.infinity), longitude: \(longitude ?? Double.infinity)
    """
  }
}
