#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

#import <React/RCTBundleURLProvider.h>
#import <RNBranch/RNBranch.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // [RNBranch useTestInstance];
  [RNBranch enableLogging];
  [RNBranch initSessionWithLaunchOptions:launchOptions isReferrable:YES];
  NSURL *jsCodeLocation;
  
  self.moduleName = @"ReactNativeSample";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};
  
  // Request ATT permissions
//  dispatch_async(dispatch_get_main_queue(), ^{
//      [self requestATTAuthorization];
//  });


  // Request push notification permissions
    [self requestPushNotificationPermissions];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  return [self bundleURL];
}

- (NSURL *)bundleURL
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
  [RNBranch application:app openURL:url options:options];
  return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
  [RNBranch continueUserActivity:userActivity];
  return YES;
}



//- (void)requestATTAuthorization {
//  if (@available(iOS 14, *)) {
//    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
//      switch (status) {
//        case ATTrackingManagerAuthorizationStatusNotDetermined:
//          NSLog(@"User has not yet received an authorization request to allow tracking.");
//        //  [self requestATTAuthorization];
//          break; // Ensure break is used here
//
//        case ATTrackingManagerAuthorizationStatusRestricted:
//          NSLog(@"User is not allowed to authorize app tracking.");
//          break; // Ensure break is used here
//
//        case ATTrackingManagerAuthorizationStatusDenied:
//          NSLog(@"User denied app tracking.");
//          break; // Ensure break is used here
//
//        case ATTrackingManagerAuthorizationStatusAuthorized:
//          NSLog(@"User authorized app tracking.");
//          // You can get the IDFA (Identifier for Advertisers) if needed
//          NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//          NSLog(@"IDFA: %@", idfa);
//          break; // Ensure break is used here
//      }
//    }];
//  } else {
//    NSLog(@"App Tracking Transparency is not available on this iOS version.");
//  }
//}


- (void)requestPushNotificationPermissions {
  if (@available(iOS 10.0, *)) {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
      if (granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [[UIApplication sharedApplication] registerForRemoteNotifications];
        });
      } else {
        NSLog(@"Push notification permission denied.");
      }
    }];
  } else {
    UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
  }
}

// Required for the register event.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  NSLog(@"Device Token: %@", deviceToken);
}

// Required for the registrationError event.
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
  NSLog(@"Failed to register for remote notifications: %@", error);
}

// Required for handling notifications
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
  NSLog(@"Received remote notification: %@", userInfo);
  completionHandler(UIBackgroundFetchResultNewData);
}

@end
