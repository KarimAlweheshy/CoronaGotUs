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
    func didTapStatus()
}

final class CoronaMapDefaultPresenter {
    weak var view: CoronaMapView?

    private let map: AGSMap
    private let storage: CurrentCoronaSignalStorage
    private var userGeoElementsCancelable: AGSCancelable?
    private var currentLocation: AGSLocation?
    private var useCurrentGeoElementsFetchTimer: Timer?


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

        useCurrentGeoElementsFetchTimer = Timer.scheduledTimer(
            withTimeInterval: 3,
            repeats: true
        ) { [weak self] timer in
            guard
                let self = self,
                let position = self.currentLocation?.position
            else { return }
            self.userGeoElementsCancelable?.cancel()
            self.userGeoElementsCancelable = self.view?.geoElements(
                for: position,
                completionHandler: self.handleNewUserGeoElements
            )
        }
    }
}

// MARK: - CoronaMapPresenter

extension CoronaMapDefaultPresenter: CoronaMapPresenter {
    func viewDidLoad() {
        let locationChangeHandler = { [weak self] (location: AGSLocation) in
            guard let self = self else { return }
            self.currentLocation = location
            self.useCurrentGeoElementsFetchTimer?.fire()
        }

        let mapLoaded = { [weak self] (error: Error?) in
            guard let self = self else { return }
            self.view?.set(map: self.map)
            self.view?.set(locationDataSource: AGSCLLocationDataSource())
            self.view?.setUserLocationChangeHandler(handler: locationChangeHandler)
        }

        let feature = coronaFeatureLayer()
        let featureLoaded = { [weak self] (error: Error?) in
            guard let self = self else { return }
            self.map.operationalLayers.add(feature)
            self.map.load(completion: mapLoaded)
        }
        feature.load(completion: featureLoaded)
    }

    func didTapStatus() {
        guard let position = currentLocation?.position else { return }
        view?.showPopUp(for: position)
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
        view?.set(currentGeoElement: currentGeoRegion)
    }
}

