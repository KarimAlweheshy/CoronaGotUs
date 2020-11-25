//
//  CoronaLegendCell.swift
//  CoronaGotUs
//
//  Created by Karim Alweheshy on 11/25/20.
//

import UIKit

protocol CoronaLegendCellDelegate: AnyObject {
    func didTapShowRules(_: CoronaLegendCell)
}

final class CoronaLegendCell: UITableViewCell {
    weak var delegate: CoronaLegendCellDelegate?

    @IBOutlet var legendColorView: UIView!
    @IBOutlet private var signalKeyLabel: UILabel!
    @IBOutlet var signalValueLabel: UILabel!
    @IBOutlet private var rangeKeyLabel: UILabel!
    @IBOutlet var rangeValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        signalKeyLabel.text = NSLocalizedString("corona_legend_cell_signal_key", comment: "")
        rangeKeyLabel.text = NSLocalizedString("corona_legend_cell_range_key", comment: "")
    }

    @IBAction private func didTapShowRules() {
        delegate?.didTapShowRules(self)
    }
}
