//
// Copyright (c) 2018 Emarsys. All rights reserved.
//
#import "MEUserNotificationDelegate.h"
#import "MobileEngageInternal.h"
#import <UserNotifications/UNNotificationResponse.h>
#import <UserNotifications/UNNotification.h>
#import <UserNotifications/UNNotificationContent.h>
#import <UserNotifications/UNNotificationRequest.h>
#import "MEExperimental.h"

@interface MEUserNotificationDelegate ()

@property(nonatomic, strong) UIApplication *application;
@property(nonatomic, strong) MobileEngageInternal *mobileEngage;

@end

@implementation MEUserNotificationDelegate

@synthesize delegate = _delegate;
@synthesize eventHandler = _eventHandler;

- (instancetype)initWithApplication:(UIApplication *)application
               mobileEngageInternal:(MobileEngageInternal *)mobileEngage {
    NSParameterAssert(application);
    NSParameterAssert(mobileEngage);
    if (self = [super init]) {
        _application = application;
        _mobileEngage = mobileEngage;
    }
    return self;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    if (self.delegate) {
        [self.delegate userNotificationCenter:center
                      willPresentNotification:notification
                        withCompletionHandler:completionHandler];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler {
    if (self.delegate) {
        [self.delegate userNotificationCenter:center
               didReceiveNotificationResponse:response
                        withCompletionHandler:completionHandler];
    }
    [self.mobileEngage trackMessageOpenWithUserInfo:response.notification.request.content.userInfo];
    NSDictionary *action = [self actionFromResponse:response];
    if (action) {
        if ([MEExperimental isFeatureEnabled:INAPP_MESSAGING] || [MEExperimental isFeatureEnabled:USER_CENTRIC_INBOX]) {
            [self.mobileEngage trackInternalCustomEvent:@"richNotification:actionClicked"
                                        eventAttributes:@{
                                                @"button_id": action[@"id"],
                                                @"title": action[@"title"]
                                        }];
        }
        NSString *type = action[@"type"];
        if ([type isEqualToString:@"MEAppEvent"]) {
            [self.eventHandler handleEvent:action[@"name"]
                                   payload:action[@"payload"]];
        } else if ([type isEqualToString:@"OpenExternalUrl"]) {
            [self.application openURL:[NSURL URLWithString:action[@"url"]]
                              options:@{}
                    completionHandler:nil];
        } else if ([type isEqualToString:@"MECustomEvent"]) {
            [self.mobileEngage trackCustomEvent:action[@"name"]
                                eventAttributes:action[@"payload"]];
        }
    }
    completionHandler();
}

- (NSDictionary *)actionFromResponse:(UNNotificationResponse *)response {
    NSDictionary *action;
    for (NSDictionary *actionDict in response.notification.request.content.userInfo[@"ems"][@"actions"]) {
        if ([response.actionIdentifier isEqualToString:actionDict[@"id"]]) {
            action = actionDict;
            break;
        }
    }
    return action;
}

@end
