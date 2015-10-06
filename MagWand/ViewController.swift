//
//  ViewController.swift
//  MagWand
//
//  Created by Andrew Gentry on 6/8/15.
//
//  Copyright (c) 2015 Andrew Gentry. All rights reserved.
//


/*

To my inheritor:


If you are reading this, I can assume that you are the person (or team of persons) that intends to
turn the MagWand App into a reality. As a convinience to you, let me explain some of the code I have below and
speak to the scope of what this entire project will likely entail.

First off, when I wrote this code, it was our intention to use a "Red Bear Lab  BLE NANO"  to communicate
with the MagWand.  I've already imported the CoreBluetooth framework that I thought would be most appropriate
to accomplish such. For now, there is little more than a simple CBcentral manager set up to respond and print to
the console depending on the connection status.

If you are developing the MagWand with this code, Bluetooth work will comprise most of your time if you decide to utilize
my layout/design. Otherwise it might be better to just start from scratch.

Which brings me to my second point.  The front-end of this app is...well not the prettiest. Kinda looks odd, but at
the very least I do like the sliding transitions and the color fades.  In all honesty I think its a really cool concept
but could use some creative molding to look its best. Now, with that being said, I am sure that the bare bones
of the front-end stuff (which is mostly all I have here) is written cleanly and in a way that can be scaled quickly.

I have two functions called safteyBarPositionSwap and connectionBarPositionSwap to which you can pass in the saftey status
or the connection status respectivly and the code does the rest as far as transistions and colors go. They're pretty neat.

Like I said, you can either use my code as a starting place towards creating the MagWand App or you can decide
to start fresh and take a different approach. In either case I really don't care. This code isn't totally sentimental
to me and plus I have copies on my machine to admire anyhow. This was mearly an ambitious attempt at App development
that taught me quite a lot during my summer internship at Magswitch.

And so maybe it is for you too.

I hope that whoever does end up picking up this project has the same sort of motivation I felt when working on this.
Otherwise, it will almost certainly be done poorly. 


Mike, Tom, Sam, New Intern, Software Dev, whoever you are just make it a point to use this project as an opportunity to
do something creative and moreover bad-ass. Inspire somebody. Trust me, it's so worth it.



Rock on,


> andrew gentry

*/


