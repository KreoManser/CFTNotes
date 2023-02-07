import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore  {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            StorageManager.shared.create(
                NSAttributedString(
                    string: "Привет, новый пользователь!\nДобро пожаловать в СFTNotes, тут ты можешь записать что-то важное для себя😸",
                    attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
                )
            )
        }
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        StorageManager.shared.saveContext()
    }
}
