//
//  ProfileSettingViewController.swift
//  Flicker
//
//  Created by 김연호 on 2022/11/16.
//
import UIKit

import SnapKit
import Then
import FirebaseAuth
import Firebase
/*
 LoginProfileViewController와 같은 뷰이지만 재사용성을 강조해 두 뷰를 종속시키는 것 보다
 그냥 같은 뷰를 새로 그려 따로 관리하는 것이 더 효율적이라고 생각이 되어 거의 같은 코드를 쓰는 뷰가 두 개가 있습니다.
 */
final class ProfileSettingViewController: BaseViewController {
    private var isNickNameWrite = false
    private let defaults = UserDefaults.standard
    var existingName: String = ""
    private lazy var imagePicker = UIImagePickerController().then {
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
        $0.delegate = self
    }

    lazy var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "DefaultProfile")
        $0.backgroundColor = .loginGray
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectButtonTouched)))
    }

    private func labelTemplate(labelText: String, textColor: UIColor ,fontStyle: UIFont.TextStyle, fontWeight: UIFont.Weight) -> UILabel {
        let label = UILabel().then {
            $0.text = labelText
            $0.textColor = textColor
            $0.font = .preferredFont(forTextStyle: fontStyle, weight: fontWeight)
        }
        return label
    }
    private let profileLabelFirst = UILabel().makeBasicLabel(labelText: "자신을 보여줄 수 있는 간단한 프로필 사진을 보여주세요!", textColor: .textSubBlack, fontStyle: .caption1, fontWeight: .medium)

    private let profileLabelSecond = UILabel().makeBasicLabel(labelText: "프로필 사진은 작가와 모델의 매칭에 도움을 줍니다", textColor: .textSubBlack, fontStyle: .caption1, fontWeight: .medium)
    
    private let nickNameLabel = UILabel().makeBasicLabel(labelText: "닉네임", textColor: .black, fontStyle: .title3, fontWeight: .bold)

    private lazy var nickNameField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.textSubBlack,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .light)
        ]

        $0.backgroundColor = .clear
        $0.attributedPlaceholder = NSAttributedString(string: existingName, attributes: attributes)
        $0.autocapitalizationType = .none
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.makeShadow(color: .black, opacity: 0.08, offset: CGSize(width: 0, height: 4), radius: 20)
    }
    
    private let nickNameTextFieldClearButton = UIButton().then {
        $0.setImage(UIImage(systemName: "x.circle"), for: .normal)
        $0.tintColor = .textSubBlack
    }

    private let signUpButton = UIButton().then {
        $0.backgroundColor = .loginGray
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("수정 완료", for: .normal)
        $0.layer.cornerRadius = 15
    }

    private let navigationDivider = UIView().then {
        $0.backgroundColor = .loginGray
    }

    private let nickNameDivider = UIView().then {
        $0.backgroundColor = .loginGray
    }

    override func render() {
        nickNameField.delegate = self
        signUpButton.isEnabled = false
        nickNameTextFieldClearButton.isHidden = true

        view.addSubviews(profileImageView, profileLabelFirst, profileLabelSecond, nickNameLabel, nickNameField, signUpButton, nickNameTextFieldClearButton, nickNameDivider)

        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        nickNameTextFieldClearButton.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)


        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }

        profileLabelFirst.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }

        profileLabelSecond.snp.makeConstraints {
            $0.top.equalTo(profileLabelFirst.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
        }

        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileLabelSecond.snp.bottom).offset(45)
            $0.leading.equalToSuperview().inset(20)
        }

        nickNameField.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(60)
        }

        nickNameTextFieldClearButton.snp.makeConstraints {
            $0.centerY.equalTo(nickNameField.snp.centerY)
            $0.leading.equalTo(nickNameField.snp.trailing)
            $0.trailing.equalToSuperview().inset(30)
        }

        nickNameDivider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(nickNameField.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        signUpButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
    override func loadView() {
         super.loadView()
        existingName = defaults.string(forKey: "currentUserName") ?? "Error"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "프로필 수정"
    }

    @objc private func selectButtonTouched(_ recognizer: UITapGestureRecognizer) {
        self.present(imagePicker, animated: true)
    }

    //TODO: profileImage가 없을 경우 이미지 값을 SFSymbol에서 받으려고 하는데 그 값조차 옵셔널 값으로 인식함 그래서 일단 강제언래핑 해놓음
    @objc private func didTapSignUpButton() {
        let viewController = TabbarViewController()
        let fireBaseUser = Auth.auth().currentUser
        Task { [weak self] in
//            if let fireBaseUser = fireBaseUser {
//                let email = fireBaseUser.email
//            }
            await FirebaseManager.shared.storeUserInformation(email: fireBaseUser?.email ?? "",
                                                              name: nickNameField.text ?? "",
                                                              profileImage: profileImageView.image ?? UIImage(systemName: "person")! )
            await CurrentUserDataManager.shared.saveUserDefault()
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func didTapClearButton() {
        self.nickNameField.text = ""
    }
}

extension ProfileSettingViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    override func textFieldDidEndEditing(_ textField: UITextField) {
        isNickNameWrite = true
        nickNameTextFieldClearButton.isHidden = false
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = .mainPink
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var newImage : UIImage? = nil // update 할 이미지

        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage    // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage        // 원본 이미지가 있을 경우
        }
        self.profileImageView.image = newImage
        dismiss(animated: true, completion: nil)
    }
}
