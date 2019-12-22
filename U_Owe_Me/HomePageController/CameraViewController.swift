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
    
    @IBAction func didTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
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
    
//    private func cameraInit(){
//        let vc = UIImagePickerController()
//
//        // check if source type is available
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            vc.sourceType = .camera
//            vc.allowsEditing = true
//            vc.delegate = self
//            self.present(vc, animated: false, completion: nil)
//        }else{
//            print("Camera Not Available")
//        }
//
//        // for the image picker
//        let availableTypes = UIImagePickerController.availableMediaTypes(for: .camera)
//
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//// Conform to protocols required for opening the camera as well as the camera roll
//extension CameraViewController: UINavigationControllerDelegate{
////    // TODO: implement
////    func navigationController(_ navigationController: UINavigationController,
////                              willShow viewController: UIViewController,
////                              animated: Bool){
////
////    }
////
////    // TODO: implement
////    func navigationController(_ navigationController: UINavigationController,
////                              didShow viewController: UIViewController,
////                              animated: Bool){
////
////    }
////
////    // TODO: implement
////    func navigationController(_ navigationController: UINavigationController,
////                              animationControllerFor operation: UINavigationController.Operation,
////                              from fromVC: UIViewController,
////                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
////        return nil
////    }
////
////    // TODO: implement
////    func navigationController(_ navigationController: UINavigationController,
////                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?{
////        return nil
////    }
////
////    // TODO: implement
////    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation{
////        return navigationController
////    }
////
////    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask{
////        return navigationController
////    }
//}
//
//extension CameraViewController: UIImagePickerControllerDelegate{
//
//}
