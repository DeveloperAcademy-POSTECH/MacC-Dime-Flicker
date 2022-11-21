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
    
    // 받아온 나의 정보를 캐싱한 데이터
    
    private let editItemsArray: [String] = ["지역 수정", "장비 수정", "태그 수정", "자기 소개 수정", "포트폴리오 수정"]
    
    private let editItemsImageArray: [String] = ["mappin.and.ellipse", "camera.shutter.button", "tag", "doc.plaintext", "photo.artframe"]
    
    private let editViews: [UIViewController] = []
    
    private let mainTitleLabel = UILabel().makeBasicLabel(labelText: "작가 정보 수정하기", textColor: .textMainBlack, fontStyle: .title1, fontWeight: .bold)
    
    private lazy var editItemsTableView = UITableView().then {
        $0.clipsToBounds = true
        $0.separatorStyle = .none
        $0.rowHeight = self.view.bounds.height/11
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    
    private let resetEditButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        $0.tintColor = .black.withAlphaComponent(0.6)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.backgroundColor = .systemGray3.withAlphaComponent(0.5)
        $0.setTitleColor(.systemOrange.withAlphaComponent(0.2), for: .highlighted)
        $0.clipsToBounds = true
    }
    
    private let completeEditButton = UIButton(type: .system).then {
        $0.tintColor = .white
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.backgroundColor = .mainPink
        $0.setTitle("수정 완료", for: .normal)
        $0.clipsToBounds = true
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
        view.addSubviews(mainTitleLabel, editItemsTableView, resetEditButton, completeEditButton)

        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.leading.equalToSuperview().inset(30)
        }

        editItemsTableView.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(editItemsTableView.rowHeight*5)
        }
        
        resetEditButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(UIScreen.main.bounds.height/13)
            $0.leading.equalToSuperview().inset(20)
            $0.height.width.equalTo(view.bounds.height/12)
        }
        
        completeEditButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(UIScreen.main.bounds.height/13)
            $0.leading.equalTo(resetEditButton.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(view.bounds.height/12)
        }
    }
    
    private func configUI() {
        view.backgroundColor = .white
        
        editItemsTableView.delegate = self
        editItemsTableView.dataSource = self
        editItemsTableView.register(ArtistEditItemsTableViewCell.self, forCellReuseIdentifier: "editCell")
        editItemsTableView.layer.cornerRadius = 20
        
        resetEditButton.addTarget(self, action: #selector(resetEditTapped), for: .touchUpInside)
        completeEditButton.addTarget(self, action: #selector(completeEditTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let buttonCornerRadius = view.bounds.width/18
        resetEditButton.layer.cornerRadius = self.resetEditButton.frame.width/2
        completeEditButton.layer.cornerRadius = buttonCornerRadius
    }
}

extension ArtistEditViewController {
    @objc func resetEditTapped() {
        print("reset")
    }
    
    @objc func completeEditTapped() {
        print("complete and out")
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
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .popover
            navigationController?.present(vc, animated: true)
        case 1:
            let vc = RegisterGearsViewController()
            vc.modalPresentationStyle = .popover
            navigationController?.present(vc, animated: true)
        case 2:
            let vc = RegisterConceptTagViewController()
            vc.modalPresentationStyle = .popover
            navigationController?.present(vc, animated: true)
        case 3:
            let vc = RegisterTextDescriptionViewController()
            vc.modalPresentationStyle = .popover
            navigationController?.present(vc, animated: true)
        case 4:
            let vc = RegisterPortfolioViewController()
            vc.modalPresentationStyle = .popover
            navigationController?.present(vc, animated: true)
        default:
            print("not yet")
            return
        }
    }
}
