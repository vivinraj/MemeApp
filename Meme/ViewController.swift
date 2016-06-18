//
//  ViewController.swift
//  Meme
//
//  Created by Vivin Raj on 04/06/16.
//  Copyright © 2016 Vivin Raj. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var topLabel: UITextField!
    @IBOutlet weak var bottomLabel: UITextField!
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    let memeTextAttributes = [
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)! ,
       NSStrokeColorAttributeName : UIColor.yellowColor(),
       NSForegroundColorAttributeName : UIColor.redColor(),
       // NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        NSStrokeWidthAttributeName : NSNumber(float: -4.0)
    ]
    
    
    override func viewWillAppear(animated: Bool) {
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        topLabel.defaultTextAttributes = memeTextAttributes
        bottomLabel.defaultTextAttributes = memeTextAttributes
      subscribeToKeyboardNotifications()
        subscribeToKeyboardNotifications1()
        
        //shareButton.enabled = false
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
       unsubscribeFromKeyboardNotifications()
        unsubscribeToKeyboardNotifications1()
    }
    
    
  func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
        
    }
    
    func subscribeToKeyboardNotifications1() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications1() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
        UIKeyboardWillShowNotification, object: nil)
    }
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:))    , name: UIKeyboardWillShowNotification, object: nil)
    }
       
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
          let userInfo = notification.userInfo
          let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
          return keyboardSize.CGRectValue().height
      }
    
   
    @IBAction func pickAnImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("success")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //ImagePickerView = UIImageView(frame:CGRect(x: 0,y: 0,width: 100,height: 70))
            print("success1")
            ImagePickerView.image = image
            print("success2")
            ImagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
            
            shareButton.enabled = true
            print("success4")
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        
        toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        toolbar.hidden = false
        
        return memedImage
    }
    
    struct Meme {
        var text: String
        var image: UIImage?
        var memedImage: UIImage
    }

    
    func save() {
        //Create the meme
        let meme = Meme( text: topLabel.text!, image:
            ImagePickerView.image, memedImage: generateMemedImage())
        
    }
    
    
    @IBAction func shareButton(sender: AnyObject) {
        //save()
         generateMemedImage()
         let image = generateMemedImage()
        //let image =
        let nextController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.presentViewController(nextController, animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    
}

