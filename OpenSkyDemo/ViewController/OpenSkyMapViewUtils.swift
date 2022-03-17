//
//  OpenSkyAnnotation.swift
//  OpenSkyDemo
//
//  Created by Ferdinand Urban on 17.03.2022.
//

import Foundation
import MapKit

class OpenSkyAnnotation: MKPointAnnotation {
  var icao: String?
  public var heading: Float = 0.0
  
  public init(withIcao icao: String) {
    self.icao = icao
  }
  
  public override init() {}
  
}

class OpenSkyAnnotationView: MKAnnotationView {
  var openSkyAnnotation: OpenSkyAnnotation!
}
