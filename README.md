# BubbleShot

Minimal iOS screenshot harness for the LUIYo bubble-pack editor.

The app IS the editor page: `AppDelegate` sets `BubblePackEditorViewController`
as the window's root view controller, with `onExport` as a no-op. The editor
sources (`BubblePack/` + `Engine/ZipWriter.swift`) are copied verbatim from
the LUIYo app's Build 78 staging tree, including the user's batch-import
fix (direct-slot placement + unrecognized list).

The UI test target captures 4 screenshots as keep-always attachments:
initial view, chat area, expanded other-bubbles section, night state.

Run on a macOS runner via the `BubbleShot` workflow (workflow file is
created in the GitHub web UI; it is not committed here because the API
token lacks workflow scope). The workflow boots an iPhone simulator,
runs `xcodebuild test`, exports the `.xcresult` attachments, and uploads
them as the `bubble-screenshots` artifact.
