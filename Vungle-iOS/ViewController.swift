//
//  ViewController.swift
//  Vungle-iOS
//
//  Created by ryokosuge on 2021/01/13.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var showButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        showButton?.isEnabled = false
        VungleSDK.shared().delegate = self
    }

}

extension ViewController {

    @IBAction private func load() {
        // どうやら初期化時に読み込みをしてくれているっぽい
        // delegateのvungleAdPlayabilityUpdateがcallされるので
        // loadする前に状態を確認する
        if VungleSDK.shared().isAdCached(forPlacementID: Consts.Vungle.Placements.reward) {
            showButton?.isEnabled = true
            return
        }

        do {
            try VungleSDK.shared().loadPlacement(withID: Consts.Vungle.Placements.reward)
        } catch {
            print("failed load error:   \(error)")
        }
    }

    @IBAction private func show() {
        if VungleSDK.shared().isAdCached(forPlacementID: Consts.Vungle.Placements.reward) {
            do {
                // VungleSDK.shared().muted = true
                // だとmuteにならないので、playAdのoptionで渡す
                // 1 = muted / 0 = unmuted
                let options = [VunglePlayAdOptionKeyStartMuted: 1]
                try VungleSDK.shared().playAd(self, options: options, placementID: Consts.Vungle.Placements.reward)
            } catch {
                print("failed play error:   \(error)")
            }
        }
    }

}

extension ViewController: VungleSDKDelegate {

    func vungleAdPlayabilityUpdate(_ isAdPlayable: Bool, placementID: String?, error: Error?) {
        print("[Vungle-iOS]", #function, "placementID:  \(placementID ?? "nil")", "isAdPlayable:    \(isAdPlayable)", error?.localizedDescription ?? "nil")
        showButton?.isEnabled = isAdPlayable
    }

    func vungleWillShowAd(forPlacementID placementID: String?) {
        print("[Vungle-iOS]", #function, "placementID:  \(placementID ?? "nil")")
    }

    func vungleDidShowAd(forPlacementID placementID: String?) {
        print("[Vungle-iOS]", #function, "placementID:  \(placementID ?? "nil")")
    }

    func vungleRewardUser(forPlacementID placementID: String?) {
        print("[Vungle-iOS]", #function, "placementID:  \(placementID ?? "nil")")
    }

    func vungleTrackClick(forPlacementID placementID: String?) {
        print("[Vungle-iOS]", #function, "placementID:  \(placementID ?? "nil")")
    }

    func vungleWillLeaveApplication(forPlacementID placementID: String?) {
        print("[Vungle-iOS]", #function, "placementID:  \(placementID ?? "nil")")
    }

    func vungleWillCloseAd(forPlacementID placementID: String) {
        print("[Vungle-iOS]", #function, "placementID:  \(placementID)")
    }

    func vungleDidCloseAd(forPlacementID placementID: String) {
        print("[Vungle-iOS]", #function, "placementID:  \(placementID)")
    }

}
