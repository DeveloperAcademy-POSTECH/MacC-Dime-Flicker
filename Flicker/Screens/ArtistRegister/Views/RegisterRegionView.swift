//
//  RegisterRegionView.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/01.
//

import UIKit
import SnapKit
import Then

class RegisterRegionView: UIView {
    
    var selectedRegion: [String] = []
    
    private let seoulNorthDistricts: [String] = ["도봉구", "노원구", "강북구", "성북구", "은평구", "중랑구", "종로구", "동대문구", "서대문구", "중구", "성동구", "광진구", "마포구", "용산구"]
    
    private let seoulSouthDistricts: [String] = ["강서구", "양천구", "영등포구", "구로구", "동작구", "금천구", "관악구", "서초구", "강남구", "송파구", "강동구"]
    
    private enum districtIdentifier: String {
        case north = "seoulNorth"
        case south = "seoulSouth"
    }
    
    private let mainTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "지역 설정"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .headline, weight: .semibold)
        $0.text = "주로 활동하는 지역을 알려주세요!"
    }
    
    private let bodyTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .medium)
        $0.text = "지역은 최대 3개까지 설정할 수 있어요."
    }
    
    private let tagFirstCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 9
        layout.minimumInteritemSpacing = 7
        
        let tagListView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        tagListView.tag = 1
        tagListView.isScrollEnabled = false
        return tagListView
    }()
    
    private let tagSecondCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 9
        layout.minimumInteritemSpacing = 7
        
        let tagListView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        tagListView.tag = 2
        tagListView.isScrollEnabled = false
        return tagListView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        tagFirstCollectionView.delegate = self
        tagFirstCollectionView.dataSource = self
        tagFirstCollectionView.allowsMultipleSelection = true
        tagSecondCollectionView.delegate = self
        tagSecondCollectionView.dataSource = self
        tagSecondCollectionView.allowsMultipleSelection = true
        tagFirstCollectionView.register(RegisterRegionTagCell.self, forCellWithReuseIdentifier: districtIdentifier.north.rawValue)
        tagSecondCollectionView.register(RegisterRegionTagCell.self, forCellWithReuseIdentifier: districtIdentifier.south.rawValue)
    }
    
    override func updateConstraints() {
        render()
        super.updateConstraints()
    }
    
    private func render() {
        self.addSubviews(mainTitleLabel, subTitleLabel, bodyTitleLabel, tagFirstCollectionView, tagSecondCollectionView)
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(40)
            $0.leading.equalToSuperview().inset(40)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(45)
        }
        
        bodyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(45)
        }
        
        // TODO: CollectionView 자체의 height 를 동적으로 바꾸고 싶은데...
        tagFirstCollectionView.snp.makeConstraints {
            $0.top.equalTo(bodyTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(45)
            $0.height.greaterThanOrEqualTo(150)
        }
        
        tagSecondCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagFirstCollectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(45)
            $0.height.greaterThanOrEqualTo(110)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RegisterRegionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return seoulNorthDistricts.sorted().count
        case 2:
            return seoulSouthDistricts.sorted().count
        default:
            print("error in numberOfItemSection")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: districtIdentifier.north.rawValue, for: indexPath) as? RegisterRegionTagCell else { return UICollectionViewCell()}
            cell.tagLabel.text = self.seoulNorthDistricts.sorted()[indexPath.row]
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: districtIdentifier.south.rawValue, for: indexPath) as? RegisterRegionTagCell else { return UICollectionViewCell()}
            cell.tagLabel.text = self.seoulSouthDistricts.sorted()[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension RegisterRegionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedRegion.count < 3 {
            switch collectionView.tag {
            case 1:
                guard let cell = collectionView.cellForItem(at: indexPath) as? RegisterRegionTagCell else { return }
                guard let cellText = cell.tagLabel.text else { return }
                cell.toggleSelected()
                selectedRegion.append(cellText)
                print(selectedRegion, selectedRegion.count)
            case 2:
                guard let cell = collectionView.cellForItem(at: indexPath) as? RegisterRegionTagCell else { return }
                guard let cellText = cell.tagLabel.text else { return }
                cell.toggleSelected()
                selectedRegion.append(cellText)
                print(selectedRegion, selectedRegion.count)
            default:
                return
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 1:
            guard let cell = collectionView.cellForItem(at: indexPath) as? RegisterRegionTagCell else { return }
            guard let cellText = cell.tagLabel.text else { return }
            cell.toggleSelected()
            let newRegions = selectedRegion.filter { $0 != cellText }
            selectedRegion = newRegions
            print(selectedRegion, selectedRegion.count)
        case 2:
            guard let cell = collectionView.cellForItem(at: indexPath) as? RegisterRegionTagCell else { return }
            guard let cellText = cell.tagLabel.text else { return }
            cell.toggleSelected()
            let newRegions = selectedRegion.filter { $0 != cellText }
            selectedRegion = newRegions
            print(selectedRegion, selectedRegion.count)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 1:
            let label = UILabel().then {
                $0.text = seoulNorthDistricts.sorted()[indexPath.row]
                $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .semibold)
                $0.sizeToFit()
            }
            let size = label.frame.size
            return CGSize(width: size.width + 18, height: size.height + 10)
        case 2:
            let label = UILabel().then {
                $0.text = seoulSouthDistricts.sorted()[indexPath.row]
                $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .semibold)
                $0.sizeToFit()
            }
            let size = label.frame.size
            return CGSize(width: size.width + 18, height: size.height + 10)
        default:
            return CGSize()
        }
    }
}
