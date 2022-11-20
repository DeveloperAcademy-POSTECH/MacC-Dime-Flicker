//
//  RegionViewController.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class RegionViewController: BaseViewController {
    
    private let regionList = [
        "전체": ["전체"],
        "서울강북": ["도봉구", "노원구", "강북구", "성북구", "은평구", "중랑구", "종로구", "동대문구", "서대문구", "중구", "성동구", "광진구", "마포구", "용산구"],
        "서울강남": ["강서구", "양천구", "영등포구", "구로구", "동작구", "금천구", "관악구", "서초구", "강남구", "송파구", "강동구"]
    ]
    
    var selectedState: String = "전체"
    var selectedRegions: [String] = ["전체"]

    // MARK: - property
    
    private let stateTagListView = StateTagListView()
    
    private let regionTagListView = RegionTagListView()
    
    private lazy var completeButton = UIButton().then {
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .mainPink
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("완료", for: .normal)
        $0.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regionTagListView.regionList = ["전체"]
        
        if let state = UserDefaults.standard.string(forKey: "state") {
            self.selectedState = state
            regionTagListView.regionList = regionList[state] ?? ["전체"]
        }
        
        if let regions = UserDefaults.standard.stringArray(forKey: "regions") {
            self.selectedRegions = regions
        }
        
        stateTagListView.setParentViewController(viewController: self)
        regionTagListView.setParentViewController(viewController: self)
    }
    
    override func render() {
        view.addSubviews(stateTagListView, regionTagListView, completeButton)
        
        stateTagListView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        regionTagListView.snp.makeConstraints {
            $0.top.equalTo(stateTagListView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(completeButton.snp.top).offset(-20)
        }
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(60)
        }
    }
    
    // MARK: - func
    
    func setState(state: String) {
        self.selectedState = state
        
        DispatchQueue.main.async {
            self.regionTagListView.regionList = self.regionList[self.selectedState] ?? ["전체"]
            self.regionTagListView.listCollectionView.reloadData()
        }
    }
    
    func addRegion(region: String) {
        if region == "전체" {
            selectedRegions = ["전체"]
        } else {
            selectedRegions = selectedRegions.filter {$0 != "전체"}
            selectedRegions.append(region)
        }
    }
    
    func removeRegion(region: String) {
        if selectedRegions.contains(region) {
            selectedRegions = selectedRegions.filter {$0 != region}
        }
        
        if selectedRegions.count == 0 {
            selectedRegions = ["전체"]
        }
    }
    
    // MARK: - selector
    
    @objc private func didTapCompleteButton() {
        UserDefaults.standard.setValue(selectedState, forKey: "state")
        UserDefaults.standard.set(selectedRegions, forKey: "regions")
        
        NotificationCenter.default.post(name: Notification.Name("willDissmiss"), object: nil)
        
        dismiss(animated: true, completion: nil)
    }
}
