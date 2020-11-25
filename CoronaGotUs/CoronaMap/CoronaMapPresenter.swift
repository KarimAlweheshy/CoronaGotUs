//
//  CoronaMapPresenter.swift
//  CoronaGotUs
//
//  Created by Karim Alweheshy on 11/25/20.
//

import Foundation
import CoreLocation
import ArcGIS

protocol CoronaMapPresenter {
    func viewDidLoad()
}

final class CoronaMapDefaultPresenter {
    weak var view: CoronaMapView?

    private let map: AGSMap

    init() {
        let germanyLocation = CLLocationCoordinate2D(
            latitude: 51.1657,
            longitude: 10.4515
        )

        map = AGSMap(
            basemapType: .streets,
            latitude: germanyLocation.latitude,
            longitude: germanyLocation.longitude,
            levelOfDetail: 5
        )
    }
}

// MARK: - CoronaMapPresenter

extension CoronaMapDefaultPresenter: CoronaMapPresenter {
    func viewDidLoad() {
        let feature = coronaFeatureLayer()
        map.operationalLayers.add(feature)
        view?.set(map: map)
    }
}

// MARK: - Private Methods

extension CoronaMapDefaultPresenter {
    private func coronaFeatureLayer() -> AGSFeatureLayer {
        let portal = AGSPortal(
            url: URL(string: "https://www.arcgis.com")!,
            loginRequired: false
        )
        let portalItem = AGSPortalItem(
            portal: portal,
            itemID: "917fc37a709542548cc3be077a786c17"
        )

        let featureTable = AGSServiceFeatureTable(item: portalItem, layerID: 0)
        let feature = AGSFeatureLayer(featureTable: featureTable)

        feature.isPopupEnabled = true
        feature.labelsEnabled = true
        feature.refreshInterval = 600
        feature.renderer = CoronaRendererFactory().makeRenderer()

        return feature
    }
}

