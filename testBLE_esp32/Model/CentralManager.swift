//
//  CentralManager.swift
//  testBLE_esp32
//
//  Created by HiroakiSaito on 2022/06/20.
//

import Foundation
import CoreBluetooth

protocol ConnectPeripheralProtocol {
    var serviceUUIDString: String { get }
    func didConnectPeripheral(CBPeripheral: CBPeripheral!)
    func didDisconnectPeripheral()
    func didRestorePeripheral()
    func bluetoothBecomeAvailable()
    func bluetoothBecomeUnAvailable()
}

class CentralManager: NSObject, CBCentralManagerDelegate {

    var centralManager: CBCentralManager?

    init(centralManager: CBCentralManager) {
        self.centralManager = centralManager
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(centralManager?.state)
        switch central.state {
        case .poweredOn:
            print("poweredOn")
        case .poweredOff:
            print("poweredOff")
        case .unauthorized:
            print("unauthorized")
        case .unsupported:
            print("unsupported")
        case .resetting:
            print("resetting")
        case .unknown:
            print("unknown")
        default:
            print("default")
            break
        }
    }
}
