//
//  ModalViewController.swift
//  gallery
//
//  Created by James Hunter on 23/10/2015.
//
//

import UIKit

class ModalViewController: UIViewController {
    
    var closeCallback: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeModal(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: closeCallback)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
