//
//  ArtistEditViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/21.
//

import UIKit
import SnapKit
import Then

class ArtistEditViewController: UIViewController {
    
    private let editItemsArray: [String] = ["지역 설정", "장비 정보", "컨셉 태그", "자기 소개", "포트폴리오 사진"]
    
    private let editItemsImageArray: [String] = ["mappin.and.ellipse", "camera.shutter.button", "tag", "doc.plaintext", "photo.artframe"]
    
    private let editViews: [UIViewController] = []
    
    private let mainTitleLabel = UILabel().makeBasicLabel(labelText: "작가 정보 수정하기", textColor: .textMainBlack, fontStyle: .largeTitle, fontWeight: .bold)
    
    private let customNavigationBarView = RegisterCustomNavigationView()
    
    private lazy var editItemsTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.rowHeight = self.view.bounds.height/12
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func render() {
        view.addSubviews(customNavigationBarView, mainTitleLabel, editItemsTableView)
        
        customNavigationBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(view.bounds.height/16)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(customNavigationBarView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(30)
        }
        
        editItemsTableView.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configUI() {
        view.backgroundColor = .white
        customNavigationBarView.popImage.isHidden = true
        editItemsTableView.delegate = self
        editItemsTableView.dataSource = self
        editItemsTableView.register(ArtistEditItemsTableViewCell.self, forCellReuseIdentifier: "editCell")
    }
    
    
}

extension ArtistEditViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        editItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as? ArtistEditItemsTableViewCell else { return UITableViewCell() }
        let imageWeight = UIImage.SymbolConfiguration(weight: .bold)
        
        cell.cellImage.image = UIImage(systemName: editItemsImageArray[indexPath.row], withConfiguration: imageWeight)
        cell.cellTextLabel.text = editItemsArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = RegisterRegionViewController()
            vc.modalPresentationStyle = .fullScreen
            navigationController?.present(vc, animated: true)
        case 1:
            let vc = RegisterGearsViewController()
            vc.modalPresentationStyle = .fullScreen
            navigationController?.present(vc, animated: true)
        case 2:
            let vc = RegisterConceptTagViewController()
            vc.modalPresentationStyle = .fullScreen
            navigationController?.present(vc, animated: true)
        case 3:
            let vc = RegisterTextDescriptionViewController()
            vc.modalPresentationStyle = .fullScreen
            navigationController?.present(vc, animated: true)
        case 4:
            let vc = RegisterPortfolioViewController()
            vc.modalPresentationStyle = .fullScreen
            navigationController?.present(vc, animated: true)
        default:
            print("not yet")
            return
        }
    }
    
}
