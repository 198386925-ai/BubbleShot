import UIKit

/// Screenshot harness: the app IS the bubble-pack editor page.
/// No SceneDelegate, no storyboard, no other UI.
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let editor = BubblePackEditorViewController()
        editor.onExport = { _ in }
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = editor
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
