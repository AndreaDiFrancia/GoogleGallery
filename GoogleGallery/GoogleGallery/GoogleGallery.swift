//
//  GoogleGallery.swift
//  GoogleGallery
//
//  Created by Andrea Di Francia on 01/06/2020.
//  Copyright © 2020 Andrea Di Francia. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class GoogleGallery: UIView {
    // IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var subDetailLabel: UILabel!
    @IBOutlet private weak var containerStack: UIStackView!
    @IBOutlet private weak var mainStack: UIStackView!
    
    // Private Variable
    lazy private var collectionGalleryView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize //CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width/2, height: 200), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: GalleryCell.cellIdentifier)
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return collectionView
    }()
    private var isScrollGalleryToLeft: Bool = false
    
    // Public Variable
    lazy public var images: [UIImage] = []
    lazy public var sizeItemGallery: CGSize = .zero
    lazy public var minimumItemLineSpacing: CGFloat = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        loadNib()
        
        mainStack.addArrangedSubview(collectionGalleryView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadNib()
        
        mainStack.addArrangedSubview(collectionGalleryView)
    }
    
    public func configure (title: String, detail: String, subDetail: String) {
        titleLabel.text = title
        detailLabel.text = detail
        subDetailLabel.text = subDetail
    }
    
    public func setCollection(with backgroundColor: UIColor) {
        collectionGalleryView.backgroundColor = backgroundColor
    }
    
    public func reloadData() {
        collectionGalleryView.reloadData()
    }
}

extension GoogleGallery: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCell.cellIdentifier, for: indexPath) as? GalleryCell
          
        cell?.configure(image: images[indexPath.item])
        return cell ?? UICollectionViewCell()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionGalleryView.contentOffset, size: self.collectionGalleryView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionGalleryView.indexPathForItem(at: visiblePoint) {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    if visibleIndexPath.row > 0 && self.isScrollGalleryToLeft == false {
                        self.containerStack.isHidden = true
                        self.isScrollGalleryToLeft = true
                    } else if visibleIndexPath.row < 2 && self.isScrollGalleryToLeft == true {
                        self.isScrollGalleryToLeft = false
                        self.containerStack.isHidden = false
                    }
                }
            }
        }
    }
}

extension GoogleGallery: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeItemGallery
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumItemLineSpacing
    }
}
