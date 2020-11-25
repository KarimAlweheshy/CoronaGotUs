//
//  CoronaLegendViewControllerFactory.swift
//  CoronaGotUs
//
//  Created by Karim Alweheshy on 11/25/20.
//

import UIKit

struct CoronaLegendViewControllerFactory {
    func makeViewController() -> CoronaLegendViewController {
        let storyboard = UIStoryboard(name: "CoronaLegend", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController { coder -> CoronaLegendViewController? in
            CoronaLegendViewController(coder: coder)
        }
        return viewController!
    }
}
