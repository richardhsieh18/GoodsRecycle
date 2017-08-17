//
//  WaterfallViewLayout.swift
//  GoodsRecycle
//
//  Created by chang on 2017/8/16.
//  Copyright © 2017年 chang. All rights reserved.
//

import UIKit

protocol WaterfallLayoutDelegate { //協定
    
    // 1 設定照片高度的方法
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth:CGFloat) -> CGFloat
    // 2 設定照片註解欄位的高度
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
    
}

class WaterfallAttributes : UICollectionViewLayoutAttributes {
    var photoHeight : CGFloat = 0.0
    
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! WaterfallAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
}

class WaterfallViewLayout: UICollectionViewLayout {
    //設個delegate變數符合自己設定的protocol
    var delegate : WaterfallLayoutDelegate!
    //兩個Column
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    
    private var cache = [WaterfallAttributes]()
    
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        let insets  = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override func prepare() {
        if cache.isEmpty {
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth)
            }
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0)
            {
                let indexPath = IndexPath(item: item, section: 0)
                let width = columnWidth - cellPadding * 2
                //photo高度來自於符合 自定protocol 的 collectionview的 方法
                let photoHeight = delegate.collectionView(collectionView: collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: width)
                //註解欄位的高度來自於符合自定protocol的colletionview的 heightforAnnotation方法
                let annotationHeight = delegate.collectionView(collectionView: collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                //所以cell的高度就是這兩個相加加上cellPadding
                let height = cellPadding + photoHeight + annotationHeight + cellPadding
                //frame在collectionview的位置
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                //frame的加上inset
                print(frame)
                let frameInset = frame.insetBy(dx: cellPadding, dy: cellPadding)
                print(frameInset)
                
                let attributes = WaterfallAttributes(forCellWith: indexPath)
                attributes.photoHeight = photoHeight
                //frame設為計算過inset的frame
                attributes.frame = frameInset
                cache.append(attributes)
                //兩者取大值，設定contentsize的高度
                //contentHeight = max(contentHeight, frame.maxY)
                //應該是要搜尋後更新contentHeight，但目前沒弄到
                contentHeight = frame.maxY
                //yOffset值為原本的加上cell的高度
                yOffset[column] = yOffset[column] + height
                //column值加上1
                column = column >= (numberOfColumns - 1) ? 0 : column + 1
                
            }
        }
    }
    
    override var collectionViewContentSize: CGSize
    {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache{
            if attributes.frame.intersects(rect){
                print("1111111\(rect)")
                print("5555555555\(attributes)")
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override class var layoutAttributesClass : AnyClass {
        return WaterfallAttributes.self
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
    }
    
}
