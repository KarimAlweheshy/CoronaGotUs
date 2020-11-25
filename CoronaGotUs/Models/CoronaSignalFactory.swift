//
//  CoronaSignalFactory.swift
//  CoronaGotUs
//
//  Created by Karim Alweheshy on 11/25/20.
//

import Foundation
import UIKit

struct CoronaSignalFactory {
    func makeAll() -> [CoronaSignal] {
        [makeGreen(), makeYellow(), makeRed(), makeDarkRed()]
    }

    func makeRed() -> CoronaSignal {
        CoronaSignal(
            range: 50..<100.0,
            color: .systemRed,
            localizedLabelKey: "red_signal",
            localizableRulesKeys: [
                "corona_signal_red_rules_1",
                "corona_signal_red_rules_2",
                "corona_signal_red_rules_3"
            ]
        )
    }

    func makeDarkRed() -> CoronaSignal {
        CoronaSignal(
            range: 100..<Double(Int.max),
            color: UIColor(red: 112/225, green: 2/255, blue: 0, alpha: 1),
            localizedLabelKey: "dark_red_signal",
            localizableRulesKeys: [
                "corona_signal_dark_red_rules_1",
                "corona_signal_dark_red_rules_2",
                "corona_signal_dark_red_rules_3"
            ]
        )
    }

    func makeGreen() -> CoronaSignal {
        CoronaSignal(
            range: (0..<35.0),
            color: .systemGreen,
            localizedLabelKey: "green_signal",
            localizableRulesKeys: [
                "corona_signal_green_rules_1",
                "corona_signal_green_rules_2",
                "corona_signal_green_rules_3"
            ]
        )
    }

    func makeYellow() -> CoronaSignal {
        CoronaSignal(
            range: (35..<50.0),
            color: .systemYellow,
            localizedLabelKey: "yellow_signal",
            localizableRulesKeys: [
                "corona_signal_yellow_rules_1",
                "corona_signal_yellow_rules_2",
                "corona_signal_yellow_rules_3"
            ]
        )
    }
}
