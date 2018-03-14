//
//  RecentPhotosViewController.swift
//  SousChef
//
//  Created by Jonathan Long on 3/13/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

private extension UICollectionView {
	func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
		let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
		return allLayoutAttributes.map { $0.indexPath }
	}
}

class RecentPhotosViewController: UICollectionViewController {

	var fetchResult: PHFetchResult<PHAsset>!
	var assetCollection: PHAssetCollection!
	
	fileprivate let imageManager = PHCachingImageManager()
	fileprivate var thumbnailSize = CGSize.zero
	fileprivate var previousPreheatRect = CGRect.zero
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let allPhotosOptions = PHFetchOptions()
		allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
		fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
		
		collectionView?.register(PhotoGridViewCell.self, forCellWithReuseIdentifier: PhotoGridViewCell.identifier)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		updateItemSize()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		updateItemSize()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateCachedAssets()
	}
	
	private func updateItemSize() {
		
		let viewWidth = view.bounds.size.width
		
		let desiredItemWidth: CGFloat = 100
		let columns: CGFloat = max(floor(viewWidth / desiredItemWidth), 4)
		let padding: CGFloat = SousChefStyling.smallestMargin
		let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
		let itemSize = CGSize(width: itemWidth, height: itemWidth)
		
		if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
			layout.itemSize = itemSize
			layout.minimumInteritemSpacing = padding
			layout.minimumLineSpacing = padding
		}
		
		// Determine the size of the thumbnails to request from the PHCachingImageManager
		let scale = UIScreen.main.scale
		thumbnailSize = CGSize(width: itemSize.width * scale, height: itemSize.height * scale)
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return fetchResult.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let asset = fetchResult.object(at: indexPath.item)
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGridViewCell.identifier, for: indexPath) as! PhotoGridViewCell
		
		// Request an image for the asset from the PHCachingImageManager.
		cell.representedAssetIdentifier = asset.localIdentifier
		imageManager.requestImage(for: asset, targetSize: CGSize.zero, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
			// The cell may have been recycled by the time this handler gets called;
			// set the cell's thumbnail image only if it's still showing the same asset.
			if cell.representedAssetIdentifier == asset.localIdentifier && image != nil {
				cell.thumbnailImage = image
			}
		})
		
		return cell
	}
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		updateCachedAssets()
	}
	
	fileprivate func resetCachedAssets() {
		imageManager.stopCachingImagesForAllAssets()
		previousPreheatRect = .zero
	}
	
	fileprivate func updateCachedAssets() {
		// Update only if the view is visible.
		guard isViewLoaded && view.window != nil else { return }
		
		// The preheat window is twice the height of the visible rect.
		let visibleRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
		let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
		
		// Update only if the visible area is significantly different from the last preheated area.
		let delta = abs(preheatRect.midY - previousPreheatRect.midY)
		guard delta > view.bounds.height / 3 else { return }
		
		// Compute the assets to start caching and to stop caching.
		let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
		let addedAssets = addedRects
			.flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
			.map { indexPath in fetchResult.object(at: indexPath.item) }
		let removedAssets = removedRects
			.flatMap { rect in collectionView!.indexPathsForElements(in: rect) }
			.map { indexPath in fetchResult.object(at: indexPath.item) }
		
		// Update the assets the PHCachingImageManager is caching.
		imageManager.startCachingImages(for: addedAssets,
										targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
		imageManager.stopCachingImages(for: removedAssets,
									   targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
		
		// Store the preheat rect to compare against in the future.
		previousPreheatRect = preheatRect
	}
	
	fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
		if old.intersects(new) {
			var added = [CGRect]()
			if new.maxY > old.maxY {
				added += [CGRect(x: new.origin.x, y: old.maxY,
								 width: new.width, height: new.maxY - old.maxY)]
			}
			if old.minY > new.minY {
				added += [CGRect(x: new.origin.x, y: new.minY,
								 width: new.width, height: old.minY - new.minY)]
			}
			var removed = [CGRect]()
			if new.maxY < old.maxY {
				removed += [CGRect(x: new.origin.x, y: new.maxY,
								   width: new.width, height: old.maxY - new.maxY)]
			}
			if old.minY < new.minY {
				removed += [CGRect(x: new.origin.x, y: old.minY,
								   width: new.width, height: new.minY - old.minY)]
			}
			return (added, removed)
		} else {
			return ([new], [old])
		}
	}
}

class PhotoGridViewCell: UICollectionViewCell {
	static let identifier = "PhotoGridViewCellIdentifier"
	
	var representedAssetIdentifier = ""
	var imageView = UIImageView()
	
	var thumbnailImage: UIImage! {
		didSet {
			imageView.image = thumbnailImage
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		thumbnailImage = nil
	}
	
	func commonInit() {
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		contentView.clipsToBounds = true
		
		contentView.addSubview(imageView)
		
		NSLayoutConstraint.activate(NSLayoutConstraint.constraintsPinningEdges(of: imageView, toEdgesOf: contentView))
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
}
