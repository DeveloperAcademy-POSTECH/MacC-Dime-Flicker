//
//  ProfileTableViewCell.swift
//  Flicker
//
//  Created by Taehwan Kim on 2022/11/04.
//
//
import UIKit

final class ProfileTableViewCell: UITableViewCell {
    private let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
    
    private var cellTextLabel = UILabel().then {
        $0.text = "12321312"
        $0.font = .preferredFont(forTextStyle: .body, weight: .regular)
        $0.textColor = .textMainBlack
    }

    var cellSpacing: CGFloat = 0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        render()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func render() {
        contentView.addSubviews(cellTextLabel)
        contentView.backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 20
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: cellSpacing, right: 0))
        
        cellTextLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
    }
    
    func setupCellData(_ text: String, spacing: Int) {
        self.cellTextLabel.text = text
        self.cellSpacing = CGFloat(spacing)
    }
}

// MARK: - 프리뷰를 위한 세팅
//#if DEBUG
//import SwiftUI
//extension UIView {
//    private struct ViewRepresentable: UIViewRepresentable {
//        let uiview: UIView
//        func updateUIView(_ uiView: UIViewType, context: Context) {
//        }
//        func makeUIView(context: Context) -> some UIView {
//            return uiview
//        }
//    }
//    func getPreview() -> some View {
//        ViewRepresentable(uiview: self)
//    }
//}
//
//struct ProfileTableViewCell_Previews: PreviewProvider {
//    static var previews: some View{
//        ProfileTableViewCell().getPreview()
//            .previewLayout(.fixed(width: 300, height: 50))
//    }
//}
//#endif
