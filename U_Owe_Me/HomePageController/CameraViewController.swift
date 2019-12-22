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

    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var captureImageView: UIImageView!
    
    @IBOutlet weak var takePhotoButton: UIButton!
    
    @IBOutlet weak var captureViewClose: UIButton!
    
    @IBOutlet weak var oweMe: UIButton!
    
    @IBOutlet weak var iOwe: UIButton!
    
    @IBOutlet weak var amountText: UITextField!
    
    @IBAction func OweMeClicked(_ sender: Any) {
        
    }
    
    @IBAction func IOweClicked(_ sender: Any) {
        
    }
    
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
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    private func openContacts(Sender:UIButton!){
        let newVC : HomeContactTableController = HomeContactTableController()
        self.present(newVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded camera view controller")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated : Bool){
        super.viewDidAppear(animated)
        cameraInit()
        view.bringSubviewToFront(captureImageView)
        view.bringSubviewToFront(takePhotoButton)
        view.bringSubviewToFront(captureViewClose)
        view.bringSubviewToFront(oweMe)
        view.bringSubviewToFront(iOwe)
        view.bringSubviewToFront(amountText)
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

}
