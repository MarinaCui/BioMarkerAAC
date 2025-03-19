//import HealthKit
//import WatchConnectivity
//import WatchKit
//import Foundation
//
//class HealthKitManager: NSObject, ObservableObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate, WCSessionDelegate {
//    private let healthStore = HKHealthStore()
//    private var session: HKWorkoutSession?
//    private var builder: HKLiveWorkoutBuilder?
//
//    @Published var heartRate: Double = 0.0
//
//    override init() {
//        super.init()
//        requestAuthorization()
//        setupWatchConnectivity()
//    }
//
//    // Request HealthKit Permissions
//    func requestAuthorization() {
//        guard HKHealthStore.isHealthDataAvailable() else { return }
//
//        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
//        let typesToRead: Set = [heartRateType]
//
//        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
//            if success {
//                print("✅ HealthKit permission granted on Watch")
//                self.startWorkout()
//            } else {
//                print("❌ HealthKit permission failed: \(String(describing: error?.localizedDescription))")
//            }
//        }
//    }
//
//    // Start a Live Workout Session to Continuously Read Heart Rate
//    func startWorkout() {
//        let config = HKWorkoutConfiguration()
//        config.activityType = .other
//        config.locationType = .unknown
//
//        do {
//            session = try HKWorkoutSession(healthStore: healthStore, configuration: config)
//            builder = session?.associatedWorkoutBuilder()
//
//            session?.delegate = self
//            builder?.delegate = self
//
//            builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: config)
//
//            session?.startActivity(with: Date())
//            builder?.beginCollection(withStart: Date()) { _, _ in }
//        } catch {
//            print("❌ Failed to start workout session: \(error.localizedDescription)")
//        }
//    }
//
//    // Process Live Heart Rate Data
//    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
//        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
//
//        if collectedTypes.contains(heartRateType) {
//            let statistics = workoutBuilder.statistics(for: heartRateType)
//            let bpm = statistics?.mostRecentQuantity()?.doubleValue(for: HKUnit(from: "count/min")) ?? 0.0
//
//            DispatchQueue.main.async {
//                self.heartRate = bpm
//                print("❤️ Live Heart Rate: \(bpm) BPM")
//                self.sendHeartRateToPhone(bpm)
//            }
//        }
//    }
//
//    // Required method for HKLiveWorkoutBuilderDelegate
//    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
//        // Handle workout events if needed
//    }
//
//    // Fully Implement Required HKWorkoutSessionDelegate Methods
//    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
//        print("❌ Workout Session Failed: \(error.localizedDescription)")
//    }
//
//    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
//        switch toState {
//        case .running:
//            print("▶️ Workout Session Running")
//        case .ended:
//            print("⏹ Workout Session Ended")
//            session?.end()
//            builder?.endCollection(withEnd: Date()) { _, _ in }
//        default:
//            print("🔄 Workout Session State Changed: \(toState.rawValue)")
//        }
//    }
//
//    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
//        print("📌 Workout Event Generated: \(event)")
//    }
//
//    func workoutSession(_ workoutSession: HKWorkoutSession, didBeginActivityWith workoutConfiguration: HKWorkoutConfiguration, date: Date) {
//        print("🏃 Workout Activity Began at \(date)")
//    }
//
//    func workoutSession(_ workoutSession: HKWorkoutSession, didEndActivityWith workoutConfiguration: HKWorkoutConfiguration, date: Date) {
//        print("⏹ Workout Activity Ended at \(date)")
//    }
//
//    func workoutSession(_ workoutSession: HKWorkoutSession, didDisconnectFromRemoteDeviceWithError error: Error?) {
//        print("🔌 Disconnected from Remote Device: \(String(describing: error?.localizedDescription))")
//    }
//
//    func workoutSession(_ workoutSession: HKWorkoutSession, didReceiveDataFromRemoteWorkoutSession data: [Data]) {
//        print("📡 Received Data from Remote Workout Session: \(data.count) items")
//    }
//
//    // Send Heart Rate to iPhone in Real-Time
//    func sendHeartRateToPhone(_ heartRate: Double) {
//        if WCSession.default.isReachable {
//            let message = ["heartRate": heartRate]
//            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
//        }
//    }
//
//    // Fix WatchConnectivity Issues
//    func setupWatchConnectivity() {
//        if WCSession.isSupported() {
//            let session = WCSession.default
//            session.delegate = self
//            session.activate()
//        }
//    }
//
//    // WatchConnectivity Protocol Fixes
//    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
//        if let error = error {
//            print("❌ WCSession activation failed: \(error.localizedDescription)")
//        } else {
//            print("✅ WCSession activated")
//        }
//    }
//}

