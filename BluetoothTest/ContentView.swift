//
//  ContentView.swift
//  BluetoothTest
//
//  Created by Emre Dogan on 18/09/2023.
//

import SwiftUI
import CoreBluetooth

class BluetoothViewModel: NSObject, ObservableObject {
	private var centeralManager: CBCentralManager?
	private var peripherals: [CBPeripheral] = []
	@Published var peripheralNames: [String] = []
	
	override init() {
		super.init()
		self.centeralManager = CBCentralManager(delegate: self, queue: .main)
	}
}

extension BluetoothViewModel: CBCentralManagerDelegate {
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		if central.state == .poweredOn {
			self.centeralManager?.scanForPeripherals(withServices: nil)
		}
	}
	
	func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
		if !peripherals.contains(peripheral) {
			self.peripherals.append(peripheral)
			self.peripheralNames.append(peripheral.name ?? "Unnamed Device")
		}
	}
}

struct ContentView: View {
	@ObservedObject private var viewModel: BluetoothViewModel = BluetoothViewModel()
    var body: some View {
		NavigationView {
			List(viewModel.peripheralNames, id: \.self) { name in
				Text(name)
			}
			.navigationTitle("Bluetooth List")
		}
    }
}

#Preview {
    ContentView()
}