import UIKit
import CoreBluetooth


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    
    /*
    ///////////// Variables
    */
    
    //------Views-
    
    let connectionStatusView = UIView()
    let safetyStatusView = UIView()
    let connectionLabel = UILabel()
    let safetyLabel = UILabel()
    
    //------Colors-
    
    let transparent: UIColor = UIColor(red: 0.25, green: 0.3, blue: 0.2, alpha: 0.0)
    let blueTransparency: UIColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.15)
    let greenTransparency: UIColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.3)
    let redTransparency: UIColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.4)
    let amberTransparency: UIColor = UIColor(red: 1.0, green: 0.1, blue: 0.0, alpha: 0.3)
    
    //------Arrays-
    let toolArray = ["AR15","AR20","AR30","PLAY20x4","PLAY50x2","PLAY50x3","PLAY50x4","PLAY70x2","PLAY70x3","PLAY70x4","E-Drive 50mm", "E-Drive 30mm", "SF600"]
    let valueArray = ["24", "23","22","21","20","19","18","17","16","15","14","13","12","11","10","9","8","7","6","5","4","3","2","1","3/4","1/2","1/4","1/8","1/10"]
    let unitArray = ["inch","gauge","cm", "mm"]
    
    
    //------Bluetooth-
    var centralManager : CBCentralManager!
    var sensorTagPeripheral : CBPeripheral!
    var discoveredPeripheral:CBPeripheral?
    
    //-------Status-
    var safetyStatus:String = ""
    var connectionStatus: String = ""
    
    
    
    /*
    ///////////// Outlets
    */
    
    
    
    /*
    ///////////// Buttons
    */
    // These are just test buttons that should be removed at some point..
    // But can be used as a good starting point for BLE action control
    
    @IBAction func offButton(sender: AnyObject) {
        
        connectionStatus = "Disconnected"
        connectionBarPositionSwap(getConnectionStatus())
        
        
    }
    @IBAction func connectedButton(sender: AnyObject) {
        
        connectionStatus = "Connected"
        connectionBarPositionSwap(getConnectionStatus())
        
        fadeInView(safetyStatusView, duration: 0.8)
        fadeInView(safetyLabel, duration: 0.8)
        
    }
    @IBAction func scanButton(sender: AnyObject) {
        
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
        
        connectionStatus = "Scanning..."
        connectionBarPositionSwap(getConnectionStatus())
        
        
        
    }
    @IBAction func cautionButton(sender: AnyObject) {
        
        safetyStatus = "Caution"
        safetyBarPositionSwap(getSafetyBarStatus())
        
        
    }
    @IBAction func safeButton(sender: AnyObject) {
        
        safetyStatus = "Safe"
        safetyBarPositionSwap(getSafetyBarStatus())
        
    }
    @IBAction func unsafeButton(sender: AnyObject) {
        
        safetyStatus = "Unsafe"
        safetyBarPositionSwap(getSafetyBarStatus())
    }
    
    
    
    /*
    ///////////// Status
    */
    
    func getSafetyBarStatus()->String {
        
        return safetyStatus
        
    }
    func getConnectionStatus()->String{
        
        return connectionStatus
        
    }
    func updateConnectionStatusLabel(){
        
        connectionLabel.text = connectionStatus
    }
    
    func updateSafetyStatusLabel(){
        safetyLabel.text = safetyStatus
    }
    
    /*
    //////////// Transitions
    */
    
    func fadeOutView(viewToFade: UIView, duration:NSTimeInterval) {
        
        UIView.transitionWithView(viewToFade, duration: duration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {viewToFade.alpha = 0.0}, completion: nil)
        
        
    }
    func fadeInView(viewToFade: UIView, duration:NSTimeInterval) {
        
        UIView.transitionWithView(viewToFade, duration: duration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {viewToFade.alpha = 1.0}, completion: nil)
        
    }
    func safetyBarPositionSwap(safetyStatus:String) {
        
        println(safetyStatus)
        
        updateSafetyStatusLabel()
        
        
        switch safetyStatus {
            
        case "Unsafe":
            
            UIView.animateWithDuration(0.3, animations: {self.safetyStatusView.backgroundColor = self.redTransparency; self.safetyStatusView.frame = CGRect(x: 0, y: 430, width: 190, height: 50)})
            slideToPosition(safetyLabel, duration: 0.5, xPosition: 0, yPosition: 430)
            
        case "Caution":
            
            UIView.animateWithDuration(0.3, animations: {self.safetyStatusView.backgroundColor = self.amberTransparency; self.safetyStatusView.frame = CGRect(x: 0+95, y: 430, width: 190, height: 50)})
            slideToPosition(safetyLabel, duration: 0.5, xPosition: 85, yPosition: 430)
            
            
        case "Safe":
            
            UIView.animateWithDuration(0.3, animations: {self.safetyStatusView.backgroundColor = self.greenTransparency; self.safetyStatusView.frame = CGRect(x: 0+190, y: 430, width: 190, height: 50)})
            slideToPosition(safetyLabel, duration: 0.5, xPosition: 190, yPosition: 430)
            
        default:
            
            return
            
        }
        
    }
    
    func connectionBarPositionSwap(connection:String) {
        
        println(connection)
        
        updateConnectionStatusLabel()
        
        if connectionStatus == "Connected" {
            
            fadeToGreen(connectionStatusView, duration: 0.5)
            slideToPosition(connectionStatusView, duration: 0.5, xPosition: 190, yPosition: 380)
            
            slideToPosition(connectionLabel, duration: 0.5, xPosition: 190, yPosition: 380)
            
            
        }
            
        else {
            
            fadeOutView(safetyStatusView, duration: 0.8)
            fadeOutView(safetyLabel, duration: 0.8)
            
            fadeToGray(connectionStatusView, duration: 0.7)
            slideToPosition(connectionStatusView, duration: 0.5, xPosition: 0, yPosition: 380)
            
            slideToPosition(connectionLabel, duration: 0.5, xPosition: 0, yPosition: 380)
            
        }
    }
    
    
    func slideToPosition(viewToTransistion: UIView, duration: NSTimeInterval, xPosition: Int, yPosition: Int){
        UIView.animateWithDuration(0.3, animations: {viewToTransistion.frame = CGRect(x: xPosition, y: yPosition, width: 190, height: 50)})
    }
    
    func fadeToGreen(viewToTransistion: UIView, duration: NSTimeInterval){
        UIView.animateWithDuration(0.3, animations: {viewToTransistion.backgroundColor = self.greenTransparency})
    }
    
    func fadeToGray(viewToTransistion: UIView, duration: NSTimeInterval){
        UIView.animateWithDuration(0.3, animations: {viewToTransistion.backgroundColor = self.blueTransparency})
    }
    
    /*
    ///////////// Bluetooth
    */
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        
        switch centralManager.state {
            
        case .PoweredOff:
            println("Powered Off")
            connectionStatus = "Disconnected"
            updateConnectionStatusLabel()
            break
        case .PoweredOn:
            println("Powered On")
            connectionStatus = "Connected"
            updateConnectionStatusLabel()
            
            self.scanButton(self)
            break
        case .Resetting:
            println("Reseting")
            connectionStatus = "Resetting..."
            updateConnectionStatusLabel()
            break
        case .Unauthorized:
            println("Unauthorized")
            connectionStatus = "Unauthorized"
            updateConnectionStatusLabel()
            break
        case .Unknown:
            println("Unknown")
            connectionStatus = "Unkown"
            updateConnectionStatusLabel()
            break
        case .Unsupported:
            println("Unsupported")
            connectionStatus = "Unsupported"
            updateConnectionStatusLabel()
            break
            
        default:
            break
        }
        
    }
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        var discoveredPeripheral: CBPeripheral
        
    }
    
    /*
    ///////////// PickerView
    */
    
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
    
    
    /*
    ///////////////// event handling
    */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updateConnectionStatusLabel()
        
        connectionStatusView.backgroundColor = self.blueTransparency
        connectionStatusView.frame = CGRect(x: 0, y: 380, width: 190, height: 50)
        
        safetyStatusView.backgroundColor = self.redTransparency
        safetyStatusView.frame = CGRect(x: 0, y: 430, width: 190, height: 50)
        safetyStatusView.alpha = 0.0
        
        
        connectionLabel.textColor = UIColor.blackColor()
        connectionLabel.frame = CGRect(x: 0, y: 380, width: 190, height: 50)
        connectionLabel.text = connectionStatus
        connectionLabel.textAlignment = NSTextAlignment.Center
        
        safetyLabel.textColor = UIColor.blackColor()
        safetyLabel.frame = CGRect(x: 0, y: 430, width: 190, height: 50)
        safetyLabel.text = "Unsafe"
        safetyLabel.textAlignment = NSTextAlignment.Center
        safetyLabel.alpha = 0.0
        
        
        
        self.view.addSubview(connectionLabel)
        self.view.addSubview(safetyLabel)
        self.view.addSubview(safetyStatusView)
        self.view.addSubview(connectionStatusView)
        
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
