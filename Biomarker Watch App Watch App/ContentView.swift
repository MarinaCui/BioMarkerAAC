//
//  ContentView.swift
//  Biomarker Watch App Watch App
//
//  Created by 崔弘一铭 on 3/12/25.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}
//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var healthKitManager = HealthKitManager()
//
//    var body: some View {
//        VStack {
//            // Heart Rate Display
//            Text("Heart Rate")
//                .font(.headline)
//                .foregroundColor(.white)
//
//            Text("\(Int(healthKitManager.heartRate)) BPM")
//                .font(.system(size: 48, weight: .bold, design: .rounded))
//                .foregroundColor(.red)
//                .padding(.bottom, 10)
//
//            // Potential Emotion Display
//            Text("Potential Emotion:")
//                .font(.headline)
//                .foregroundColor(.white)
//
//            Text(emotionText(for: healthKitManager.heartRate))
//                .font(.system(size: 24, weight: .medium, design: .rounded))
//                .foregroundColor(.yellow)
//                .padding(.top, 5)
//        }
//        .padding()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.black)
//        .onAppear {
//            healthKitManager.requestAuthorization()
//        }
//    }
//
//    // Function to determine potential emotion based on heart rate
//    private func emotionText(for heartRate: Double) -> String {
//        switch heartRate {
//        case 0..<60:
//            return "😴 Resting"
//        case 60..<100:
//            return "😊 Normal"
//        case 100..<120:
//            return "😃 Active"
//        case 120..<140:
//            return "😅 Excited"
//        case 140..<160:
//            return "😬 Stressed"
//        default:
//            return "😨 High Stress"
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
import SwiftUI

struct ContentView: View {
    @StateObject private var healthKitManager = HealthKitManager()

    var body: some View {
        VStack {
            // 🩺 Heart Rate Display
            Text("Heart Rate")
                .font(.headline)
                .foregroundColor(.white)

            Text("\(Int(healthKitManager.heartRate)) BPM")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.red)
                .padding(.bottom, 5)

            // 😊 Emotion Indicator
            Text(emotionText(for: healthKitManager.heartRate))
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundColor(.yellow)

            // 🚀 Start Monitoring Button
            Button(action: {
                healthKitManager.requestAuthorization()
            }) {
                HStack {
                    Image(systemName: "heart.fill")
                    Text("Start Monitoring")
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }

    // 🎭 Function to determine potential emotion based on heart rate
    private func emotionText(for heartRate: Double) -> String {
        switch heartRate {
        case 0..<60:
            return "😴 Resting"
        case 60..<100:
            return "😊 Normal"
        case 100..<120:
            return "😃 Active"
        case 120..<140:
            return "😅 Excited"
        case 140..<160:
            return "😬 Stressed"
        default:
            return "😨 High Stress"
        }
    }
}

#Preview {
    ContentView()
}
//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var healthKitManager = HealthKitManager()
//
//    var body: some View {
//        VStack {
//            // 🩺 Heart Rate Display
//            Text("Heart Rate")
//                .font(.headline)
//                .foregroundColor(.white)
//
//            Text("\(Int(healthKitManager.heartRate)) BPM")
//                .font(.system(size: 36, weight: .bold, design: .rounded))
//                .foregroundColor(.red)
//                .padding(.bottom, 5)
//
//            // 😊 Emotion Indicator
//            Text(emotionText(for: healthKitManager.heartRate))
//                .font(.system(size: 18, weight: .medium, design: .rounded))
//                .foregroundColor(.yellow)
//        }
//        .padding()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.black)
//        .onAppear {
//            healthKitManager.requestAuthorization()
//        }
//    }
//
//    // 🎭 Function to determine potential emotion based on heart rate
//    private func emotionText(for heartRate: Double) -> String {
//        switch heartRate {
//        case 0..<60:
//            return "😴 Resting"
//        case 60..<100:
//            return "😊 Normal"
//        case 100..<120:
//            return "😃 Active"
//        case 120..<140:
//            return "😅 Excited"
//        case 140..<160:
//            return "😬 Stressed"
//        default:
//            return "😨 High Stress"
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
