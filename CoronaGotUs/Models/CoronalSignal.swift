//
//  CoronalSignal.swift
//  CoronaGotUs
//
//  Created by Karim Alweheshy on 11/25/20.
//

import Foundation
import UIKit

struct CoronaSignal: Equatable {
    let range: Range<Double>
    let color: UIColor
    let localizedLabelKey: String
    let localizableRulesKeys: [String]
}
