//
//  ViewController.swift
//  testBLE_esp32
//
//  Created by HiroakiSaito on 2022/06/15.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    @IBOutlet weak var counterLabel:UILabel!

    let kUARTServiceUUID_1 = "4fafc201-1fb5-459e-8fcc-c5c9c331914b" // サービス
    let kRXCharacteristicUUID_1 = "beb5483e-36e1-4688-b7f5-ea07361b26a8" // ペリフェラルからの受信用
// ２台目
    let kUARTServiceUUID_2 = "4fafc201-1fb5-459e-8fcc-c5c9c331914a" // サービス
    let kRXCharacteristicUUID_2 = "beb5483e-36e1-4688-b7f5-ea07361b26a7" // ペリフェラルからの受信用

    var centralManager: CBCentralManager!
    var peripheral_1: CBPeripheral!
    var peripheral_2: CBPeripheral!
    var serviceUUID_1 : CBUUID!
    var serviceUUID_2 : CBUUID!
    var kRXCBCharacteristic_1: CBCharacteristic?
    var kRXCBCharacteristic_2: CBCharacteristic?
    var charcteristicUUIDs: [CBUUID]!


    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        print("setup...")

        centralManager = CBCentralManager()
        centralManager.delegate = self as CBCentralManagerDelegate

        serviceUUID_1 = CBUUID(string: kUARTServiceUUID_1)
        serviceUUID_2 = CBUUID(string: kUARTServiceUUID_2)
        charcteristicUUIDs = [CBUUID(string: kRXCharacteristicUUID_1),
                              CBUUID(string: kRXCharacteristicUUID_2)]
    }

    @IBAction private func connectionAction(_ sender: Any) {
        setup()
    }

}

//MARK : - CBCentralManagerDelegate
extension ViewController: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("CentralManager didUpdateState")
        print(central.state)

        switch central.state {

            //電源ONを待って、スキャンする
        case CBManagerState.poweredOn:
            let services: [CBUUID] = [serviceUUID_1, serviceUUID_2]
            centralManager?.scanForPeripherals(withServices: services,
                                               options: nil)
            print("poweredOn")
            print("スキャン中")
        default:
            break
        }
    }

    /// ペリフェラルを発見すると呼ばれる
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        print("発見")
        print("発見内容は")
        print(peripheral)

        self.peripheral_1 = peripheral
        self.peripheral_2 = peripheral
        // cenrtralManagerをストップ
//        centralManager?.stopScan()
//        print("スキャンストップ")

        //接続開始
        print(self.peripheral_1)
        print(self.peripheral_2)

        central.connect(peripheral, options: nil)
        print("接続開始")
        print("  - centralManager didDiscover")
    }

    /// 接続されると呼ばれる
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {

        print("接続されました")
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID_1, serviceUUID_2])
        print("  - centralManager didConnect")
    }

    /// 切断されると呼ばれる？
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("接続が解消されました")
        print(#function)
        if error != nil {
            print(error.debugDescription)
            setup() // ペアリングのリトライ
            return
        }
    }
}

//MARK : - CBPeripheralDelegate
extension ViewController: CBPeripheralDelegate {

    /// サービス発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverServices error: Error?) {
        print("サービス発見")

        if error != nil {
            print(error.debugDescription)
            return
        }
        print(peripheral.services)
        print(peripheral.services?.first)

        //キャリアクタリスティク探索開始
        if let service = peripheral.services?.first {
            print("Searching characteristic...")
            peripheral.discoverCharacteristics(charcteristicUUIDs,
                                               for: service)
            print("キャリアクタリスティク検出")
        }
    }

    /// キャリアクタリスティク発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service: CBService, error: Error?) {

        print("キャリアクタリスティク検出確認!!　デリゲートの通知")
        print(service.description)

        if error != nil {
            print(error.debugDescription)
            return
        }

        print("service.characteristics.count: \(service.characteristics!.count)")
        // 指定したUUIDと同じものになるまで，For文で回している
        for characteristics in service.characteristics! {
            if(characteristics.uuid == CBUUID(string: kRXCharacteristicUUID_1)) {
                self.kRXCBCharacteristic_1 = characteristics
                print("kTXCBCharacteristic_1 が照合できたのでデータ受信に入る")
            } else if(characteristics.uuid == CBUUID(string: kRXCharacteristicUUID_2)) {
                self.kRXCBCharacteristic_2 = characteristics
                print("kTXCBCharacteristic_2 が照合できたのでデータ受信に入る")
            }
        }


        if(self.kRXCBCharacteristic_1 != nil) {
            print("kRXCBCharacteristic_1は")
            print(self.kRXCBCharacteristic_1)
            print("受信の関数呼び込んだよ")
            startReciving_1()
        }
        if(self.kRXCBCharacteristic_2 != nil) {
            print("kRXCBCharacteristic_2は")
            print(self.kRXCBCharacteristic_2)
            print("受信の関数呼び込んだよ")
            startReciving_2()
        }

    }

    private func startReciving_1() {
        print("関数が呼ばれたよ")
        print("1台目")
        guard let kRXCBCharacteristic_1 = kRXCBCharacteristic_1 else {
            return
        }
        peripheral_1.setNotifyValue(true, for: kRXCBCharacteristic_1)
        print("Start monitoring the message from Arduino.\n\n")
    }

    private func startReciving_2() {
        print("関数が呼ばれたよ")
        print("2台目")
        guard let kRXCBCharacteristic_2 = kRXCBCharacteristic_2 else {
            return
        }
        peripheral_2.setNotifyValue(true, for: kRXCBCharacteristic_2)
        print("Start monitoring the message from Arduino.\n\n")
    }

    /// データ送信時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print(#function)
        if error != nil {
            print(error.debugDescription)
            return
        }
    }

    // 値を取得した時にデリゲート通知
    // 今回CBDescriptorを使用していない
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
//        print("値取得したからデリゲートに通知します")
//        print(descriptor)
//        print(#function)
//    }

    /// データ更新時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("値が更新されているよ")
        print(#function)

        if error != nil {
            print(error.debugDescription)
            return
        }
        print(peripheral)
        print(characteristic)
        updateWithData(data: characteristic.value!)
    }

    private func updateWithData(data : Data) {
        print("ラベルの値を書き換えました")
        if let dataString = String(data: data, encoding: String.Encoding.utf8) {
            print(dataString)
            counterLabel.text = dataString
        }
    }


}
