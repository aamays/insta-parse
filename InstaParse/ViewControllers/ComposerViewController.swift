//
//  ComposerViewController.swift
//  InstaParse
//
//  Created by Amay Singhal on 2/11/16.
//  Copyright © 2016 CodePath. All rights reserved.
//

import UIKit

class ComposerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!

    private var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Composer"
        imagePicker.delegate = self
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func postMedia(sender: UIButton) {
        print("Post media")
        
        UserMedia.postUserImage(imageView.image, withCaption: captionTextField.text) { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print(error.localizedDescription)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func imageViewTapped(sender: UITapGestureRecognizer) {
        print("Image view tapped")

        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary

        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func closeComposer(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
