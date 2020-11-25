//
//  CoronaMapViewController.swift
//  CoronaGotUs
//
//  Created by Karim Alweheshy on 11/25/20.
//

import UIKit
import ArcGIS

protocol CoronaMapView: AnyObject {
    func set(map: AGSMap)
    func set(locationDataSource: AGSLocationDataSource)
    func set(currentGeoElement: CoronaGeoElement?)
    func setUserLocationChangeHandler(handler: @escaping (AGSLocation) -> Void)
    func geoElements(
        for location: AGSPoint,
        completionHandler: @escaping (Result<[AGSGeoElement], Error>) -> Void
    ) -> AGSCancelable?
}

final class CoronaMapViewController: UIViewController {
    @IBOutlet private var mapView: AGSMapView!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private var regionStatusView: RegionStatusView!
    @IBOutlet private var legendButton: UIButton!

    private let presenter: CoronaMapPresenter
    private var lastPopupQuery: AGSCancelable?

    init?(coder: NSCoder, presenter: CoronaMapPresenter) {
        self.presenter = presenter
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("Not Implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
}

// MARK: - CoronaMapView

extension CoronaMapViewController: CoronaMapView {
    func set(map: AGSMap) {
        mapView.map = map
    }

    func set(locationDataSource: AGSLocationDataSource) {
        mapView.locationDisplay.dataSource = locationDataSource
        mapView.locationDisplay.start(completion: nil)
    }

    func set(currentGeoElement: CoronaGeoElement?) {
        regionStatusView.update(for: currentGeoElement)
    }

    func setUserLocationChangeHandler(
        handler: @escaping (AGSLocation) -> Void
    ) {
        mapView.locationDisplay.locationChangedHandler = handler
    }

    func geoElements(
        for location: AGSPoint,
        completionHandler: @escaping (Result<[AGSGeoElement], Error>) -> Void
    ) -> AGSCancelable? {
        let screenPoint = mapView.location(toScreen: location)
        return mapView.identifyLayers(
            atScreenPoint: screenPoint,
            tolerance: 0,
            returnPopupsOnly: false,
            maximumResultsPerLayer: 1
        ) { identifyResults, error in
            if let error = error {
                return completionHandler(.failure(error))
            }

            if let geoElements = identifyResults?.first?.geoElements {
                return completionHandler(.success(geoElements))
            }

            let error = NSError(
                domain: "Region for user not found",
                code: -5,
                userInfo: [:]
            )
            completionHandler(.failure(error))
        }
    }
}

// MARK: - Actions

extension CoronaMapViewController {
    @objc private func didTapDonePopUp() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func didTapShowLegend() {
        let viewController = CoronaLegendViewControllerFactory().makeViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - AGSGeoViewTouchDelegate

extension CoronaMapViewController: AGSGeoViewTouchDelegate {
    func geoView(
        _ geoView: AGSGeoView,
        didTapAtScreenPoint screenPoint: CGPoint,
        mapPoint: AGSPoint
    ) {
        activityIndicatorView.startAnimating()
        lastPopupQuery?.cancel()
        lastPopupQuery = mapView.identifyLayers(
            atScreenPoint: screenPoint,
            tolerance: 10,
            returnPopupsOnly: true,
            maximumResultsPerLayer: 12
        ) { [weak self] identifyResults, error in
            self?.activityIndicatorView.stopAnimating()
            guard let identifyResults = identifyResults else { return }
            let popups = identifyResults.flatMap { $0.popups }
            self?.showPopups(popups)
        }
    }
}

// MARK: - Private Methods

extension CoronaMapViewController {
    private func setupUI() {
        mapView.touchDelegate = self
        legendButton.setTitle(
            NSLocalizedString("corona_legend_title", comment: ""),
            for: .normal
        )
    }

    private func showPopups(_ popups: [AGSPopup]) {
        guard !popups.isEmpty else { return showNoInformationAlert() }

        let containerStyle = AGSPopupsViewControllerContainerStyle.navigationController

        let popupsViewController = AGSPopupsViewController(
            popups: popups,
            containerStyle: containerStyle
        )
        popupsViewController.customDoneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapDonePopUp)
        )

        let navigationController = UINavigationController(rootViewController: popupsViewController)
        present(navigationController, animated: true)
    }

    private func showNoInformationAlert() {
        let alertController = UIAlertController(
            title: NSLocalizedString("no_information_found_title", comment: ""),
            message: NSLocalizedString("no_information_found_message", comment: ""),
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: NSLocalizedString("alert_ok", comment: ""),
            style: .default,
            handler: nil
        )
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