//chatgp
import HealthKit
import WatchConnectivity
import WatchKit
import Foundation

class HealthKitManager: NSObject, ObservableObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate, WCSessionDelegate {
    
    
    private let healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?
    private var observerQuery: HKObserverQuery?

    @Published var heartRate: Double = 0.0

    override init() {
        super.init()
        requestAuthorization()
        setupWatchConnectivity()
    }

    // Request HealthKit Permissions
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let typesToRead: Set = [heartRateType]

        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            if success {
                print("✅ HealthKit permission granted on Watch")
                self.startWorkout() // Start real-time tracking
                self.observeHeartRateSamples() // Start background tracking
            } else {
                print("❌ HealthKit permission failed: \(String(describing: error?.localizedDescription))")
            }
        }
    }

    // 🔴 Start a Live Workout Session for Continuous Heart Rate Monitoring
    func startWorkout() {
        let config = HKWorkoutConfiguration()
        config.activityType = .other
        config.locationType = .unknown

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: config)
            builder = session?.associatedWorkoutBuilder()

            session?.delegate = self
            builder?.delegate = self

            builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: config)

            session?.startActivity(with: Date())
            builder?.beginCollection(withStart: Date()) { _, _ in }
        } catch {
            print("❌ Failed to start workout session: \(error.localizedDescription)")
        }
    }

    // 🔴 Process Live Heart Rate Data
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }

        if collectedTypes.contains(heartRateType) {
            let statistics = workoutBuilder.statistics(for: heartRateType)
            let bpm = statistics?.mostRecentQuantity()?.doubleValue(for: HKUnit(from: "count/min")) ?? 0.0

            DispatchQueue.main.async {
                self.heartRate = bpm
                print("❤️ Live Heart Rate: \(bpm) BPM")
                self.sendHeartRateToPhone(bpm)
            }
        }
    }

    // 🔵 Observer Query for Passive Background Heart Rate Monitoring
    func observeHeartRateSamples() {
        guard let heartRateSampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }

        if let observerQuery = observerQuery {
            healthStore.stop(observerQuery)
        }

        observerQuery = HKObserverQuery(sampleType: heartRateSampleType, predicate: nil) { [unowned self] (_, _, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            self.fetchLatestHeartRateSample { (sample) in
                guard let sample = sample else { return }

                DispatchQueue.main.async {
                    let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                    let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                    print("📡 Background Heart Rate: \(heartRate) BPM")
                    self.heartRate = heartRate
                    //LocalNotificationHelper.fireHeartRate(heartRate)
                    self.sendHeartRateToPhone(heartRate)
                }
            }
        }

        healthStore.execute(observerQuery!)
        healthStore.enableBackgroundDelivery(for: heartRateSampleType, frequency: .immediate) { (success, error) in
            print("✅ Background delivery enabled: \(success)")
            if let error = error {
                print("❌ Background delivery error: \(error.localizedDescription)")
            }
        }
    }

    // 🔵 Fetch Latest Heart Rate Sample
    func fetchLatestHeartRateSample(completion: @escaping (HKQuantitySample?) -> Void) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(nil)
            return
        }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (_, results, error) in
            guard let sample = results?.first as? HKQuantitySample else {
                print("❌ No heart rate sample found: \(String(describing: error?.localizedDescription))")
                completion(nil)
                return
            }
            completion(sample)
        }

        healthStore.execute(query)
    }

    // 📡 Send Heart Rate to iPhone
    func sendHeartRateToPhone(_ heartRate: Double) {
        if WCSession.default.isReachable {
            let message = ["heartRate": heartRate]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
        }
    }

    // 📡 WatchConnectivity Setup
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
     //Required method for HKLiveWorkoutBuilderDelegate
        func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
            // Handle workout events if needed
        }
    // 📡 WatchConnectivity Delegate Methods
    func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("❌ WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("✅ WCSession activated")
        }
    }

    // 🔴 HKWorkoutSession Delegate Methods
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("❌ Workout Session Failed: \(error.localizedDescription)")
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running:
            print("▶️ Workout Session Running")
        case .ended:
            print("⏹ Workout Session Ended")
            session?.end()
            builder?.endCollection(withEnd: Date()) { _, _ in }
        default:
            print("🔄 Workout Session State Changed: \(toState.rawValue)")
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        print("📌 Workout Event Generated: \(event)")
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didBeginActivityWith workoutConfiguration: HKWorkoutConfiguration, date: Date) {
        print("🏃 Workout Activity Began at \(date)")
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didEndActivityWith workoutConfiguration: HKWorkoutConfiguration, date: Date) {
        print("⏹ Workout Activity Ended at \(date)")
    }
}

