//
//  CameraServices.swift
//  U_Owe_Me
//
//  Created by Anthony on 2019-12-21.
//  Copyright © 2019 Anthony. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraServices {
    
    var previewView: UIView!
    var captureImageView: UIImageView!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    init(_ previewView: UIView, _ captureImageView: UIImageView, _ captureSession: AVCaptureSession, _ stillImageOutput: AVCapturePhotoOutput, _ videoPreviewLayer: AVCaptureVideoPreviewLayer){
        self.previewView = previewView
        self.captureImageView = captureImageView
        self.captureSession = captureSession
        self.stillImageOutput = stillImageOutput
        self.videoPreviewLayer = videoPreviewLayer
        cameraInit()
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
    
}
