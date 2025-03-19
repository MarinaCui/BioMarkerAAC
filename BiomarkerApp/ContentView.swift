//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var healthKitManager = HealthKitManager()
//    
//    var body: some View {
//        VStack {
//            Text("实时心率:")
//                .font(.headline)
//            
//            Text("\(Int(healthKitManager.heartRate)) BPM")
//                .font(.largeTitle)
//                .foregroundColor(.red)
//                .padding()
//            
//            Text("emotion: ")
//                .onAppear {
//                    print("🟢 ContentView Loaded") // Debugging
//                    healthKitManager.requestAuthorization()
//                }
//        }
//    }
//}


//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var healthKitManager = HealthKitManager()
//    @State private var userInput: String = ""  // ✅ Stores user input
//
//    var body: some View {
//        VStack {
//            // ✅ Heart Rate Display
//            Text("实时心率:")
//                .font(.headline)
//
//            Text("\(Int(healthKitManager.heartRate)) BPM")
//                .font(.largeTitle)
//                .foregroundColor(.red)
//                .padding()
//
//            // ✅ Text Input for Custom Speech
//            TextField("输入你想说的话...", text: $userInput)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//
//            // ✅ Speak Button
//            Button(action: {
//                if !userInput.isEmpty {
//                    healthKitManager.speak(text: userInput)  // 🎙️ Speak user input
//                }
//            }) {
//                Text("🔊 Speak")
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding()
//        }
//        .padding()
//        .onAppear {
//            print("🟢 ContentView Loaded")
//            healthKitManager.requestAuthorization()
//        }
//    }
//}

import SwiftUI

struct ContentView: View {
    @StateObject private var healthKitManager = HealthKitManager()
    @State private var userInput: String = ""  // ✅ Stores user input

    var body: some View {
        VStack {
            // ✅ Heart Rate Display
            Text("实时心率:")
                .font(.headline)

            Text("\(Int(healthKitManager.heartRate)) BPM")
                .font(.largeTitle)
                .foregroundColor(.red)
                .padding()

            // ✅ Text Input for Custom Speech
            TextField("输入你想说的话...", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // ✅ Speak Button
            Button(action: {
                if !userInput.isEmpty {
                    healthKitManager.speak(text: userInput)  // 🎙️ Speak user input
                }
            }) {
                Text("🔊 Speak")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .onAppear {
            print("🟢 ContentView Loaded")
            healthKitManager.requestAuthorization()
        }
    }
}
