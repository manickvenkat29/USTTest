//
//  OAuthLoginManager.m
//  USTTest
//
//  Created by Manickam on 17/10/24.
//

#import <Foundation/Foundation.h>

#import "OAuthLoginManager.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <Network/Network.h>

@interface OAuthLoginManager ()

@property (nonatomic, strong) NSString *token;

@end

@implementation OAuthLoginManager

+ (instancetype)sharedManager {
    static OAuthLoginManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)loginWithCompletion:(void (^)(BOOL success, NSString * _Nullable token))completion {
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
    UIViewController *rootViewController = keyWindow.rootViewController;

    GIDConfiguration *config = [[GIDConfiguration alloc] initWithClientID:@"998529752940-ftp63qcicf0b16dqc6ajnn4tgfslkmal.apps.googleusercontent.com"];
    [signIn signInWithConfiguration:config
             presentingViewController:rootViewController
                             callback:^(GIDGoogleUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            completion(NO, nil);
            return;
        }

        self.token = user.authentication.accessToken;

        [[NSUserDefaults standardUserDefaults] setObject:self.token forKey:@"OAuthToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        completion(YES, self.token);
    }];
}

- (void)silentLoginWithCompletion:(void (^)(BOOL success))completion {
    self.token = [[NSUserDefaults standardUserDefaults] stringForKey:@"OAuthToken"];
    if (self.token) {
        [self checkNetworkReachability:^(BOOL reachable) {
                    NSLog(@"Network reachable: %@", reachable ? @"YES" : @"NO");
                    if (reachable) {
                        completion(YES);
                    } else {
                        [self logout];
                        completion(NO);
                    }
                }];
    } else {
        completion(NO);
    }
}

- (void)logout {
    self.token = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OAuthToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[GIDSignIn sharedInstance] signOut];
}

- (void)checkNetworkReachability:(void (^)(BOOL reachable))completion {
        nw_path_monitor_t monitor = nw_path_monitor_create();
        dispatch_queue_t queue = dispatch_queue_create("NetworkReachabilityQueue", DISPATCH_QUEUE_SERIAL);
        nw_path_monitor_set_queue(monitor, queue);
        nw_path_monitor_set_update_handler(monitor, ^(nw_path_t path) {
        BOOL reachable = nw_path_get_status(path) == nw_path_status_satisfied;
        completion(reachable);
        nw_path_monitor_cancel(monitor);
    });

    nw_path_monitor_start(monitor);
}

- (BOOL)isUserLoggedIn {
    self.token = [[NSUserDefaults standardUserDefaults] stringForKey:@"OAuthToken"];
    return (self.token != nil);
}

@end
