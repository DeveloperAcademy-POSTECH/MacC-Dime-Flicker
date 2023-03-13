//
//  RegionTagListView.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class RegionTagListView: UIView {
    
    private var parent: RegionViewController?
    
    var regionList = [String]()
    
    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 20.0
        static let collectionVerticalSpacing: CGFloat = 10.0
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - collectionHorizontalSpacing * 2 - 24) / 4
        static let cellHeight: CGFloat = 40
        static let collectionInset = UIEdgeInsets(top: collectionVerticalSpacing,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    
    // MARK: - property
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.sectionInset = Size.collectionInset
        $0.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        $0.minimumLineSpacing = 8
        $0.minimumInteritemSpacing = 8
    }
    
    lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.register(RegionCollectionViewCell.self,
                                forCellWithReuseIdentifier: RegionCollectionViewCell.className)
        $0.allowsMultipleSelection = true
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
    
    func setParentViewController(viewController: RegionViewController) {
        self.parent = viewController
    }
}

// MARK: - UICollectionViewDataSource
extension RegionTagListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return regionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegionCollectionViewCell.className, for: indexPath) as? RegionCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.regionLabel.text = regionList[indexPath.item]
        
        if let selectedRegions = parent?.selectedRegions {
            if selectedRegions.contains(regionList[indexPath.item]) {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
            }
        }
    
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RegionTagListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        parent?.addRegion(region: regionList[indexPath.item])
        listCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        parent?.removeRegion(region: regionList[indexPath.item])
    }
}
