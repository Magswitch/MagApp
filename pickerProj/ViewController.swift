//
//  ViewController.swift
//  pickerProj
//
//  Created by a_dog on 6/8/15.
//  Copyright (c) 2015 a_dog. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    
                    ///////////////
    ///////////////// Variables  ////////////////////////////////
    
    
    let connectButtonView = UIView()
    
    var backgroundTransparencyDown: UIColor = UIColor(red: 0.25, green: 0.0, blue: 0.5, alpha: 0.05)
    var backgroundTransparencyUp: UIColor = UIColor(red: 0.25, green: 0.3, blue: 0.2, alpha: 0.0)
    var blueTransparency: UIColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.15)
    var greenTransparency: UIColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.3)
 
    let toolArray = ["PLAY20x4","PLAY20x6","PLAY40x2","E-Drive 50mm", "E-Drive 30mm", "SF600"]
    let valueArray = ["24", "22", "20","17","12","11","10","5","4","3","2","1","3/4","1/2","1/4","1/8","1/10"]
    let unitArray = ["Gauge", "cm", "mm", "in"]
    
    var connectionStatus: String = ""
    
    var centralManager : CBCentralManager!
    var sensorTagPeripheral : CBPeripheral!
    var discoveredPeripheral:CBPeripheral?
    
    
    
    
                     ///////////
    ///////////////// Outlets //////////////////////////////////////
    
 
    @IBOutlet weak var littleLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var connectedLabel: UILabel!
    
    
    func updateConnectionStatus(){
        
        connectionLabel.text = connectionStatus
    }
    
   
    
    @IBAction func refreshButtonRelease(sender: AnyObject) {
        
        littleLabel.text = "Unsafe"
        
        updateConnectionStatus()
        UIView.animateWithDuration(0.3, animations: {self.connectButtonView.backgroundColor = self.blueTransparency; self.connectButtonView.frame = CGRect(x: 0, y: 380, width: 200, height: 50)})
        
        UIView.transitionWithView(connectionLabel, duration: 1.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { self.connectionLabel.textColor = UIColor.blackColor()}, completion: nil)
         UIView.transitionWithView(connectedLabel, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { self.connectedLabel.textColor = self.backgroundTransparencyUp}, completion: nil)
        
         self.view.bringSubviewToFront(self.connectionLabel)
    }
    
    
    @IBAction func scanButton(sender: AnyObject) {
        littleLabel.text = "Safe "
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
        connectionStatus = "Scanning..."
        connectedLabel.text = "Okay"
        updateConnectionStatus()
        
        
        UIView.animateWithDuration(0.3, animations: {self.connectButtonView.backgroundColor = self.greenTransparency; self.connectButtonView.frame = CGRect(x: 0+180, y: 380, width: 200, height: 50)})
        
        UIView.transitionWithView(connectionLabel, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { self.connectionLabel.textColor = self.backgroundTransparencyUp}, completion: nil)
        UIView.transitionWithView(connectedLabel, duration: 1.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { self.connectedLabel.textColor = UIColor.blackColor()}, completion: nil)
        
    }
    
    
    
                   ///////////////////////
    /////////////// Bluetooth Management ////////////////////////////////////
    
    
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        
        switch centralManager.state {
            
        case .PoweredOff:
            println("Powered OFF")
            connectionStatus = "Powered Off"
            updateConnectionStatus()
            break
        case .PoweredOn:
            println("ON")
            connectionStatus = "Connected"
            updateConnectionStatus()
           
            self.scanButton(self)
            break
        case .Resetting:
            println("Reset")
            connectionStatus = "Resetting..."
            updateConnectionStatus()
            break
        case .Unauthorized:
            println("Unauthorized")
            connectionStatus = "Unauthorized"
            updateConnectionStatus()
            break
        case .Unknown:
            println("Unknown")
            connectionStatus = "Unkown"
            updateConnectionStatus()
            break
        case .Unsupported:
            println("Unsupported")
            connectionStatus = "Unsupported"
            updateConnectionStatus()
            break
            
        default:
            break
        }
        
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        var discoveredPeripheral: CBPeripheral
        
        
    }
    
                  ////////////////////////////
    /////////////// PickerView Functionality /////////////////////////////////
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }

    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        
        switch component {
        case 0:
            return 160
            
        case 1:
            return 75
            
        case 2:
            return 80
            
        default:
            return 100
            
            
        }
        
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return toolArray.count
            
        case 1:
            return valueArray.count
            
        case 2:
            return unitArray.count
            
        default:
            return valueArray.count
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        switch component {
        case 0:
            return toolArray[row]
            
        case 1:
            return valueArray[row]
            
        case 2:
            return unitArray[row]
            
        default:
            return valueArray[row]
        
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        connectButtonView.backgroundColor = self.blueTransparency
        connectButtonView.frame = CGRect(x: 0, y: 380, width: 200, height: 50)
        
        
        littleLabel.text = connectionStatus
        self.connectedLabel.text = ""
        
        self.view.addSubview(connectButtonView)
        
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
      
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

