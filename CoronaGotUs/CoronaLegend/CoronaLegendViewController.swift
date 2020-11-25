//
//  CoronaLegendViewController.swift
//  CoronaGotUs
//
//  Created by Karim Alweheshy on 11/25/20.
//

import UIKit

final class CoronaLegendViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    private let signals = CoronaSignalFactory().makeAll()
}

// MARK: - Actions

extension CoronaLegendViewController {
    @IBAction private func didTapDone() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension CoronaLegendViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        signals.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let signal = signals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoronaLegendCell", for: indexPath) as! CoronaLegendCell
        cell.delegate = self
        if signal.range.upperBound > 100000 {
            cell.rangeValueLabel.text = "\(Int(signal.range.lowerBound)).../100k"
        } else {
            cell.rangeValueLabel.text = "\(Int(signal.range.lowerBound))..<\(Int(signal.range.upperBound))/100k"
        }
        cell.signalValueLabel.text = NSLocalizedString(signal.localizedLabelKey, comment: "")
        cell.legendColorView.backgroundColor = signal.color
        return cell
    }
}

// MARK: - CoronaLegendCellDelegate

extension CoronaLegendViewController: CoronaLegendCellDelegate {
    func didTapShowRules(_ cell: CoronaLegendCell) {
        guard let _ = tableView.indexPath(for: cell) else { return }

    }
}

extension CoronaLegendViewController {
    private func setupUI() {
        title = NSLocalizedString("corona_legend_title", comment: "")
    }
}
