//
//  ProfileHeaderVIew.swift
//  Flicker
//
//  Created by Taehwan Kim on 2022/11/03.
//

import UIKit
import SnapKit
import Then

final class ProfileHeaderVIew: UIView {
    // MARK: - Properties
    private var userImage: Data? = nil
    private var userName: String? = nil
    private var userEmail: String? = nil
    
    // MARK: 오토레이아웃 미적용
    private lazy var headerCard = UIView().then {
        $0.layer.cornerRadius = 20
        $0.backgroundColor = .white
    }
    
    private lazy var profileImage = UIImageView().then {
        if let userImage = userImage {
            $0.image = UIImage(data: userImage)
        } else {
            $0.image = UIImage(named: "DefaultProfile")
        }
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 40
        $0.clipsToBounds = true
    }
    
    private lazy var idLabel = UILabel().then {
        $0.text = userName ?? "Unknown"
        $0.font = .preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.textColor = .textMainBlack
    }
    
    private lazy var emailLabel = UILabel().then {
        $0.text = userEmail ?? "User Email Error"
        $0.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        $0.textColor = .textSubBlack
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
        headerCard.addSubviews(profileImage, idLabel, emailLabel)
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
            $0.top.equalTo(profileImage.snp.top)
            $0.leading.equalTo(profileImage.snp.trailing).offset(10)
        }
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(10)
            $0.leading.equalTo(idLabel)
        }
    }
}
