//
//  BLEConnectViewController.swift
//  testBLE_esp32
//
//  Created by HiroakiSaito on 2022/06/15.
//

import UIKit
import CoreBluetooth

class BLEConnectViewController: UIViewController {
    @IBOutlet private weak var receive1Label: UILabel!
    @IBOutlet private weak var receive2Label: UILabel!
    @IBOutlet private weak var inputUUIDTextField: UITextField!

    private let uuidKEY = "uuidKEY"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction private func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction private func connectButton(_ sender: Any) {
    }
    @IBAction private func disConnectButton(_ sender: Any) {
    }
}

extension BLEConnectViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("CentralManager didUpdateState")
    }
}

extension BLEConnectViewController: CBPeripheralDelegate {

}
