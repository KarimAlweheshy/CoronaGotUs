//
//  CoronaGeoElement.swift
//  CoronaGotUs
//
//  Created by Karim Alweheshy on 11/25/20.
//

import Foundation

struct CoronaGeoElement: Codable, Equatable {
    let id: Int
    let casesPer100k: Double
    let type: String
    let cases7Per100k: Double
    let casesPerPopulation: Double
    let deaths: Int
    let cases: Int
    let stateName: String
    let regionName: String
    let deathRate: Double
    let county: String

    enum CodingKeys: String, CodingKey {
        case casesPer100k = "cases_per_100k"
        case type = "BEZ"
        case cases7Per100k = "cases7_per_100k"
        case casesPerPopulation = "cases_per_population"
        case deaths = "deaths"
        case cases = "cases"
        case stateName = "BL"
        case regionName = "GEN"
        case id = "OBJECTID"
        case deathRate = "death_rate"
        case county = "county"
    }
}
