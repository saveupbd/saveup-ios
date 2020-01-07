//
//  ZoomAndSnapFlowLayout.swift
//  Next Network Tools
//
//  Created by Asif on 3/20/19.
//  Copyright © 2019 Asif. All rights reserved.
//

import UIKit

//enum SJCenterFlowLayoutAnimation {
//    case rotation(sideItemAngle: CGFloat, sideItemAlpha: CGFloat, sideItemShift: CGFloat)
//    case scale(sideItemScale: CGFloat, sideItemAlpha: CGFloat, sideItemShift: CGFloat)
//}
class ZoomAndSnapFlowLayout: UICollectionViewFlowLayout {
    let activeDistance: CGFloat = 200
    let zoomFactor: CGFloat = 0.3
    
    override init() {
        super.init()
        
        scrollDirection = .horizontal
        minimumLineSpacing = 40
        itemSize = CGSize(width: 50, height: 150)

    }
    var animationMode = SJCenterFlowLayoutAnimation.scale(sideItemScale: 0.9, sideItemAlpha: 0.6, sideItemShift: 0.0)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { fatalError() }
        let verticalInsets = (collectionView.frame.height - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom - itemSize.height) / 2
        let horizontalInsets = (collectionView.frame.width - collectionView.adjustedContentInset.right - collectionView.adjustedContentInset.left - itemSize.width) / 2
        //sectionInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
        sectionInset = UIEdgeInsets(top: verticalInsets, left: 10, bottom: verticalInsets, right: 10)
        
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        let rectAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
        
        // Make the cells be zoomed when they reach the center of the screen
        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            let distance = visibleRect.midX - attributes.center.x
            let normalizedDistance = distance / activeDistance
            
            if distance.magnitude < activeDistance {
                let zoom = 1 + zoomFactor * (1 - normalizedDistance.magnitude)
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                attributes.zIndex = Int(zoom.rounded())
            }
        }
        return rectAttributes.map({ self.transformLayoutAttributes($0) })
    }
    func transformLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        
        let isHorizontal = (self.scrollDirection == .horizontal)
        
        let collectionCenter: CGFloat = isHorizontal ? collectionView.frame.size.width/2 : collectionView.frame.size.height/2
        
        let offset = isHorizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        
        let normalizedCenter = (isHorizontal ? attributes.center.x : attributes.center.y) - offset
        
        let maxDistance = (isHorizontal ? self.itemSize.width : self.itemSize.height) + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance)/maxDistance
        var sideItemShift: CGFloat = 0.0
        switch animationMode {
        case .rotation(let sideItemAngle, let sideItemAlpha, let shift):
            sideItemShift = shift
            let alpha = ratio * (1 - sideItemAlpha) + sideItemAlpha
            attributes.alpha = alpha
            var offsetX =  (collectionCenter + offset) - (normalizedCenter + offset)
            if offsetX < 0 {
                offsetX *= -1
            }
            if offsetX > 0 {
                let offsetPercentage = offsetX / (collectionCenter * 2)
                let rotation = (1 - offsetPercentage) - sideItemAngle
                attributes.transform = CGAffineTransform(rotationAngle: rotation)
            }
            break
        case .scale(let sideItemScale, let sideItemAlpha, let shift):
            sideItemShift = shift
            
            let alpha = ratio * (1 - sideItemAlpha) + sideItemAlpha
            let scale = ratio * (1 - sideItemScale) + sideItemScale
            attributes.alpha = alpha
            attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
            attributes.zIndex = Int(alpha * 10)
            
            break
        }
        let shift = (1 - ratio) * sideItemShift
        
        if isHorizontal {
            attributes.center.y = attributes.center.y + shift
        } else {
            attributes.center.x = attributes.center.x + shift
        }
        return attributes
        }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return .zero }
        
        // Add some snapping behaviour so that the zoomed cell is always centered
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2
        
        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offsetAdjustment.magnitude {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
        return true
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }

    
}
