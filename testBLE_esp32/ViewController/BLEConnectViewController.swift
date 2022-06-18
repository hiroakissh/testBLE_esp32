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

    var centralManager: CBCentralManager?

    private let uuidKEY = "uuidKEY"
    private var currentServiceUUID: CBUUID?
    private var currentCharacteristicUUID: CBCharacteristic?
    private var serviceUUIDList: [CBUUID] = []
    private var characteristicUUIDList: [CBUUID] = []
    private var characteristicUUIDs: [CBUUID]?
    private var peripheral: CBPeripheral?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func validationUUIDRecord(_ serviceUUID: CBUUID, _ characteristicUUID: CBUUID) -> Bool {
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

    private func setup(_ serviceUUID: CBUUID, _ characteristicUUID: CBUUID) {
        print("setup")

        centralManager = CBCentralManager()
        centralManager?.delegate = self

        currentServiceUUID = serviceUUID
        characteristicUUIDs = [characteristicUUID]

    }

    @IBAction private func backButton(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction private func connectButton(_ sender: Any) {
        guard let serviceUUIDString = inputServiceUUIDTextField.text, let characteristicUUIDString = inputCharacteristicUUIDTextField.text, !serviceUUIDString.isEmpty && !characteristicUUIDString.isEmpty
        else { return }
        let serviceUUID = CBUUID(string: serviceUUIDString)
        let characteristicUUID = CBUUID(string: characteristicUUIDString)
        let flag = validationUUIDRecord(
            serviceUUID,
            characteristicUUID
        )
        if !flag {
            serviceUUIDList.append(serviceUUID)
            characteristicUUIDList.append(characteristicUUID)
        }
        setup(serviceUUID, characteristicUUID)
    }

    @IBAction private func disConnectButton(_ sender: Any) {
    }
}

extension BLEConnectViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("CentralManager didUpdateState")
        switch central.state {
        case .poweredOn:
            print("poweredOn")
            centralManager?.scanForPeripherals(withServices: serviceUUIDList)
        case .poweredOff:
            print("poweredOff")
            centralManager?.stopScan()
        case .resetting:
            print("resetting")
        case .unauthorized:
            print("unauthorized")
        case .unsupported:
            print("unsupported")
        case .unknown:
            print("unknown")
        default:
            break
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        self.peripheral = peripheral

        central.connect(peripheral)
        print("接続開始")
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("接続完了")
        peripheral.delegate = self
        peripheral.discoverServices(serviceUUIDList)
    }

    // 接続が切断された時に呼び出し
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("接続切断")
        print(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("接続できませんでした")
        print(peripheral)
    }
}

extension BLEConnectViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error != nil else {
            print(error.debugDescription)
            return
        }
        print(peripheral.services)
        guard let peripheralServices = peripheral.services else {
            return
        }
        for service in peripheralServices {
            print("Characteristicsの探索")
            print(service)
            peripheral.discoverCharacteristics(characteristicUUIDs,
                                               for: service)
        }
    }
}
