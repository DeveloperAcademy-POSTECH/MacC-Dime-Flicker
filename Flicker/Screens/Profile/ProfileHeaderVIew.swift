//
//  ProfileHeaderVIew.swift
//  Flicker
//
//  Created by Taehwan Kim on 2022/11/03.
//

import UIKit
import SnapKit
import Then
import FirebaseAuth

final class ProfileHeaderVIew: UIView {
    // MARK: 오토레이아웃 미적용
    private lazy var headerCard = UIView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .white
    }
    
    private lazy var profileImage = UIImageView().then {
        $0.image = UIImage(named: "DefaultProfile")
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 40
        $0.clipsToBounds = true
    }
    
    private lazy var idLabel = UILabel().then {
        $0.text = "Unknown"
        $0.font = .preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.textColor = .textMainBlack
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Render
    func configureUI() {
        addSubviews(headerCard)
        headerCard.addSubviews(profileImage, idLabel)
        headerCard.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        profileImage.snp.makeConstraints {
            $0.height.width.equalTo(80)
            $0.leading.equalTo(headerCard.snp.leading).inset(30)
            $0.centerY.equalToSuperview()
        }
        idLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImage.snp.centerY)
            $0.leading.equalTo(profileImage.snp.trailing).offset(20)
        }
    }
    func setupHeaderData( name: String, imageURL: String) async {
        do {
            self.idLabel.text = "\(name)님"
            self.profileImage.image = try await NetworkManager.shared.fetchOneImage(withURL: imageURL)
        } catch {
            print(error)
        }
    }
}
