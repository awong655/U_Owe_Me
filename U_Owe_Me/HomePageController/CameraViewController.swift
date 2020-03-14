//
//  CameraViewController.swift
//  U_Owe_Me
//
//  Created by Anthony on 2019-12-21.
//  Copyright © 2019 Anthony. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // MARK: OUTLETS
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet var captureImageView: UIImageView!
    
    @IBOutlet weak var takePhotoButton: UIButton!
    
    @IBOutlet weak var captureViewClose: UIButton!
    
    @IBOutlet weak var oweMe: UIButton!
    
    @IBOutlet weak var iOwe: UIButton!
    
    @IBOutlet weak var amountText: UITextField!
    
    @IBAction func OweMeClicked(_ sender: Any) {
        //openContacts(Sender: sender as? UIButton)
       // self.view.bringSubviewToFront(self.contactCard.view)
        //self.handleTapGesture()
        expandContacts()
    }
    
    @IBAction func IOweClicked(_ sender: Any) {
        //openContacts(Sender: sender as? UIButton)
        //self.view.bringSubviewToFront(self.contactCard.view)
        //self.handleTapGesture()
        expandContacts()
    }
    
    // is there a more efficient way of handling the UI?
    @IBAction func didCaptureViewClose(_ sender: Any) {
        self.captureImageView.image = nil
        self.captureViewClose.isHidden = true
        self.oweMe.isHidden = true
        self.iOwe.isHidden = true
        self.amountText.isHidden = true
        self.takePhotoButton.isHidden = false
    }
    
    
    @IBAction func didTakePhoto(_ sender: Any) {
        self.takePhotoButton.isHidden = true
        self.captureViewClose.isHidden = false
        self.oweMe.isHidden = false
        self.iOwe.isHidden = false
        self.amountText.isHidden = false
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // MARK: CONSTRAINT OUTLETS
    
    @IBOutlet weak var preview_bottom: NSLayoutConstraint!
    @IBOutlet weak var preview_trailing: NSLayoutConstraint!
    @IBOutlet weak var preview_top: NSLayoutConstraint!
    @IBOutlet weak var preview_leading: NSLayoutConstraint!
    
    // MARK: INSTANCE PROPERTIES
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    // Sliding Card Implementation
    private var contactCard: HomeContactViewController!;
    //private var contactCard: UIViewController!
    private var cardHiddenConstraint: NSLayoutConstraint!
    private var cardVisibleConstraint: NSLayoutConstraint!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: FUNCTIONS
    private func openContacts(Sender:UIButton!){
        let newVC = storyboard?.instantiateViewController(withIdentifier: "ContactNav") as! UINavigationController
        if let tableVC = newVC.viewControllers.first as? HomeContactViewController{
            tableVC.currentImage = captureImageView.image
        }
        self.present(newVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.initSlidingContacts();
        print("loaded camera view controller")
        // Do any additional setup after loading the view.
    }
    
    private func initSlidingContacts(){
        guard let contactListStoryboard = self.storyboard else{
            return;
        }
        contactCard = contactListStoryboard.instantiateViewController(withIdentifier: "HomeContactViewController") as? HomeContactViewController
        //contactCard = contactListStoryboard.instantiateViewController(withIdentifier: "RedViewController")
        addChild(contactCard);
        let contactCardView = contactCard.view!
        contactCardView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(contactCardView)
        
        // topAnchor = a view's top edge. .constraint will add a constraint
        cardHiddenConstraint = contactCardView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        cardVisibleConstraint = contactCardView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50)

        let cardViewControllerViewConstraints = [
            contactCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contactCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardHiddenConstraint!,
            contactCardView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ]
        NSLayoutConstraint.activate(cardViewControllerViewConstraints)
        
        contactCard.didMove(toParent: self)
        
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        //contactCard.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTapGesture() {
        let frameAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1) {
            if self.cardHiddenConstraint.isActive {
                self.cardHiddenConstraint.isActive = false
                self.cardVisibleConstraint.isActive = true
            } else {
                self.cardVisibleConstraint.isActive = false
                self.cardHiddenConstraint.isActive = true
            }
            self.view.layoutIfNeeded()
        }
        frameAnimator.startAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        cameraInit()
        
        // set frame here to avoid expanding camera view animation
        videoPreviewLayer?.frame = self.view.frame
        self.initSlidingContacts();
    }
    
    override func viewDidAppear(_ animated : Bool){
        super.viewDidAppear(animated)
        
        // is there a more efficient way to do this
        // I think CALayers may be the answer to this
        view.bringSubviewToFront(captureImageView)
        view.bringSubviewToFront(takePhotoButton)
        view.bringSubviewToFront(captureViewClose)
        view.bringSubviewToFront(oweMe)
        view.bringSubviewToFront(iOwe)
        view.bringSubviewToFront(amountText)
//        self.view.sendSubviewToBack(captureImageView)
//        self.view.sendSubviewToBack(previewView)
        
    }
    
    private func cameraInit(){
        
        // start camera session, camera quality
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        
        // Input device selection (default is back camera for AVMediaType.video)
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        // connect selected device with the camera session
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            // Attach output to the camera session
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
        
    }
    
    private func setupLivePreview(){
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else{ return }
        let image = UIImage(data: imageData)
        captureImageView.image = image
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    func expandContacts(){
        guard let cardContacts = storyboard?.instantiateViewController(withIdentifier: "HomeContactViewController") as? HomeContactViewController
        else{
            assertionFailure("No view controller ID ContactNav in storyboard")
            return
        }
        
        cardContacts.backingImage = view.makeShapshot()
                
        // presents modally
        present(cardContacts, animated: false)
        
    }

}