//eend chatgpt
//import HealthKit
//import WatchConnectivity
//import WatchKit
//import Foundation
//
//class HealthKitManager: NSObject, ObservableObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate, WCSessionDelegate {
//    private let healthStore = HKHealthStore()
//    private var session: HKWorkoutSession?
//    private var builder: HKLiveWorkoutBuilder?
//
//    @Published var heartRate: Double = 0.0
//
//    override init() {
//        super.init()
//        requestAuthorization()
//        setupWatchConnectivity()
//    }
//
//    // Request HealthKit Permissions
//    func requestAuthorization() {
//        guard HKHealthStore.isHealthDataAvailable() else { return }
//
//        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
//        let typesToRead: Set = [heartRateType]
//
//        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
//            if success {
//                print("✅ HealthKit permission granted on Watch")
//                self.startWorkout()
//            } else {
//                print("❌ HealthKit permission failed: \(String(describing: error?.localizedDescription))")
//            }
//        }
//    }
//
//    // Start a Live Workout Session to Continuously Read Heart Rate
//    func startWorkout() {
//        let config = HKWorkoutConfiguration()
//        config.activityType = .other
//        config.locationType = .unknown
//
//        do {
//            session = try HKWorkoutSession(healthStore: healthStore, configuration: config)
//            builder = session?.associatedWorkoutBuilder()
//
//            session?.delegate = self
//            builder?.delegate = self
//
//            builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: config)
//
//            session?.startActivity(with: Date())
//            builder?.beginCollection(withStart: Date()) { success, error in
//                if success {
//                    print("✅ Workout session and data collection started")
//                } else if let error = error {
//                    print("❌ Failed to start data collection: \(error.localizedDescription)")
//                }
//            }
//        } catch {
//            print("❌ Failed to start workout session: \(error.localizedDescription)")
//        }
//    }
//
//    // Process Live Heart Rate Data
//    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
//        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
//
//        if collectedTypes.contains(heartRateType) {
//            let statistics = workoutBuilder.statistics(for: heartRateType)
//            let bpm = statistics?.mostRecentQuantity()?.doubleValue(for: HKUnit(from: "count/min")) ?? 0.0
//
//            DispatchQueue.main.async {
//                self.heartRate = bpm
//                print("❤️ Live Heart Rate: \(bpm) BPM")
//                self.sendHeartRateToPhone(bpm)
//            }
//        }
//    }
//
//    // Required method for HKLiveWorkoutBuilderDelegate
//    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
//        // Handle workout events if needed
//    }
//
//    // Send Heart Rate to iPhone in Real-Time
//    func sendHeartRateToPhone(_ heartRate: Double) {
//        if WCSession.default.isReachable {
//            let message = ["heartRate": heartRate]
//            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
//        }
//    }
//
//    // Set up Watch Connectivity
//    func setupWatchConnectivity() {
//        if WCSession.isSupported() {
//            let session = WCSession.default
//            session.delegate = self
//            session.activate()
//        }
//    }
//
//    // MARK: - HKWorkoutSessionDelegate Methods
//
//    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
//        switch toState {
//        case .running:
//            print("▶️ Workout Session Running")
//        case .ended:
//            print("⏹ Workout Session Ended")
//            session?.end()
//            builder?.endCollection(withEnd: Date()) { _, _ in }
//        default:
//            print("🔄 Workout Session State Changed: \(toState.rawValue)")
//        }
//    }
//
//    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
//        print("❌ Workout Session Failed: \(error.localizedDescription)")
//    }
//
//    // MARK: - WCSessionDelegate Methods
//
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        if let error = error {
//            print("❌ WCSession activation failed: \(error.localizedDescription)")
//        } else {
//            print("✅ WCSession activated")
//        }
//    }
//}
