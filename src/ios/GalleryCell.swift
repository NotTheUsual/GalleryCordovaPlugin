//
//  GalleryCell.swift
//  gallery
//
//  Created by James Hunter on 27/10/2015.
//
//

import UIKit

class GalleryCell: UICollectionViewCell, UIScrollViewDelegate {
    
    var initialised: Bool = false
    var image: MPImage? {
        didSet {
            guard let image = image else { return }
            if let uiImageView = image.view {
                imageView.removeFromSuperview()
                imageView = uiImageView
                 updateImage()
            } else {
                 initializeImage(image)
            }
        }
    }
    
    private var imageView = UIImageView()
    private static var scrollZoom: CGFloat?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.addSubview(imageView)
            scrollView.contentSize = self.frame.size
            scrollView.delegate = self
            scrollView.maximumZoomScale = 1.0
            scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            if image != nil {
                print("photo!")
                 updateImage()
            } else {
                print("no photo...")
            }
        }
    }
    
    // MARK: - View Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.zoomScale = 1.0
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    // MARK: View Setup
    
    private func resetScrollViewSize() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        
        let widthScale  = scrollViewSize.width  / (imageViewSize.width + 6.0)
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        let minZoom = min(widthScale, heightScale, 0.999)
        scrollView.minimumZoomScale = minZoom
        scrollView.zoomScale = minZoom
        
        setImageCentredIn(scrollView)
    }
    
    private func initializeImage(image: MPImage) {
        imageView.removeFromSuperview()
        spinner.startAnimating()
        spinner.hidden = false
        imageView = UIImageView()
        imageView.downloadImageFromLink(image.src)
        imageView.sizeToFit()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        
        setImageCentredIn(scrollView)
        
        scrollView.addSubview(imageView)
        scrollView.setNeedsDisplay()
        self.image!.view = imageView
    }
    
    private func updateImage() {
        imageView.sizeToFit()
        resetScrollViewSize()
        scrollView.addSubview(imageView)
        scrollView.setNeedsDisplay()
    }
    
    private func setImageCentredIn(scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize
        let scrollViewSize = scrollView.bounds.size
        let offsetX = max((scrollViewSize.width - contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollViewSize.height - contentSize.height) * 0.5, 0.0)
        
        imageView.center = CGPoint(x: contentSize.width * 0.5 + offsetX, y: contentSize.height * 0.5 + offsetY)
    }
    
    // MARK: - Scroll View Delegate
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        setImageCentredIn(scrollView)
    }
    
    // MARK: - Utilities
    
    private func hasCorrectImage(link: String) -> Bool {
        return image?.src == link
    }
}

private extension UIImageView {
    func downloadImageFromLink(link: String) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: link)!) {
            (data, response, error) in
            guard let data = data else { return }
            dispatch_async(dispatch_get_main_queue()) {
                self.image = UIImage(data: data)
                self.sizeToFit()
                if let cell = self.superview?.superview?.superview as? GalleryCell {
                    if cell.hasCorrectImage(link) {
                        cell.resetScrollViewSize()
                        cell.scrollView.setNeedsDisplay()
                        cell.spinner.stopAnimating()
                        cell.spinner.hidden = true
                    }
                }
            }
        }.resume()
    }
}
