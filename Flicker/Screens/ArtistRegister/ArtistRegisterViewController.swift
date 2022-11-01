//
//  ArtistRegisterViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/01.
//

import UIKit
import SnapKit
import Then

final class ArtistRegisterViewController: UIViewController {

    private let pageOneWelcome = RegisterWelcomView()
    private let pageTwoRegion = RegisterRegionView()
    private let pageThreeGears = RegisterGearsView()
    private let pageFourTextDescription = RegisterTextDescriptionView()
    private let pageFivePortpolio = RegisterPortfolioView()
    private let pageSixConfirm = RegisterConfirmView()
    private let pageSevenEnd = RegisterEndView()
    
    override func loadView() {
        super.loadView()
        self.view = pageTwoRegion
        print("It's working, sir")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
