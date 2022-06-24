//
//  DefaultsFilter.swift
//  DefaultsEditor
//

public struct DefaultsFilter: Equatable {
	public let name: String
	public let filter: [String]

	public func shouldFilter(_ string: String) -> Bool {
		return !self.filter.contains(string)
	}

	public static let none = DefaultsFilter(name: "None", filter: [])
	public static let appleBuiltin = DefaultsFilter(
		name: "Apple Builtin",
		filter: [
			"AKLastEmailListRequestDateKey",
			"AKLastIDMSEnvironment",
			"AddingEmojiKeybordHandled",
			"AppleLanguages",
			"AppleLanguagesDidMigrate",
			"AppleLanguagesSchemaVersion",
			"AppleLocale",
			"ApplePasscodeKeyboards",
			"INNextFreshmintRefreshDateKey",
			"INNextHearbeatDate",
			"NSAllowsDefaultLineBreakStrategy",
			"NSInterfaceStyle",
			"NSLanguages",
			"PKKeychainVersionKey",
			"PKLogNotificationServiceResponsesKey",
			"com.apple.Animoji.StickerRecents.SplashVersion",
			"com.apple.content-rating.AppRating",
			"com.apple.content-rating.ExplicitBooksAllowed",
			"com.apple.content-rating.ExplicitMusicPodcastsAllowed",
			"com.apple.content-rating.MovieRating",
			"com.apple.content-rating.TVShowRating"
		])
}
