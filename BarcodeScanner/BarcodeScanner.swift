//
//  BarcodeScanner.swift
//  BarcodeScanner
//
//  Created by Hasan on 3/9/15.
//  Copyright (c) 2015 Hasan Adil. All rights reserved.
//

import UIKit
import AVFoundation

protocol BarcodeScannerDelegate {
    func didScanBarcode(barcode: String)
}

class BarcodeScanner: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    var previewLayer    : AVCaptureVideoPreviewLayer!
    let session         : AVCaptureSession = AVCaptureSession()
    let allowedBarcodes = [AVMetadataObjectTypeUPCECode,
        AVMetadataObjectTypeCode39Code,
        AVMetadataObjectTypeCode39Mod43Code,
        AVMetadataObjectTypeEAN13Code,
        AVMetadataObjectTypeEAN8Code,
        AVMetadataObjectTypeCode93Code,
        AVMetadataObjectTypeCode128Code,
        AVMetadataObjectTypePDF417Code,
        AVMetadataObjectTypeQRCode,
        AVMetadataObjectTypeAztecCode
    ]
    
    var delegate: BarcodeScannerDelegate?

    init(view: UIView, delegate: BarcodeScannerDelegate?) {
        super.init()
        self.delegate = delegate
        
        let camera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error : NSError? = nil
        let cameraInput : AVCaptureDeviceInput? = AVCaptureDeviceInput.deviceInputWithDevice(camera, error: &error) as? AVCaptureDeviceInput
        self.session.addInput(cameraInput)
        
        if error != nil || cameraInput == nil {
            //Awesome error handling :D
            println(error!.localizedDescription)
        }
        else {
            let cameraOutput = AVCaptureMetadataOutput()
            cameraOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            self.session.addOutput(cameraOutput)
            cameraOutput.metadataObjectTypes = cameraOutput.availableMetadataObjectTypes
            
            self.previewLayer = AVCaptureVideoPreviewLayer.layerWithSession(self.session) as AVCaptureVideoPreviewLayer
            self.previewLayer.frame = view.bounds
            self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            view.layer.addSublayer(self.previewLayer)
            
            self.session.startRunning()
        }
        
    }
    
    //MARK: AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for metadata in metadataObjects {
            for barcodeType in self.allowedBarcodes {
                if metadata.type == barcodeType {
                    let barcode = (metadata as AVMetadataMachineReadableCodeObject).stringValue as String?
                    self.session.stopRunning()
                    if self.delegate != nil {
                        self.delegate!.didScanBarcode(barcode!)
                    }
                    break
                }
            }
        }
    }
}
