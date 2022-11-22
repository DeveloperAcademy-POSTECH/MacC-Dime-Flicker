//
//  ArtistEditRegionsViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/22.
//

import UIKit
import SnapKit
import Then

    // TODO: (다음 버전에..)
final class ArtistEditRegionsViewController: UIViewController {

    // MARK: - custom delegate to send Datas
    weak var delegate: EditRegionsDelegate?
    
    // MARK: - data sets to post to the server
    // TODO: - deleate 만들어서 ArtistRegisterViewController 에 연결해야한다.
    var selectedRegion: [String] = []

    // MARK: - data sets of regions of seoul
    private let seoulNorthDistricts: [String] = ["도봉구", "노원구", "강북구", "성북구", "은평구", "중랑구", "종로구", "동대문구", "서대문구", "중구", "성동구", "광진구", "마포구", "용산구"]
    
    private let seoulSouthDistricts: [String] = ["강서구", "양천구", "영등포구", "구로구", "동작구", "금천구", "관악구", "서초구", "강남구", "송파구", "강동구"]
    
    private enum districtIdentifier: String {
        case north = "서울강북"
        case south = "서울강남"
    }
    
    // MARK: - custom navigation bar
    private let customNavigationBarView = RegisterCustomNavigationView()
    
    // MARK: - view UI components
    private let mainTitleLabel = UILabel().then {
        $0.textColor = .systemTeal
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "지역 수정"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.text = "활동 지역을 수정할 수 있어요!"
    }
    
    private let bodyTitleLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.text = "지역은 최대 3개까지 설정할 수 있어요."
    }
    
    private lazy var completeEditButton = UIButton(type: .system).then {
        $0.tintColor = .white
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.backgroundColor = .systemTeal.withAlphaComponent(0.5)
        $0.setTitle("지역 수정 완료", for: .normal)
        $0.clipsToBounds = true
    }
    
    // MARK: - collection view UI components
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
        
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedRegion)
        configUI()
        render()
        customBackButton()
        completeButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tagFirstCollectionView.reloadData()
        tagSecondCollectionView.reloadData()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.customNavigationBarView.popImage.isHidden = true
    }

    // MARK: - layout constraints
    private func render() {
        view.addSubviews(customNavigationBarView, mainTitleLabel, subTitleLabel, bodyTitleLabel, tagFirstCollectionView, tagSecondCollectionView, completeEditButton)

        customNavigationBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(view.bounds.height/16)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(customNavigationBarView.snp.bottom).offset(UIScreen.main.bounds.height/24)
            $0.leading.equalToSuperview().inset(30)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(30)
        }
        
        bodyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(30)
        }
        
        tagFirstCollectionView.snp.makeConstraints {
            $0.top.equalTo(bodyTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(180)
        }

        tagSecondCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagFirstCollectionView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(180)
        }
        
        completeEditButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(UIScreen.main.bounds.height/13)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(view.bounds.height/12)
        }
    }
    
    // MARK: - view configurations
    private func configUI() {
        view.backgroundColor = .systemBackground
        
        tagFirstCollectionView.delegate = self
        tagFirstCollectionView.dataSource = self
        tagFirstCollectionView.allowsMultipleSelection = true
        tagFirstCollectionView.register(RegisterRegionTagCell.self, forCellWithReuseIdentifier: districtIdentifier.north.rawValue)
        
        tagSecondCollectionView.delegate = self
        tagSecondCollectionView.dataSource = self
        tagSecondCollectionView.allowsMultipleSelection = true
        tagSecondCollectionView.register(RegisterRegionTagCell.self, forCellWithReuseIdentifier: districtIdentifier.south.rawValue)
        
        completeEditButton.layer.cornerRadius = view.bounds.width/18
    }
}

    // MARK: - collectionView datasource
extension ArtistEditRegionsViewController: UICollectionViewDataSource {
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
            let cellText = self.seoulNorthDistricts.sorted()[indexPath.row]
            cell.tagLabel.text = cellText
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: districtIdentifier.south.rawValue, for: indexPath) as? RegisterRegionTagCell else { return UICollectionViewCell()}
            let cellText = self.seoulSouthDistricts.sorted()[indexPath.row]
            cell.tagLabel.text = cellText
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

    // MARK: - collectionView delegate and flowLayout
extension ArtistEditRegionsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedRegion.count < 3 {
            switch collectionView.tag {
            case 1:
                guard let cell = collectionView.cellForItem(at: indexPath) as? RegisterRegionTagCell else { return }
                guard let cellText = cell.tagLabel.text else { return }
                cell.toggleSelected()
                selectedRegion.append(cellText)
                print(selectedRegion)
            case 2:
                guard let cell = collectionView.cellForItem(at: indexPath) as? RegisterRegionTagCell else { return }
                guard let cellText = cell.tagLabel.text else { return }
                cell.toggleSelected()
                selectedRegion.append(cellText)
                print(selectedRegion)
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
            print(selectedRegion)
        case 2:
            guard let cell = collectionView.cellForItem(at: indexPath) as? RegisterRegionTagCell else { return }
            guard let cellText = cell.tagLabel.text else { return }
            cell.toggleSelected()
            let newRegions = selectedRegion.filter { $0 != cellText }
            selectedRegion = newRegions
            print(selectedRegion)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeMultiplied = UIScreen.main.bounds.width/12 - 3
        switch collectionView.tag {
        case 1:
            let label = UILabel().then {
                $0.text = seoulNorthDistricts.sorted()[indexPath.row]
                $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .semibold)
                $0.sizeToFit()
            }
            let size = label.frame.size
            return CGSize(width: size.width + sizeMultiplied, height: size.height + 16)
        case 2:
            let label = UILabel().then {
                $0.text = seoulSouthDistricts.sorted()[indexPath.row]
                $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .semibold)
                $0.sizeToFit()
            }
            let size = label.frame.size
            return CGSize(width: size.width + sizeMultiplied, height: size.height + 16)
        default:
            return CGSize()
        }
    }
}

extension ArtistEditRegionsViewController {
    private func customBackButton() {
        let backTapped = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        customNavigationBarView.customBackButton.addGestureRecognizer(backTapped)
    }
    
    private func completeButton() {
        let completeTapped = UITapGestureRecognizer(target: self.self, action: #selector(completeButtonTapped))
        completeEditButton.addGestureRecognizer(completeTapped)
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButtonTapped() {
        self.delegate?.regionSelected(regions: self.selectedRegion)
        self.navigationController?.popViewController(animated: true)
    }
}

    // MARK: - RegisterRegion custom delegate protocol
protocol EditRegionsDelegate: AnyObject {
    func regionSelected(regions regionDatas: [String])
}
