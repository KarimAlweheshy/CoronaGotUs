//
//  CoronaMapViewControllerFactory.swift
//  CoronaGotUs
//
//  Created by Karim Alweheshy on 11/25/20.
//

import Foundation
import UIKit

struct CoronaMapViewControllerFactory {
    func makeViewController() -> CoronaMapViewController {
        let presenter = CoronaMapDefaultPresenter()
        let storyboard = UIStoryboard(name: "CoronaMap", bundle: nil)
        let viewContorller: CoronaMapViewController? = storyboard.instantiateInitialViewController { coder in
            CoronaMapViewController(coder: coder, presenter: presenter)
        }
        presenter.view = viewContorller
        return viewContorller!
    }
}
