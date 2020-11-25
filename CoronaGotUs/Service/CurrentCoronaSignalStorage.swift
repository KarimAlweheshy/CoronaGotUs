//
//  CurrentCoronaSignalStorage.swift
//  CoronaGotUs
//
//  Created by Karim Alweheshy on 11/25/20.
//

import Foundation
import Combine

final class CurrentCoronaSignalStorage {
    @Published private(set) var currentCoronaSignal: CoronaSignal?
    @Published private(set) var currentRegionID: Int?
    private(set) var geoElement: CoronaGeoElement?

    private let geoElementStorageKey = "current_geo_element_storage_key"

    init() {
        let geoElementData = UserDefaults.standard.object(forKey: geoElementStorageKey) as? Data
        geoElement = try? geoElementData.map { try JSONDecoder().decode(CoronaGeoElement.self, from: $0) }

        guard let geoElement = geoElement else { return }
        currentCoronaSignal = CoronaSignalFactory().makeAll().first {
            $0.range.contains(geoElement.cases7Per100k)
        }
        currentRegionID = geoElement.id
    }

    func update(geoElement: CoronaGeoElement?) {
        guard geoElement != self.geoElement else { return }

        // assign new signal if changed
        let newCurrentCoronaSignal = geoElement.flatMap { geoElement in
            CoronaSignalFactory().makeAll().first {
                $0.range.contains(geoElement.cases7Per100k)
            }
        }
        if newCurrentCoronaSignal != currentCoronaSignal {
            currentCoronaSignal = newCurrentCoronaSignal
        }

        // assign new region id if changed
        let newCurrentRegionID = geoElement?.id
        if newCurrentRegionID != currentRegionID {
            currentRegionID = newCurrentRegionID
        }

        self.geoElement = geoElement
        updateStorage()
    }

    private func updateStorage() {
        guard
            let geoElement = geoElement,
            let encoded = try? JSONEncoder().encode(geoElement)
        else { return }
        UserDefaults.standard.set(encoded, forKey: geoElementStorageKey)
    }
}
