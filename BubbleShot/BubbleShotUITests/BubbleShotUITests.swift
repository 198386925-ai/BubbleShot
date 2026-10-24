import XCTest

/// Captures 6 screenshots of the bubble-pack editor, in order:
/// 1. initial view (wrapped pill toolbar + phone top + tab bar)
/// 2. chat area (bubbles + tails) after swiping up
/// 3. other-bubbles section expanded (32 bubbles, category colors)
/// 4. night state after the theme toggle
/// 5. bottom of the COLLAPSED page (other-toggle + note + tab bar in one frame)
/// 6. placed-image state (fresh launch with a pre-placed sample image)
///
/// 06 is captured BEFORE the relaunch: post-relaunch scrolling to the toggle
/// never stuck (run 4's 06 duplicated 05's viewport), while first-launch
/// scrolling provably works (02/03). 05 goes last so nothing after it
/// depends on scrolling.
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
    private func scrollUntilHittable(_ element: XCUIElement, up: Bool, maxSwipes: Int = 16) -> Bool {
        for _ in 0..<maxSwipes {
            if element.isHittable { return true }
            if up { app.swipeUp() } else { app.swipeDown() }
            sleep(1)
        }
        return element.isHittable
    }

    private func selectBubbleTab() {
        let tab = app.tabBars.buttons["气泡包"]
        if tab.waitForExistence(timeout: 10) && !tab.isSelected {
            tab.tap()
            sleep(1)
        }
    }

    func testCaptureEditorStates() {
        app.launch()
        sleep(2)
        selectBubbleTab()

        // 1. Initial view: wrapped pill toolbar + phone top + tab bar.
        shot("01-initial")

        // 2. Chat area: bubbles + tails.
        app.swipeUp()
        sleep(1)
        app.swipeUp()
        sleep(1)
        shot("02-chat")

        // 3. Expand the other-bubbles section (found by visible title),
        // then scroll into it: the expanded cards sit BELOW the toggle,
        // shooting immediately would only show the chat viewport again.
        let other = app.buttons["红包 / 语音 / 卡片等其它气泡（32 个，可选项）"]
        XCTAssertTrue(scrollUntilHittable(other, up: true), "other-bubbles toggle never became hittable")
        other.tap()
        sleep(1)
        app.swipeUp()
        sleep(1)
        app.swipeUp()
        sleep(1)
        app.swipeUp()
        sleep(1)
        shot("03-other")

        // 4. Night state: back to the top, tap the theme toggle.
        let theme = app.buttons["深/浅配色"]
        XCTAssertTrue(scrollUntilHittable(theme, up: false), "theme toggle never became hittable")
        theme.tap()
        sleep(1)
        shot("04-night")

        // 5. Bottom of the COLLAPSED page, back in light mode: tap the theme
        // toggle again (viewport is already at the top), scroll to the
        // other-toggle, tap it to collapse the section, then shoot at once —
        // the toggle is on screen when tapped, so no post-collapse scrolling
        // is needed and the frame holds toggle + note + tab bar.
        XCTAssertTrue(scrollUntilHittable(theme, up: false), "theme toggle never became hittable again")
        theme.tap()
        sleep(1)
        XCTAssertTrue(scrollUntilHittable(other, up: true), "other-bubbles toggle never became hittable again")
        other.tap()
        sleep(1)
        shot("06-bottom")

        // 6. Placed-image state: relaunch with a pre-placed sample image.
        app.terminate()
        app.launchArguments = ["placeSample"]
        app.launch()
        sleep(3)
        selectBubbleTab()
        app.swipeUp()
        sleep(1)
        shot("05-placed")
    }
}
