import UIKit

/// Screenshot harness: the bubble-pack editor seated as the 气泡包 tab of a
/// plain UITabBarController (首页 / 气泡包 / 规则 / 我的), exactly like the
/// LUIYo shell seats it — so screenshots also prove the tab bar stays fixed
/// at the bottom while the editor scrolls. No SceneDelegate, no storyboard.
/// Launch argument "placeSample" pre-places one sample image into the first
/// text bubble (receiver-top, "左上") so the placed-image state can be shot
/// without a photo library.
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private func placeholder(_ text: String) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBackground
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
        ])
        return vc
    }

    private func sampleImage() -> UIImage {
        let size = CGSize(width: 240, height: 240)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            UIColor(red: 0.58, green: 0.93, blue: 0.41, alpha: 1).setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            UIColor.white.setFill()
            ctx.cgContext.fillEllipse(in: CGRect(x: 60, y: 60, width: 120, height: 120))
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let editor = BubblePackEditorViewController()
        editor.onExport = { _ in }

        let tabs = UITabBarController()
        let home = placeholder("首页（占位）")
        home.tabBarItem = UITabBarItem(title: "首页", image: UIImage(systemName: "house"), tag: 0)
        editor.tabBarItem = UITabBarItem(title: "气泡包", image: UIImage(systemName: "bubble.left.and.bubble.right"), tag: 1)
        let rules = placeholder("规则（占位）")
        rules.tabBarItem = UITabBarItem(title: "规则", image: UIImage(systemName: "list.bullet.rectangle"), tag: 2)
        let mine = placeholder("我的（占位）")
        mine.tabBarItem = UITabBarItem(title: "我的", image: UIImage(systemName: "person.crop.circle"), tag: 3)
        tabs.viewControllers = [home, editor, rules, mine]
        tabs.selectedIndex = 1

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = tabs
        window.makeKeyAndVisible()
        self.window = window

        if CommandLine.arguments.contains("placeSample") {
            DispatchQueue.main.async {
                editor.importImages(["左上@3x.png": self.sampleImage()])
            }
        }
        return true
    }
}
