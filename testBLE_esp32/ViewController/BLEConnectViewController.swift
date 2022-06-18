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
    @IBOutlet private weak var inputServiceUUIDTextField: UITextField!
    @IBOutlet private weak var inputCharacteristicUUIDTextField: UITextField!

    private let uuidKEY = "uuidKEY"
    private var serviceUUIDList: [String] = []
    private var characteristicUUIDList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func validationUUIDRecord(_ serviceUUID: String, _ characteristicUUID: String) -> Bool {
        for serviceSTR in serviceUUIDList {
            if serviceUUID == serviceSTR{
                for characteristicSTR in characteristicUUIDList {
                    if characteristicUUID == characteristicSTR {
                        return true
                    }
                }
            }
        }
        return false
    }

    @IBAction private func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction private func connectButton(_ sender: Any) {
        guard let serviceUUID = inputServiceUUIDTextField.text, let characteristicUUID = inputCharacteristicUUIDTextField.text, !serviceUUID.isEmpty && !characteristicUUID.isEmpty
        else { return }
        let flag = validationUUIDRecord(
            serviceUUID,
            characteristicUUID
        )
        if !flag {
            serviceUUIDList.append(serviceUUID)
            characteristicUUIDList.append(characteristicUUID)
        }
        
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
