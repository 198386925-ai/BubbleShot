import XCTest

/// Captures 4 screenshots of the bubble-pack editor, in order:
/// 1. initial view (header + toolbar + phone top)
/// 2. chat area (bubbles + tails) after swiping up
/// 3. other-bubbles section expanded
/// 4. night state after the theme toggle
final class BubbleShotUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    private func shot(_ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    /// Swipes until the element is hittable (it may start below the fold).
    private func scrollUntilHittable(_ element: XCUIElement, up: Bool, maxSwipes: Int = 12) -> Bool {
        for _ in 0..<maxSwipes {
            if element.isHittable { return true }
            if up { app.swipeUp() } else { app.swipeDown() }
            sleep(1)
        }
        return element.isHittable
    }

    func testCaptureEditorStates() {
        app.launch()
        sleep(2)

        // 1. Initial view: header + toolbar + phone top.
        shot("01-initial")

        // 2. Chat area: swipe up toward the phone mock.
        app.swipeUp()
        sleep(1)
        app.swipeUp()
        sleep(1)
        shot("02-chat")

        // 3. Expand the other-bubbles section (found by visible title).
        let other = app.buttons["红包 / 语音 / 卡片等其它气泡（32 个，可选项）"]
        XCTAssertTrue(scrollUntilHittable(other, up: true), "other-bubbles toggle never became hittable")
        other.tap()
        sleep(1)
        shot("03-other")

        // 4. Night state: back to the top, tap the theme toggle.
        let theme = app.buttons["深/浅配色"]
        XCTAssertTrue(scrollUntilHittable(theme, up: false), "theme toggle never became hittable")
        theme.tap()
        sleep(1)
        shot("04-night")
    }
}
