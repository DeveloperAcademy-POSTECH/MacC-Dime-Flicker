//
//  ProfileSettingViewController.swift
//  Flicker
//
//  Created by 김연호 on 2022/11/02.
//

import UIKit

import SnapKit
import Then
import FirebaseAuth

final class LoginProfileViewController: BaseViewController {

    //이전 뷰에서 데이터를 전달받는 변수들
    var isSignUpEmail: Bool = false
    var authEmail: String = ""
    var authPassword: String = ""

    private var nickNameCount: Int = 0
    private var isNickNameWrite = false
    private var isTapArtistButton = false

    // MARK: - loading UI view
    private let loadingView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .black.withAlphaComponent(0.7)
    }

    private let spinnerView = UIActivityIndicatorView(style: .large).then {
        $0.stopAnimating()
        $0.color = .mainPink
    }

    private let loadingLabel = UILabel().makeBasicLabel(labelText: "등록 중이에요!", textColor: .mainPink.withAlphaComponent(0.8), fontStyle: .headline, fontWeight: .bold).then {
        $0.shadowOffset = CGSize(width: 0.7, height: 0.7)
        $0.layer.shadowRadius = 20
        $0.shadowColor = .black.withAlphaComponent(0.6)
        $0.isHidden = true
    }

    // MARK: -LoginProfileViewUI
    private lazy var imagePicker = UIImagePickerController().then {
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
        $0.delegate = self
    }

    private lazy var profileImageView = UIImageView().then {
        $0.backgroundColor = .loginGray
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectButtonTouched)))
    }

    private let cameraImage = UIImageView().then {
        $0.tintColor = .black
        $0.image = UIImage(systemName: "camera")
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
    private let isArtistLabel = UILabel().makeBasicLabel(labelText: "사진작가로 활동할 예정이신가요?", textColor: .black, fontStyle: .title3, fontWeight: .bold)
    private let afterJoinLabel = UILabel().makeBasicLabel(labelText: "가입 후 마이프로필에서 작가등록을 하실 수 있어요!", textColor: .textSubBlack, fontStyle: .caption1, fontWeight: .medium)

    private lazy var nickNameField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.textSubBlack,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .light)
        ]

        $0.backgroundColor = .clear
        $0.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해 주세요.", attributes: attributes)
        $0.autocapitalizationType = .none
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.makeShadow(color: .black, opacity: 0.08, offset: CGSize(width: 0, height: 4), radius: 20)
        $0.autocorrectionType = .no
    }

    private lazy var nickNameCountLabel = UILabel().makeBasicLabel(labelText: "(\(self.nickNameCount)/8)", textColor: .textMainBlack, fontStyle: .body, fontWeight: .bold)

    private let nickNameTextFieldClearButton = UIButton().then {
        $0.setImage(UIImage(systemName: "x.circle"), for: .normal)
        $0.tintColor = .textSubBlack
    }

    private let artistTrueButton = UIButton().then {
        $0.setTitle("네", for: .normal)
        $0.backgroundColor = .loginGray
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 10
    }

    private let artistFalseButton = UIButton().then {
        $0.setTitle("아니오", for: .normal)
        $0.backgroundColor = .loginGray
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 10
    }

    private let signUpButton = UIButton().then {
        $0.backgroundColor = .loginGray
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("완료", for: .normal)
        $0.layer.cornerRadius = 15
    }

    private let nickNameDivider = UIView().then {
        $0.backgroundColor = .loginGray
    }

    override func render() {
        nickNameField.delegate = self
        signUpButton.isEnabled = false
        nickNameTextFieldClearButton.isHidden = true
        nickNameCountLabel.isHidden = true

        view.addSubviews(profileImageView, cameraImage ,profileLabelFirst, profileLabelSecond, nickNameLabel, isArtistLabel, afterJoinLabel, nickNameField, nickNameCountLabel ,artistTrueButton, artistFalseButton, signUpButton, nickNameTextFieldClearButton, nickNameDivider)

        view.addSubviews(loadingView, spinnerView,loadingLabel)


        artistTrueButton.addTarget(self, action: #selector(didTapArtistTrueButton), for: .touchUpInside)
        artistFalseButton.addTarget(self, action: #selector(didTapArtistFalseButton), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        nickNameTextFieldClearButton.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)

        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }

        cameraImage.snp.makeConstraints {
            $0.center.equalTo(profileImageView.snp.center)
            $0.width.equalTo(50)
            $0.height.equalTo(40)
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
            $0.trailing.equalToSuperview().inset(100)
        }

        nickNameCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(nickNameField.snp.centerY)
            $0.leading.equalTo(nickNameField.snp.trailing).offset(-10)
        }

        nickNameTextFieldClearButton.snp.makeConstraints {
            $0.centerY.equalTo(nickNameField.snp.centerY)
            $0.leading.equalTo(nickNameField.snp.trailing).offset(40)
            $0.trailing.equalToSuperview().inset(30)
        }

        nickNameDivider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(nickNameField.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        isArtistLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        afterJoinLabel.snp.makeConstraints {
            $0.top.equalTo(isArtistLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        artistTrueButton.snp.makeConstraints {
            $0.top.equalTo(afterJoinLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(view.snp.centerX).inset(25)
        }

        artistFalseButton.snp.makeConstraints {
            $0.top.equalTo(afterJoinLabel.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalTo(view.snp.centerX).offset(10)
        }

        signUpButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }

        loadingView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.leading.trailing.equalToSuperview()
        }

        spinnerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        loadingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.spinnerView.snp.bottom).offset(35)
        }
    }

    @objc private func selectButtonTouched(_ recognizer: UITapGestureRecognizer) {
        self.present(imagePicker, animated: true)
    }

    @objc private func didTapArtistTrueButton() {
        artistTrueButton.backgroundColor = .mainPink
        artistTrueButton.setTitleColor(.white, for: .normal)
        artistFalseButton.backgroundColor = .loginGray
        artistFalseButton.setTitleColor(.black, for: .normal)

        if isNickNameWrite && !nickNameField.text!.isEmpty {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .mainPink
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .loginGray
        }

        isTapArtistButton = true
    }

    @objc private func didTapArtistFalseButton() {
        artistTrueButton.backgroundColor = .loginGray
        artistTrueButton.setTitleColor(.black, for: .normal)
        artistFalseButton.backgroundColor = .mainPink
        artistFalseButton.setTitleColor(.white, for: .normal)

        if isNickNameWrite && !nickNameField.text!.isEmpty {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .mainPink
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .loginGray
        }

        isTapArtistButton = true
    }
    //TODO: profileImage가 없을 경우 이미지 값을 SFSymbol에서 받으려고 하는데 그 값조차 옵셔널 값으로 인식함 그래서 일단 강제언래핑 해놓음
    @objc private func didTapSignUpButton() {
        let viewController = TabbarViewController()
        //애플 로그인을 통해 로그인을 할 경우 LoginProfileVC에 들어왔을 때 이미 로그인이 되어있어 creatNewAccount를 할 필요가 없으며,
        //storeUserInformation을 하기 위해 이메일 값을 파이어베이스에서 이메일 값을 가져온다.
        if isSignUpEmail {
            Task { [weak self] in
                self?.openLoadingView()
                await FirebaseManager.shared.createNewAccount(email: authEmail, password: authPassword)
                await FirebaseManager.shared.storeUserInformation(email: authEmail,
                                                                  name: nickNameField.text ?? "",
                                                                  profileImage: profileImageView.image ?? ImageLiteral.defaultProfile )
                await CurrentUserDataManager.shared.saveUserDefault()
                self?.hideLoadingView()
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        } else {
            let fireBaseUser = Auth.auth().currentUser
            Task { [weak self] in
                self?.openLoadingView()
                guard let fireBaseUser = fireBaseUser else { return }
                await FirebaseManager.shared.storeUserInformation(email: fireBaseUser.email ?? "",
                                                                  name: nickNameField.text ?? "",
                                                                  profileImage: profileImageView.image ?? ImageLiteral.defaultProfile )
                await CurrentUserDataManager.shared.saveUserDefault()
                self?.hideLoadingView()
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @objc private func didTapClearButton() {
        self.nickNameField.text = ""
        self.nickNameCountLabel.isHidden = true

        if isTapArtistButton {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .loginGray
        }
    }

    // MARK: - changing loading view status action
    private func openLoadingView() {
        self.loadingView.isHidden = false
        self.spinnerView.startAnimating()
        self.loadingLabel.isHidden = false
    }

    private func hideLoadingView() {
        self.loadingView.isHidden = true
        self.spinnerView.stopAnimating()
        self.loadingLabel.isHidden = true
    }
}

extension LoginProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    //8글자를 입력하면 백스페이스를 포함한 어떠한 입력도 입력되지 않아 예외처리로 지우기는 가능하게 하는 코드입니다.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }

        guard nickNameField.text?.count ?? 0 < 8 else { return false }
        return true
    }

    override func textFieldDidBeginEditing(_ textField: UITextField) {
        nickNameTextFieldClearButton.isHidden = false
    }


    func textFieldDidChangeSelection(_ textField: UITextField) {

        nickNameCountLabel.isHidden = nickNameField.text?.count == 0 ? true : false

        nickNameCountLabel.text = "(\(nickNameField.text?.count ?? 0)/8)"

        isNickNameWrite = nickNameField.text!.isEmpty ? false : true

        nickNameTextFieldClearButton.isHidden = nickNameField.text!.isEmpty ? true : false

        signUpButton.isEnabled = nickNameField.text!.isEmpty ? false : true

        signUpButton.backgroundColor = (!nickNameField.text!.isEmpty && isTapArtistButton) ? .mainPink : .loginGray
    }
    override func textFieldDidEndEditing(_ textField: UITextField) {
        if !nickNameField.text!.isEmpty {
            isNickNameWrite = true
            nickNameTextFieldClearButton.isHidden = true

            signUpButton.isEnabled = isTapArtistButton ? true : false
            signUpButton.backgroundColor = isTapArtistButton ? .mainPink : .loginGray

        }

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var newImage : UIImage? = nil // update 할 이미지
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage    // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage        // 원본 이미지가 있을 경우
        }
        self.profileImageView.image = newImage
        self.cameraImage.isHidden = true
        dismiss(animated: true, completion: nil)
    }
}
