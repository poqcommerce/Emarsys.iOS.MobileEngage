Pod::Spec.new do |spec|
	spec.name                 = 'MobileEngageSDK'
	spec.version              = '0.9.0'
	spec.homepage             = 'https://help.emarsys.com/hc/en-us/articles/115002410625'
	spec.license              = 'Mozilla Public License 2.0'
    spec.author               = { 'Emarsys Technologies' => 'mobile-team@emarsys.com' }
	spec.summary              = 'Mobile Engage iOS SDK'
	spec.platform             = :ios, '9.0'
	spec.source               = { :git => 'https://github.com/emartech/ios-mobile-engage-sdk.git', :tag => spec.version }
	spec.source_files         = 'MobileEngage/**/*.{h,m}'
	spec.public_header_files  = [
		'MobileEngage/MobileEngage.h',
		'MobileEngage/MobileEngageStatusDelegate.h',
		'MobileEngage/MEConfigBuilder.h',
		'MobileEngage/MEConfig.h',
    'MobileEngage/Inbox/MEInbox.h',
    'MobileEngage/Inbox/MENotification.h',
    'MobileEngage/Inbox/MENotificationInboxStatus.h',
    'MobileEngage/RichNotification/MENotificationService.h',
    'MobileEngage/RichNotification/UNNotificationAttachment+MobileEngage.h'
	]
	spec.dependency 'CoreSDK'
	spec.libraries = 'z', 'c++'
end