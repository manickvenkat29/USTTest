//
//  OAuthLoginManager.h
//  USTTest
//
//  Created by Manickam on 17/10/24.
//

#ifndef OAuthLoginManager_h
#define OAuthLoginManager_h



#endif /* OAuthLoginManager_h */

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface OAuthLoginManager : NSObject

+ (instancetype)sharedManager;
- (void)loginWithCompletion:(void (^)(BOOL success, NSString * _Nullable token))completion;
- (BOOL)isUserLoggedIn;
- (void)silentLoginWithCompletion:(void (^)(BOOL success))completion;
- (void)logout;
- (void)checkNetworkReachability:(void (^)(BOOL reachable))completion;
@end

NS_ASSUME_NONNULL_END
