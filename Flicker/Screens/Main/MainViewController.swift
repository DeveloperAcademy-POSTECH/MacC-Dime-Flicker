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
        static let collectionVerticalSpacing: CGFloat = 0.0
        static let cellWidth: CGFloat = UIScreen.main.bounds.size.width - collectionHorizontalSpacing * 2
        static let cellHeight: CGFloat = 300
        static let collectionInset = UIEdgeInsets(top: collectionVerticalSpacing,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    
    private var selectedRegions: [String] = ["전체"]

    // MARK: - property
    
    private let appTitleLabel = UILabel().then {
        $0.font = UIFont(name: "TsukimiRounded-Bold", size: 30)
        $0.textColor = .mainPink
        $0.textAlignment = .center
        $0.text = "SHUGGLE"
    }
    
    private lazy var regionTagButton = UIButton().then {
        $0.tintColor = .mainPink
        $0.setTitle("전체 ", for: .normal)
        $0.setTitleColor(.mainBlack.withAlphaComponent(0.7), for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        $0.setImage(ImageLiteral.btnDown, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.addTarget(self, action: #selector(didTapRegionTag), for: .touchUpInside)
    }
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.sectionInset = Size.collectionInset
        $0.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        $0.minimumLineSpacing = 20
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
        
        navigationController?.isNavigationBarHidden = true
        
        guard let regions = UserDefaults.standard.stringArray(forKey: "regions") else { return }
        selectedRegions = regions

        if selectedRegions.isEmpty {
            selectedRegions = ["전체"]
        }
        let count = selectedRegions.count == 1 ? "" : "외 \(selectedRegions.count-1)곳"
        regionTagButton.setTitle("\(selectedRegions[0]) \(count) ", for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.realoadTable(_:)), name: Notification.Name("willDissmiss"), object: nil)
    }
    
    override func render() {
        view.addSubviews(appTitleLabel, regionTagButton, listCollectionView)
        
        appTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        regionTagButton.snp.makeConstraints {
            $0.bottom.equalTo(appTitleLabel.snp.bottom).offset(-6)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(appTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - func
    
    @objc func realoadTable(_ noti: Notification) {
        guard let regions = UserDefaults.standard.stringArray(forKey: "regions") else { return }
        selectedRegions = regions
        
        if selectedRegions.isEmpty {
            selectedRegions = ["전체"]
        }
        let count = selectedRegions.count == 1 ? "" : "외 \(selectedRegions.count-1)곳"
        regionTagButton.setTitle("\(selectedRegions[0]) \(count) ", for: .normal)
    }
    
    @objc private func didTapRegionTag() {
        let vc = RegionViewController()
        vc.modalPresentationStyle = .pageSheet
        vc.sheetPresentationController?.detents = [.medium()]
        
        present(vc, animated: true, completion: nil)
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
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard velocity.y != 0 else { return }
            if velocity.y < 0 {
                let height = self?.tabBarController?.tabBar.frame.height ?? 0.0
                self?.tabBarController?.tabBar.alpha = 1.0
                self?.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - height)
            } else {
                self?.tabBarController?.tabBar.alpha = 0.0
                self?.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 터치시 넘어가는 화면 코드 구현 예정
    }
}
