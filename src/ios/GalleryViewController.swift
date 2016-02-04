//
//  GalleryViewController.swift
//  gallery
//
//  Created by James Hunter on 27/10/2015.
//
//

import UIKit

private let reuseIdentifier = "PhotoCell"

class GalleryViewController: UICollectionViewController {
    
    var closeCallback: (() -> Void)?
    var deleteCallback: ((Int) -> Void)?
    var initialIndex: Int?
    var images = [MPImage]()
    
    private let oneMSDelay = dispatch_time(DISPATCH_TIME_NOW, 1 * Int64(NSEC_PER_MSEC))

    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpView()
        setUpNavbar()
        setUpToolbar()
        addDismissGestureRecogniser()
    }
    
    override func viewWillAppear(animated: Bool) {
        addVisualEffectBG()
        showInitialPage()
    }
    
    private func setUpView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        self.collectionView!.pagingEnabled = true
        self.collectionView!.collectionViewLayout = flowLayout
        
        self.navigationController!.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController!.hidesBarsOnTap = true
    }

    private func addVisualEffectBG() {
        let visualEffect = UIBlurEffect(style: .Dark)
        let visualEffectView = UIVisualEffectView(effect: visualEffect)
        visualEffectView.frame = self.view.frame
        self.view.insertSubview(visualEffectView, atIndex: 0)
    }
    
    private func addPlainBG() {
        let plainView = UIView(frame: self.view.bounds)
        plainView.backgroundColor = UIColor(white: 0, alpha: 0.75)
        self.view.insertSubview(plainView, atIndex: 0)
    }
    
    private func setUpNavbar() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "actionClicked:")
        shareButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = shareButton
        let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "doneClicked:")
        doneButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = doneButton
    }
    
    private func setUpToolbar() {
        let leftSpacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let rightSpacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let captionLabel = UILabel(frame: CGRect(x: 0, y: 11, width: self.view.frame.width, height: 21))
        captionLabel.font = UIFont.systemFontOfSize(14.0)
        captionLabel.backgroundColor = UIColor.clearColor()
        captionLabel.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        captionLabel.text = "Caption"
        captionLabel.textAlignment = .Center
        let caption = UIBarButtonItem(customView: captionLabel)
        self.toolbarItems = [leftSpacer, caption, rightSpacer]
    }
    
    private func addDismissGestureRecogniser() {
        let swipeRecogniser = UISwipeGestureRecognizer(target: self, action: "swiped:")
        swipeRecogniser.direction = .Down
        self.view.addGestureRecognizer(swipeRecogniser)
    }
    
    private func showInitialPage() {
        let index = initialIndex ?? 0
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: false)
        setTextForIndex(index)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return self.navigationController!.navigationBarHidden
    }
    
    // MARK: - Gesture Handlers

    func swiped(sender: UIGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: closeCallback)
    }
    
    // MARK: Button Handlers
    
    func doneClicked(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: closeCallback)
    }
    
    func actionClicked(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "Save to Camera Roll", style: .Default, handler: saveActivePhoto))
        if canDeleteCurrentCell() {
            alertController.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: deleteActivePhoto))
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func canDeleteCurrentCell() -> Bool {
        guard let visibleCell = currentCell(),
            let image = visibleCell.image
            else { return false }
        return image.canDelete
    }
    
    func saveActivePhoto(action: UIAlertAction) {
        saveActivePhoto()
    }
    func saveActivePhoto() {
        if let visibleCell = currentCell(),
           let image = visibleCell.image?.view?.image {
            print(visibleCell)
            UIImageWriteToSavedPhotosAlbum(image, self, "savedImage:withError:andContextInfo:", nil)
        }
    }
    
    func savedImage(image: UIImage, withError error: NSError?, andContextInfo contextInfo: UnsafeMutablePointer<Void>) {
        var alertController: UIAlertController
        if let e = error {
            logErrorsFrom(e)
            alertController = alertWithTitle("Error", message: e.localizedDescription)
        } else {
            alertController = alertWithTitle("Success", message: "Photo saved!")
        }
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func deleteActivePhoto(action: UIAlertAction) {
        deleteActivePhoto()
    }
    func deleteActivePhoto() {
        if let visibleCell = currentCell(),
           let index = images.indexOf(visibleCell.image!),
           let callback = deleteCallback {
            dismissViewControllerAnimated(true) { callback(index) }
        }
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GalleryCell
        
        cell.image = images[indexPath.item]
        
        if !cell.initialised {
            cell.initialised = true
            runAfter(oneMSDelay) { [unowned self] in cell.image = self.images[indexPath.item] }
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        runAfter(oneMSDelay) { [unowned self] in
            if let visibleCell = self.currentCell(),
               let activeImage = visibleCell.image,
               let index = self.images.indexOf(activeImage) {
                self.setTextForIndex(index)
            }
        }
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.view.bounds.size
    }
    
    // MARK: - Utilities
    
    private func setTextForIndex(index: Int) {
        self.navigationItem.title = "\(index + 1) of \(images.count)"
        
        if  let caption = self.toolbarItems?[1],
            let label = caption.customView as? UILabel {
                label.text = images[index].caption
        }
    }
    
    private func alertWithTitle(title: String, message: String) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .Alert)
    }
    
    private func logErrorsFrom(error: NSError) {
        print(error.localizedDescription)
        print(error.localizedFailureReason)
        print(error.localizedRecoveryOptions)
        print(error.localizedRecoverySuggestion)
    }
    
    private func runAfter(delay: dispatch_time_t, codeBlock: () -> ()) {
        dispatch_after(delay, dispatch_get_main_queue()) { codeBlock() }
    }
    
    private func currentCell() -> GalleryCell? {
        return self.collectionView!.visibleCells().first as? GalleryCell
    }
}
