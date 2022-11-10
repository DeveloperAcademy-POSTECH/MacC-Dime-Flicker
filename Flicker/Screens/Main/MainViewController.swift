//
//  MainViewController.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import SnapKit
import Then

final class MainViewController: BaseViewController {
    
    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 20.0
        static let collectionVerticalSpacing: CGFloat = 20.0
        static let cellWidth: CGFloat = UIScreen.main.bounds.size.width - collectionHorizontalSpacing * 2
        static let cellHeight: CGFloat = 300
        static let collectionInset = UIEdgeInsets(top: collectionVerticalSpacing,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    
    private var region: String = "전체"

    // MARK: - property
    
    private let appTitleLabel = UILabel().then {
        $0.font = UIFont(name: "TsukimiRounded-Bold", size: 30)
        $0.textColor = .mainPink
        $0.textAlignment = .center
        $0.text = "SHUGGLE"
    }
    
    private let regionListHorizontalView = RegionListHorizontalView()
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.sectionInset = Size.collectionInset
        $0.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        $0.minimumLineSpacing = 24
    }
    
    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.register(ArtistThumnailCollectionViewCell.self, forCellWithReuseIdentifier: ArtistThumnailCollectionViewCell.className)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regionListHorizontalView.setParentViewController(viewController: self)
    }
    
    override func render() {
        view.addSubviews(appTitleLabel, regionListHorizontalView, listCollectionView)
        
        appTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(20)
        }
        
        regionListHorizontalView.snp.makeConstraints {
            $0.top.equalTo(appTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(regionListHorizontalView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setRegion(region: String) {
        self.region = region
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistThumnailCollectionViewCell.className, for: indexPath) as? ArtistThumnailCollectionViewCell else {
            assert(false, "Wrong Cell")
        }
        
        cell.artistNameLabel.text = "킹도영"
        cell.artistInfoLabel.text = "울트라캡숑짱짱맨울트라캡숑짱짱맨울트라캡숑짱짱맨울트라캡숑짱짱맨"
        cell.artistThumnailImageView.image = UIImage(named: "port1")
        cell.artistProfileImageView.image = UIImage(named: "port2")
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 터치시 넘어가는 화면 코드 구현 예정
    }
}
