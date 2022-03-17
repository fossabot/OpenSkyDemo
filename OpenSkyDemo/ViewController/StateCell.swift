//
//  StateCell.swift
//  OpenSkyDemo
//
//  Created by Ferdinand Urban on 17.03.2022.
//

import UIKit
import SnapKit

class StateCell: UITableViewCell {

  @IBOutlet weak var icaoLabel: UILabel!
  @IBOutlet weak var callSignLabel: UILabel!
  @IBOutlet weak var originCountryLabel: UILabel!
  
  public var content: StateModel? = nil {
    didSet {
      loadContent()
      icaoLabel.text = "ICAO: \(content?.icao ?? "n/a")"
      callSignLabel.text = "Call Sign: \(content?.callSign ?? "n/a")"
      originCountryLabel.text = "From: \(content?.originCountry ?? "n/a")"
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  private func loadContent() {
    icaoLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.left.equalToSuperview().offset(10)
      $0.width.equalToSuperview().dividedBy(2)
    }
    
    originCountryLabel.snp.makeConstraints {
      $0.top.equalTo(icaoLabel.snp_bottomMargin).offset(10)
      $0.left.equalTo(icaoLabel)
      $0.right.equalToSuperview().offset(10)
      $0.width.equalToSuperview()
    }
    
    callSignLabel.snp.makeConstraints {
      $0.right.equalToSuperview().offset(-10)
      $0.top.equalTo(icaoLabel)
      $0.width.equalTo(icaoLabel)
    }
  }
  
}
