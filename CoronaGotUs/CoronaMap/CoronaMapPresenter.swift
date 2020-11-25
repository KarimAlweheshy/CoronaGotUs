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
    private let storage: CurrentCoronaSignalStorage
    private var userGeoElementsCancelable: AGSCancelable?

    init(storage: CurrentCoronaSignalStorage) {
        self.storage = storage
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
        view?.set(locationDataSource: AGSCLLocationDataSource())
        view?.setUserLocationChangeHandler { [weak self] location in
            self?.userLocationDidChange(location)
        }
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

    private func userLocationDidChange(_ location: AGSLocation) {
        guard let position = location.position else { return }
        self.userGeoElementsCancelable?.cancel()
        self.userGeoElementsCancelable = self.view?.geoElements(
            for: position,
            completionHandler: self.handleNewUserGeoElements
        )
    }

    private func handleNewUserGeoElements(
        _ result: Result<[AGSGeoElement], Error>
    ) {
        guard
            let region = try? result.get().first,
            let json = try? JSONSerialization.data(
                withJSONObject: region.attributes,
                options: .sortedKeys
            ),
            let currentGeoRegion = try? JSONDecoder().decode(
                CoronaGeoElement.self,
                from: json
            )
        else { return }
        storage.update(geoElement: currentGeoRegion)
    }
}

