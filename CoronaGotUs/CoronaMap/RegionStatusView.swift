//
//  RegionStatusView.swift
//  CoronaGotUs
//
//  Created by Karim Alweheshy on 11/25/20.
//

import UIKit
import Combine

final class RegionStatusView: UIView {
    @IBOutlet private var blinkingView: UIView!
    @IBOutlet private var regionNameLabel: UILabel!

    private var disposables = Set<AnyCancellable>()

    override func awakeFromNib() {
        super.awakeFromNib()
        isHidden = true
        blinkImage()
        restartAnimationOnProcessRestart()
    }

    func update(for geoElement: CoronaGeoElement?) {
        UIView.animate(withDuration: 0.3) { self.isHidden = false }

        let signal = geoElement.flatMap { element in
            CoronaSignalFactory().makeAll().first {
                $0.range.contains(element.cases7Per100k)
            }
        }
        blinkingView.backgroundColor = signal?.color
        regionNameLabel.text = geoElement?.regionName ?? "Unknown"
    }

    private func blinkImage() {
        blinkingView.alpha = 0.0;
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.blinkingView.alpha = 1.0 },
            completion: { [weak self] _ in self?.blinkingView.alpha = 0.0 }
        )
    }

    private func restartAnimationOnProcessRestart() {
        disposables.insert(
            NotificationCenter
                .default
                .publisher(for: UIApplication.didEnterBackgroundNotification)
                .sink { _ in self.blinkingView.layer.removeAllAnimations() }
        )

        disposables.insert(
            NotificationCenter
                .default
                .publisher(for: UIApplication.didBecomeActiveNotification)
                .dropFirst()
                .sink { _ in self.blinkImage()}
        )
    }
}
