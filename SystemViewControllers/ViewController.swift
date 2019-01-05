//
//  ViewController.swift
//  SystemViewControllers
//
//  Created by Seng Hwwa on 05/01/2019.
//  Copyright © 2019 senghwabeh. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func shareButtonTapped(_ sender: Any) {
        guard let image = imageView.image else {return}
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender as? UIView
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func safariButtonTapped(_ sender: Any) {
        if let url = URL(string: "http://www.apple.com") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {action in imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)})
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {action in imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)})
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.addAction(cancelAction)
        alertController.popoverPresentationController?.sourceView = sender as? UIView
        
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = selectedImage
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            print("Cannot send mail")
        }
        
        guard MFMailComposeViewController.canSendMail() else {return}
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        mailComposer.setToRecipients(["example@example.com"])
        mailComposer.setSubject("Look at this")
        mailComposer.setMessageBody("Hello. This is a sample message", isHTML: false)
        let imageData: NSData = UIImageJPEGRepresentation(imageView.image!, 1.0)! as NSData
        mailComposer.addAttachmentData(imageData as Data, mimeType: "jpeg", fileName: "image.jpeg")
        present(mailComposer, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
}

