//
//  CoronaRulesViewControllerFactory.swift
//  CoronaGotUs
//
//  Created by Karim Alweheshy on 11/26/20.
//

import UIKit

struct CoronaRulesViewControllerFactory {
    func makeViewController(coronaSignal: CoronaSignal) -> CoronaRulesViewController {
        let storyboard = UIStoryboard(name: "CoronaRules", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController { coder -> CoronaRulesViewController? in
            CoronaRulesViewController(coder: coder, coronaSignal: coronaSignal)
        }
        return viewController!
    }
}
