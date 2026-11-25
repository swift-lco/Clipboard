import Foundation

#if os(macOS)
    import AppKit
#elseif canImport(UIKit)
    import UIKit
#endif

public enum Clipboard {
    public static let system = Channel(
        storage: .system
    )

    public static func register(
        _ name: String
    ) -> Channel {
        return Channel(
            storage: .named(
                name
            )
        )
    }

    public struct Channel: Sendable {
        fileprivate let storage: Storage

        fileprivate init(
            storage: Storage
        ) {
            self.storage = storage
        }

        public func read() -> String? {
            #if os(macOS)
                pasteboard.string(
                    forType: .string
                )
            #elseif canImport(UIKit)
                pasteboard?.string
            #else
                nil
            #endif
        }

        @discardableResult
        public func write(
            _ text: String
        ) -> Bool {
            #if os(macOS)
                let pasteboard = pasteboard

                pasteboard.clearContents()

                return pasteboard.writeObjects(
                    [
                        text as NSString,
                    ]
                )
            #elseif canImport(UIKit)
                guard let pasteboard else {
                    return false
                }

                pasteboard.string = text
                return true
            #else
                return false
            #endif
        }

        #if os(macOS)
            private var pasteboard:
                NSPasteboard
            {
                switch storage {
                case .system:
                    NSPasteboard.general

                case .named(let name):
                    NSPasteboard(
                        name: NSPasteboard.Name(
                            name
                        )
                    )
                }
            }
        #elseif canImport(UIKit)
            private var pasteboard:
                UIPasteboard?
            {
                switch storage {
                case .system:
                    UIPasteboard.general

                case .named(let name):
                    UIPasteboard(
                        name: UIPasteboard.Name(
                            name
                        ),
                        create: true
                    )
                }
            }
        #endif
    }

    public typealias SystemClipboard = Channel

    fileprivate enum Storage: Sendable {
        case system
        case named(String)
    }
}
