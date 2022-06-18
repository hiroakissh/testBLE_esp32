//
//  BLEConnectViewController.swift
//  testBLE_esp32
//
//  Created by HiroakiSaito on 2022/06/15.
//

import UIKit
import CoreBluetooth

class BLEConnectViewController: UIViewController {
    @IBOutlet weak var inputUUIDTextFeild: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension BLEConnectViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("CentralManager didUpdateState")
    }


}

extension BLEConnectViewController: CBPeripheralDelegate {

}
