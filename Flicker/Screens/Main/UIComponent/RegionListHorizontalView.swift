//
//  RegionListHorizontalView.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/11/03.
//

import UIKit

import SnapKit
import Then

final class RegionListHorizontalView: UIView {

    private let reigionList = ["전체", "서울", "부산", "포항", "동해", "삼척", "강릉", "춘천", "속초"]
    
    private var parent: MainViewController?
    
    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 20.0
        static let collectionVerticalSpacing: CGFloat = 0.0
        static let cellWidth: CGFloat = 60
        static let cellHeight: CGFloat = 60
        static let collectionInset = UIEdgeInsets(top: collectionVerticalSpacing,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    
    // MARK: - property
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.sectionInset = Size.collectionInset
        $0.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        $0.minimumLineSpacing = 6
    }
    
    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.register(RegionCollectionViewCell.self,
                                forCellWithReuseIdentifier: RegionCollectionViewCell.className)
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        self.addSubview(listCollectionView)
        
        listCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setParentViewController(viewController: MainViewController) {
        self.parent = viewController
    }
}

// MARK: - UICollectionViewDataSource
extension RegionListHorizontalView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reigionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegionCollectionViewCell.className, for: indexPath) as? RegionCollectionViewCell else {
            assert(false, "Wrong Cell")
        }
        
        if indexPath.item == 0 {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false , scrollPosition: .init())
        }
        
        cell.regionLabel.text = reigionList[indexPath.item]
    
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RegionListHorizontalView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        parent?.setRegion(region: reigionList[indexPath.item])
    }
}
