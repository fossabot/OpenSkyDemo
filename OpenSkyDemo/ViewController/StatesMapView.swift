//
//  StatesMapView.swift
//  OpenSkyDemo
//
//  Created by Ferdinand Urban on 17.03.2022.
//

import UIKit
import CoreLocation
import MapKit
import RxSwift
import RxCocoa

class StatesMapView: UIViewController, MKMapViewDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  
  private let viewModel = StatesViewModel()
  private var disposeBag = DisposeBag()
  
  override func viewWillAppear(_ animated: Bool) {
    viewModel.fetchStatesPeriodically(disposedBy: disposeBag)
    observeStates()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
       
    mapView.delegate = self
    mapView.register(OpenSkyAnnotationView.self,
                     forAnnotationViewWithReuseIdentifier: NSStringFromClass(OpenSkyAnnotation.self))
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    disposeBag = DisposeBag()
  }
  
  func updateMapAnnotation(anAnnotation: OpenSkyAnnotation?) {
    guard let theAnnotation = anAnnotation else { return }
    
    if let annotation = mapView.annotations.filter({ ($0 as? OpenSkyAnnotation)!.icao == theAnnotation.icao }).first as? OpenSkyAnnotation {
      annotation.coordinate = theAnnotation.coordinate
    } else {
      mapView.addAnnotation(theAnnotation)
    }
  }
  
  func observeStates() {
    var theHandler: Disposable?
    
    theHandler?.dispose()
    theHandler = viewModel.states
      .flatMap { states in
        return Observable.from(states)
      }
      .map { state -> OpenSkyAnnotation? in
        guard let theLatitude = state.latitude,
                let theLongitude = state.longitude,
                let theIcao = state.icao else {
          return nil
        }
        
        let annotation = OpenSkyAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: theLatitude, longitude: theLongitude)
        annotation.heading = state.trueTrack ?? 0.0
        annotation.icao = theIcao
        annotation.title = "Call Sign: \(state.callSign ?? "unknown")"
        annotation.subtitle = "From: \(state.originCountry ?? "unknown")"
        
        return annotation
      }
      .observe(on: MainScheduler.instance)
      .subscribe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] (anAnnotation) in
        guard let theSelf = self else {
          return
        }
        
        theSelf.updateMapAnnotation(anAnnotation: anAnnotation)
      })
    theHandler?.disposed(by: disposeBag)
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      return nil
    }
    
    var annotationView: MKAnnotationView?
    
    if let annotation = annotation as? OpenSkyAnnotation {
      annotationView = setupAnnotationView(for: annotation, on: mapView)
      
    }
    
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let theAnnotation = view.annotation else { return }
    
    mapView.selectAnnotation(theAnnotation, animated: true)
  }
  
  private func setupAnnotationView(for annotation: OpenSkyAnnotation, on mapView: MKMapView) -> MKAnnotationView {
    let reuseIdentifier = NSStringFromClass(OpenSkyAnnotation.self)
    
    let planeAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
    planeAnnotationView.canShowCallout = false
    planeAnnotationView.annotation = annotation
    
    let image = UIImage(named: "PlaneIcon")
    planeAnnotationView.image = image?.rotate(degrees: annotation.heading)
    planeAnnotationView.canShowCallout = true
    
    let offset = CGPoint(x: 0, y: -(image!.size.height / 2) )
    planeAnnotationView.centerOffset = offset
    
    return planeAnnotationView
  }
}
