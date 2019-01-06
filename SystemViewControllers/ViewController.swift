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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        let alertController = UIAlertController(title: "Choose Messaging Option", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        if MFMailComposeViewController.canSendMail() {
            guard MFMailComposeViewController.canSendMail() else {return}
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            let mailComposerAction = UIAlertAction(title: "Compose email", style: .default, handler: {action in
                mailComposer.setToRecipients(["example@example.com"])
                mailComposer.setSubject("Look at this")
                mailComposer.setMessageBody("Hello. This is a sample message", isHTML: false)
                let imageData: NSData = UIImageJPEGRepresentation(self.imageView.image!, 1.0)! as NSData
                mailComposer.addAttachmentData(imageData as Data, mimeType: "jpeg", fileName: "image.jpeg")
                self.present(mailComposer, animated: true, completion: nil)})
            alertController.addAction(mailComposerAction)
        }
        
        if MFMessageComposeViewController.canSendText() {
            guard MFMessageComposeViewController.canSendText() else {return}
            
            let messageComposer = MFMessageComposeViewController()
            messageComposer.messageComposeDelegate = self
            let messageComposerAction = UIAlertAction(title: "Compose message", style: .default, handler: {action in
                messageComposer.recipients = ["0123456789"]
                messageComposer.body = ("Body of message")
                let imageData: NSData = UIImageJPEGRepresentation(self.imageView.image!, 1.0)! as NSData
                messageComposer.addAttachmentData(imageData as Data, typeIdentifier: "jpeg", filename: "image.jpeg")
                
                self.present(messageComposer, animated: true, completion: nil)})
            
            alertController.addAction(messageComposerAction)
        }
        
        alertController.addAction(cancelAction)
        alertController.popoverPresentationController?.sourceView = sender as? UIView
        
        present(alertController, animated: true, completion: nil)
        
     }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
    
}

