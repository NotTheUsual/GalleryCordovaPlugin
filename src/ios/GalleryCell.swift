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
    @IBOutlet weak var myScrollView: UIScrollView! {
        didSet {
            myScrollView.addSubview(imageView)
            myScrollView.contentSize = self.frame.size
            myScrollView.delegate = self
            myScrollView.maximumZoomScale = 1.0
            myScrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

            let doubleTabRecogniser = UITapGestureRecognizer(target: self, action: "imageDoubleTapped")
            doubleTabRecogniser.numberOfTapsRequired = 2
            myScrollView.addGestureRecognizer(doubleTabRecogniser)

            if image != nil {
                updateImage()
            }
        }
    }
    
    // MARK: - View Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        myScrollView.zoomScale = 1.0
        myScrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    // MARK: View Setup
    
    private func resetScrollViewSize() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = myScrollView.bounds.size
        
        let widthScale  = scrollViewSize.width  / (imageViewSize.width + 6.0)
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        let minZoom = min(widthScale, heightScale, 0.999)
        myScrollView.minimumZoomScale = minZoom
        myScrollView.zoomScale = minZoom
        
        setImageCentredIn(myScrollView)
    }
    
    private func initializeImage(image: MPImage) {
        imageView.removeFromSuperview()
        spinner.startAnimating()
        spinner.hidden = false
        imageView = UIImageView()
        imageView.downloadImageFromLink(image.src)
        imageView.sizeToFit()
        
        myScrollView.minimumZoomScale = 1.0
        myScrollView.maximumZoomScale = 1.0
        myScrollView.zoomScale = 1.0
        
        setImageCentredIn(myScrollView)
        
        myScrollView.addSubview(imageView)
        myScrollView.setNeedsDisplay()
        self.image!.view = imageView
    }
    
    func imageDoubleTapped() {
        if myScrollView.zoomScale == myScrollView.maximumZoomScale {
            myScrollView.setZoomScale(myScrollView.minimumZoomScale, animated: true)
        } else {
            myScrollView.setZoomScale(myScrollView.maximumZoomScale, animated: true)
        }
    }

    private func updateImage() {
        imageView.sizeToFit()
        resetScrollViewSize()
        myScrollView.addSubview(imageView)
        myScrollView.setNeedsDisplay()
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
                        cell.myScrollView.setNeedsDisplay()
                        cell.spinner.stopAnimating()
                        cell.spinner.hidden = true
                    }
                }
            }
        }.resume()
    }
}
