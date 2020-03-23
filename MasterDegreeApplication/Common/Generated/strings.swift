// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Common {
    /// Enter password
    internal static let password = L10n.tr("Localizable", "Common.password")
    /// Enter username
    internal static let username = L10n.tr("Localizable", "Common.username")
  }

  internal enum SignInViewController {
    /// Sign in
    internal static let signIn = L10n.tr("Localizable", "SignInViewController.signIn")
    /// Don't have account? Sign up!
    internal static let signUp = L10n.tr("Localizable", "SignInViewController.signUp")
    /// Welcome
    internal static let title = L10n.tr("Localizable", "SignInViewController.title")
  }

  internal enum SignUpViewController {
    /// Retype password
    internal static let retypePassword = L10n.tr("Localizable", "SignUpViewController.retypePassword")
    /// Register
    internal static let signUp = L10n.tr("Localizable", "SignUpViewController.signUp")
    /// Create account
    internal static let title = L10n.tr("Localizable", "SignUpViewController.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
