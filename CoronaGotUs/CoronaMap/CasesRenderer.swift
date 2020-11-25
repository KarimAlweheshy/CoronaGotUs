//
//  CasesRenderer.swift
//  CoronaGotUs
//
//  Created by Karim Alweheshy on 11/25/20.
//

import Foundation
import ArcGIS

struct CoronaRendererFactory {
    private let borderSymbol = AGSSimpleLineSymbol(
        style: .solid,
        color: .systemGray,
        width: 1
    )

    func makeRenderer() -> AGSClassBreaksRenderer {
        let signals = CoronaSignalFactory().makeAll()
        let classBreaks = signals.compactMap(classBreak(for:))
        return AGSClassBreaksRenderer(
            fieldName: "cases7_per_100k",
            classBreaks: classBreaks
        )
    }

    private func classBreak(for signal: CoronaSignal) -> AGSClassBreak {
        AGSClassBreak(
            description: localizedRules(for: signal.localizableRulesKeys),
            label: NSLocalizedString(signal.localizedLabelKey, comment: ""),
            minValue: signal.range.lowerBound,
            maxValue: signal.range.upperBound,
            symbol: fillSymbol(for: signal.color)
        )
    }

    private func fillSymbol(for color: UIColor) -> AGSSimpleFillSymbol {
        AGSSimpleFillSymbol(
            style: .solid,
            color: color,
            outline: borderSymbol
        )
    }

    private func localizedRules(for keys: [String]) -> String {
        keys
            .compactMap { NSLocalizedString($0, comment: "") }
            .joined(separator: "\n")
    }
}
