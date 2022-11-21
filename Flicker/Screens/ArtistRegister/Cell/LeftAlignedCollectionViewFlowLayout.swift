//
//  LeftAlignedCollectionViewFlowLayout.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/01.
//

import UIKit

    // MARK: (Tag List View 를 위한) UICollectionViewCell을 최대한 왼쪽 정력시켜주는 flowLayout
final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 오버라이드 메소드를 따로 받아놓습니다.
        let attributes = super.layoutAttributesForElements(in: rect)
        // contentView 의 left (leading) 의 여백
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0 // cell 라인의 y값의 default 값
        attributes?.forEach{ layoutAttribute in
            // cell 이라면? (UICollectionViewCell 이라면? 을 뜻하는게 아닐까?)
            if layoutAttribute.representedElementCategory == .cell {
                // 한 cell 의 y 값이 이전 cell 들이 들어갔던 line 의 y 값 보다 크다면, 디폴트 값을 -1 을 줬기 때문에 처음은 무조건 발동이고, x 는 left 에서 시작.
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }
                // cell 의 x좌표에 leftMargin 값을 적용해주고
                layoutAttribute.frame.origin.x = leftMargin
                // cell 의 다음 값만큼 cellWidth += minimumInteritemSpacing 을 더해줌
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                // cell 의 위치값과 maxY 변수값 중 최대값 넣기 (라인 y 축 값 업데이트)
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        return attributes
    }
}
