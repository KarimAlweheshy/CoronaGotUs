//
//  CoronaRulesViewController.swift
//  CoronaGotUs
//
//  Created by Karim Alweheshy on 11/26/20.
//

import UIKit

final class CoronaRulesViewController: UIViewController {
    @IBOutlet private var signalColorView: UIView!
    @IBOutlet private var ruleNameLabel: UILabel!
    @IBOutlet private var ruleRangeLabel: UILabel!
    @IBOutlet private var generalRuleLabel: UILabel!
    @IBOutlet private var firstRuleLabel: UILabel!
    @IBOutlet private var secondRuleLabel: UILabel!
    @IBOutlet private var thirdRuleLabel: UILabel!

    private let coronaSignal: CoronaSignal

    init?(coder: NSCoder, coronaSignal: CoronaSignal) {
        self.coronaSignal = coronaSignal
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("Not yet implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Private Methods

extension CoronaRulesViewController {
    private func setupUI() {
        view.backgroundColor = coronaSignal.color
        signalColorView.backgroundColor = coronaSignal.color
        ruleNameLabel.text = "\(NSLocalizedString("corona_legend_cell_signal_key", comment: "")): \(NSLocalizedString(coronaSignal.localizedLabelKey, comment: ""))"
        if coronaSignal.range.upperBound > 10000 {
            ruleRangeLabel.text = "\(NSLocalizedString("corona_legend_cell_range_key", comment: "")): \(Int(coronaSignal.range.lowerBound)).../100k"
        } else {
            ruleRangeLabel.text = "\(NSLocalizedString("corona_legend_cell_range_key", comment: "")): \(Int(coronaSignal.range.lowerBound))..<\(Int(coronaSignal.range.upperBound))/100k"
        }
        generalRuleLabel.text = NSLocalizedString("corona_signal_general_rule", comment: "")
        let labels: [UILabel] = [firstRuleLabel, secondRuleLabel, thirdRuleLabel]
        zip(labels, coronaSignal.localizableRulesKeys).forEach { label, rule in
            label.text = "- \(NSLocalizedString(rule, comment: ""))"
        }
        title = NSLocalizedString("rules", comment: "")
    }
}
