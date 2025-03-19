//import HealthKit
//
//class HealthKitManager: ObservableObject {
//    private let healthStore = HKHealthStore()
//    @Published var heartRate: Double = 0.0
//
//    init() {
//        requestAuthorization()  // Request permissions on init
//    }
//
//    // ✅ Request HealthKit Permission
//    func requestAuthorization() {
//        print("📢 requestAuthorization() called") // Debugging
//
//        guard HKHealthStore.isHealthDataAvailable() else {
//            print("❌ HealthKit is not available on this device")
//            return
//        }
//
//        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
//        let typesToRead: Set = [heartRateType]
//
//        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
//            if success {
//                print("✅ HealthKit permission granted")
//                self.startHeartRateMonitoring()  // Start listening to heart rate
//            } else {
//                print("❌ HealthKit permission failed: \(String(describing: error?.localizedDescription))")
//            }
//        }
//    }
//
//    // ✅ Start listening to real-time heart rate
//    func startHeartRateMonitoring() {
//        print("📡 Start heart rate monitoring")
//
//        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
//        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) { (_, samples, _, _, _) in
//            self.processHeartRateSamples(samples)
//        }
//
//        query.updateHandler = { (_, samples, _, _, _) in
//            self.processHeartRateSamples(samples)
//        }
//
//        healthStore.execute(query)
//    }
//
//    // ✅ Process Heart Rate Data
//    private func processHeartRateSamples(_ samples: [HKSample]?) {
//        guard let quantitySamples = samples as? [HKQuantitySample] else { return }
//        if let lastSample = quantitySamples.last {
//            let newHeartRate = lastSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
//            print("❤️ New heart rate: \(newHeartRate) BPM")  // Debugging
//
//            DispatchQueue.main.async {
//                self.heartRate = newHeartRate
//            }
//        }
//    }
//}



//import HealthKit
//import AVFoundation
//
//class HealthKitManager: ObservableObject {
//    private let healthStore = HKHealthStore()
//    private let speechSynthesizer = AVSpeechSynthesizer()  // ✅ TTS System
//    @Published var heartRate: Double = 0.0
//
//    init() {
//        requestAuthorization()  // Request permissions on init
//    }
//
//    // ✅ Request HealthKit Permission
//    func requestAuthorization() {
//        print("📢 requestAuthorization() called") // Debugging
//
//        guard HKHealthStore.isHealthDataAvailable() else {
//            print("❌ HealthKit is not available on this device")
//            return
//        }
//
//        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
//        let typesToRead: Set = [heartRateType]
//
//        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
//            if success {
//                print("✅ HealthKit permission granted")
//                self.startHeartRateMonitoring()  // Start listening to heart rate
//            } else {
//                print("❌ HealthKit permission failed: \(String(describing: error?.localizedDescription))")
//            }
//        }
//    }
//
//    // ✅ Start listening to real-time heart rate
//    func startHeartRateMonitoring() {
//        print("📡 Start heart rate monitoring")
//
//        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
//        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) { (_, samples, _, _, _) in
//            self.processHeartRateSamples(samples)
//        }
//
//        query.updateHandler = { (_, samples, _, _, _) in
//            self.processHeartRateSamples(samples)
//        }
//
//        healthStore.execute(query)
//    }
//
//    // ✅ Process Heart Rate Data
//    private func processHeartRateSamples(_ samples: [HKSample]?) {
//        guard let quantitySamples = samples as? [HKQuantitySample] else { return }
//        if let lastSample = quantitySamples.last {
//            let newHeartRate = lastSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
//            print("❤️ New heart rate: \(newHeartRate) BPM")  // Debugging
//
//            DispatchQueue.main.async {
//                if self.heartRate != newHeartRate {  // ✅ Update only if changed
//                    self.heartRate = newHeartRate
//                }
//            }
//        }
//    }
//
//    // ✅ Text-to-Speech (TTS) Function
//    func speak(text: String) {
//        let speechUtterance = AVSpeechUtterance(string: text)
//        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//        speechUtterance.rate = 0.5  // Adjust speed of speech
//
//        speechSynthesizer.speak(speechUtterance)
//    }
//}


import HealthKit
import AVFoundation

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    private let speechSynthesizer = AVSpeechSynthesizer()
    @Published var heartRate: Double = 0.0

    init() {
        requestAuthorization()  // Request permissions on init
    }

    // ✅ Request HealthKit Permission
    func requestAuthorization() {
        print("📢 requestAuthorization() called") // Debugging

        guard HKHealthStore.isHealthDataAvailable() else {
            print("❌ HealthKit is not available on this device")
            return
        }

        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let typesToRead: Set = [heartRateType]

        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            if success {
                print("✅ HealthKit permission granted")
                self.startHeartRateMonitoring()  // Start listening to heart rate
            } else {
                print("❌ HealthKit permission failed: \(String(describing: error?.localizedDescription))")
            }
        }
    }

    // ✅ Start listening to real-time heart rate
    func startHeartRateMonitoring() {
        print("📡 Start heart rate monitoring")

        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) { (_, samples, _, _, _) in
            self.processHeartRateSamples(samples)
        }

        query.updateHandler = { (_, samples, _, _, _) in
            self.processHeartRateSamples(samples)
        }

        healthStore.execute(query)
    }

    // ✅ Process Heart Rate Data
    private func processHeartRateSamples(_ samples: [HKSample]?) {
        guard let quantitySamples = samples as? [HKQuantitySample] else { return }
        if let lastSample = quantitySamples.last {
            let newHeartRate = lastSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            print("❤️ New heart rate: \(newHeartRate) BPM")  // Debugging
            self.heartRate = newHeartRate //this upates the textview
            DispatchQueue.main.async {
                if self.heartRate != newHeartRate {  // ✅ Update only if changed
                    self.heartRate = newHeartRate
                }
            }
        }
    }

    // ✅ Text-to-Speech (TTS) Function with Heart Rate Influence
    func speak(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        // ✅ Modify tone based on heart rate
        if heartRate < 60 {
            // 🧘‍♂️ Low Heart Rate → Slow & Deep Voice (Relaxed)
            speechUtterance.rate = 0.4
            speechUtterance.pitchMultiplier = 0.8
        } else if heartRate >= 60 && heartRate <= 100 {
            // 🗣️ Normal Heart Rate → Neutral Speech
            speechUtterance.rate = 0.5
            speechUtterance.pitchMultiplier = 1.0
        } else {
            // 🚀 High Heart Rate → Fast & High-Pitched (Excited)
            speechUtterance.rate = 0.7
            speechUtterance.pitchMultiplier = 1.2
        }

        print("🎙️ Speaking: '\(text)' with Rate: \(speechUtterance.rate), Pitch: \(speechUtterance.pitchMultiplier)")
        speechSynthesizer.speak(speechUtterance)
    }
}

