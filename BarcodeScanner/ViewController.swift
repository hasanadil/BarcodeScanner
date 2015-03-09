//
//  ViewController.swift
//  BarcodeScanner
//
//  Created by Hasan on 3/8/15.
//  Copyright (c) 2015 Hasan Adil. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BarcodeScannerDelegate {
    
    @IBOutlet weak var cameraPreviewView: UIView?
    var barcodeScanner: BarcodeScanner?
    
    override func viewDidLayoutSubviews() {
        if self.barcodeScanner == nil {
            self.barcodeScanner = BarcodeScanner(view: self.view, delegate: self)
        }
    }
    
    //MARK: BarcodeScannerDelegate
    
    func didScanBarcode(barcode: String) {
        UIAlertView(title: "Scanned!", message: barcode, delegate: nil, cancelButtonTitle: "OK").show()
    }
}
