/*
 * AppDelegate.m
 * ChartboostExampleApp
 *
 * Copyright (c) 2013 Chartboost. All rights reserved.
 */

#import <Chartboost/Chartboost.h>
#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate () <ChartboostDelegate>
@end

@implementation AppDelegate 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString* sdkVersion = [Chartboost getSDKVersion];
    NSLog(@"Chartboost SDK Version = %@", sdkVersion);
    [Chartboost setLoggingLevel:CBLoggingLevelVerbose];
    // Begin a user session. Must not be dependent on user actions or any prior network requests.
    [Chartboost startWithAppId:@"4f21c409cd1cb2fb7000001b" appSignature:@"92e2de2fd7070327bdeb54c15a5295309c6fcd2d" delegate:self];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
}

/*
 * Chartboost Delegate Methods
 *
 */

/*
 * didInitialize
 *
 * This is used to signal when Chartboost SDK has completed its initialization.
 *
 * status is YES if the server accepted the appID and appSignature as valid
 * status is NO if the network is unavailable or the appID/appSignature are invalid
 *
 * Is fired on:
 * -after startWithAppId has completed background initialization and is ready to display ads
 */
- (void)didInitialize:(BOOL)status {
    NSLog(@"didInitialize");
    // chartboost is ready
    [Chartboost cacheRewardedVideo:CBLocationMainMenu];

    // Show an interstitial whenever the app starts up
    [Chartboost showInterstitial:CBLocationHomeScreen];
}


/*
 * shouldDisplayInterstitial
 *
 * This is used to control when an interstitial should or should not be displayed
 * The default is YES, and that will let an interstitial display as normal
 * If it's not okay to display an interstitial, return NO
 *
 * For example: during gameplay, return NO.
 *
 * Is fired on:
 * -Interstitial is loaded & ready to display
 */

- (BOOL)shouldDisplayInterstitial:(NSString *)location {
    NSLog(@"about to display interstitial at location %@", location);

    // For example:
    // if the user has left the main menu and is currently playing your game, return NO;
    
    // Otherwise return YES to display the interstitial
    return YES;
}


/*
 * didFailToLoadInterstitial
 *
 * This is called when an interstitial has failed to load. The error enum specifies
 * the reason of the failure
 */

- (void)didFailToLoadInterstitial:(NSString *)location withError:(CBLoadError)error {
    NSLog(@"%@",[self getErrorText:error adType:@"Interstitial"]);
}

- (NSString *)getErrorText:(CBLoadError)e adType:(NSString *)t {
    NSString *errorText;
    switch(e){
        case CBLoadErrorInternal: {
            errorText = [NSString stringWithFormat:@"Failed to load %@, internal error !",t];
        } break;
        case CBLoadErrorInternetUnavailable: {
            errorText = [NSString stringWithFormat:@"Failed to load %@, no Internet connection !",t];
        } break;
        case CBLoadErrorInternetUnavailableAtShow: {
            errorText = [NSString stringWithFormat:@"Failed to show %@, no Internet connection !",t];
        } break;
        case CBLoadErrorTooManyConnections: {
            errorText = [NSString stringWithFormat:@"Failed to load %@, too many connections !",t];
        } break;
        case CBLoadErrorWrongOrientation: {
            errorText = [NSString stringWithFormat:@"Failed to load %@, wrong orientation !",t];
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            errorText = [NSString stringWithFormat:@"Failed to load %@, first session !",t];
        } break;
        case CBLoadErrorNetworkFailure: {
            errorText = [NSString stringWithFormat:@"Failed to load %@, network error !",t];
        } break;
        case CBLoadErrorNoAdFound : {
            errorText = [NSString stringWithFormat:@"Failed to load %@, no ad found !",t];
        } break;
        case CBLoadErrorSessionNotStarted : {
            errorText = [NSString stringWithFormat:@"Failed to load %@, session not started !",t];
        } break;
        case CBLoadErrorImpressionAlreadyVisible : {
            errorText = [NSString stringWithFormat:@"Failed to load %@, impression already visible !",t];
        } break;
        case CBLoadErrorUserCancellation : {
            errorText = [NSString stringWithFormat:@"Failed to load %@, impression cancelled !",t];
        } break;
        case CBLoadErrorNoLocationFound : {
            NSLog(@"Failed to load Interstitial, missing location parameter !");
        } break;
        case CBLoadErrorAssetDownloadFailure : {
            errorText = [NSString stringWithFormat:@"Failed to load %@, asset download failed !",t];
        } break;
        case CBLoadErrorPrefetchingIncomplete : {
            errorText = [NSString stringWithFormat:@"Failed to load %@, prefetching of video content is incomplete !",t];
        } break;
        default: {
            errorText = [NSString stringWithFormat:@"Failed to load %@, unknown error %lul!", t, (long)e];
        }
    }
    return errorText;
}

/*
 * didCacheInterstitial
 *
 * Passes in the location name that has successfully been cached.
 *
 * Is fired on:
 * - All assets loaded
 * - Triggered by cacheInterstitial
 *
 * Notes:
 * - Similar to this is: (BOOL)hasInterstitial:(NSString *)location;
 * Which will return true if a cached interstitial exists for that location
 */

- (void)didCacheInterstitial:(NSString *)location {
    NSLog(@"interstitial cached at location %@", location);
}


/*
 * didDismissInterstitial
 *
 * This is called when an interstitial is dismissed
 *
 * Is fired on:
 * - Interstitial click
 * - Interstitial close
 *
 */

- (void)didDismissInterstitial:(NSString *)location {
    NSLog(@"dismissed interstitial at location %@", location);
}


/*
 * didCompleteRewardedVideo
 *
 * This is called when a rewarded video has been viewed
 *
 * Is fired on:
 * - Rewarded video completed view
 *
 */
- (void)didCompleteRewardedVideo:(CBLocation)location withReward:(int)reward {
    NSLog(@"completed rewarded video view at location %@ with reward amount %d", location, reward);
}

/*
 * didFailToLoadRewardedVideo
 *
 * This is called when a Rewarded Video has failed to load. The error enum specifies
 * the reason of the failure
 */

- (void)didFailToLoadRewardedVideo:(NSString *)location withError:(CBLoadError)error {
    NSLog(@"%@",[self getErrorText:error adType:@"Rewarded Video"]);
}

/*
 * didDisplayInterstitial
 *
 * Called after an interstitial has been displayed on the screen.
 */

- (void)didDisplayInterstitial:(CBLocation)location {
    NSLog(@"Did display interstitial");
    
    // We might want to pause our in-game audio, lets double check that an ad is visible
    if ([Chartboost isAnyViewVisible]) {
        // Use this function anywhere in your logic where you need to know if an ad is visible or not.
        NSLog(@"Pause audio");
    }
}


/*!
 @abstract
 Called after an InPlay object has been loaded from the Chartboost API
 servers and cached locally.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an InPlay object has been loaded from the Chartboost API
 servers and cached locally for a given CBLocation.
 */
- (void)didCacheInPlay:(CBLocation)location {
    NSLog(@"Successfully cached inPlay");
    ViewController *vc = (ViewController*)self.window.rootViewController;
    [vc renderInPlay:[Chartboost getInPlay:location]];
}

/*!
 @abstract
 Called after a InPlay has attempted to load from the Chartboost API
 servers but failed.
 
 @param location The location for the Chartboost impression type.
 
 @param error The reason for the error defined via a CBLoadError.
 
 @discussion Implement to be notified of when an InPlay has attempted to load from the Chartboost API
 servers but failed for a given CBLocation.
 */
- (void)didFailToLoadInPlay:(CBLocation)location
                  withError:(CBLoadError)error {
    
    NSString *errorString = [self getErrorText:error adType:@"InPlay"];
    NSLog(@"Error: %@", errorString);
    
    ViewController *vc = (ViewController*)self.window.rootViewController;
    [vc renderInPlayError:errorString];
}


/*!
 Called before requesting an interstitial via the Chartboost API server.
 
 @param location The location for the Chartboost impression type.
 
 @return YES if execution should proceed, NO if not.
 
 @discussion Implement to control if the Charboost SDK should fetch data from
 the Chartboost API servers for the given CBLocation.  This is evaluated
 if the showInterstitial:(CBLocation) or cacheInterstitial:(CBLocation)location
 are called.  If YES is returned the operation will proceed, if NO, then the
 operation is treated as a no-op.
 
 Default return is YES.
 */
- (BOOL)shouldRequestInterstitial:(CBLocation)location {
  NSLog(@"should interstitial for location %@: YES", location);
  return YES;
}

/*!
 Called after a click is registered, but the user is not fowrwarded to the IOS App Store.
 
 @param location The location for the Chartboost impression type.
 
 @param error The reason for the error defined via a CBLoadError.
 
 @discussion Implement to be notified of when a click is registered, but the user is not fowrwarded
 to the IOS App Store for a given CBLocation.
 */
- (void)didFailToRecordClick:(CBLocation)location
                   withError:(CBClickError)error {
  NSLog(@"did fail to record click at location %@", location);
}

/*!
 Called after an interstitial has been closed.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an interstitial has been closed for a given CBLocation.
 "Closed" is defined as clicking the close interface for the interstitial.
 */
- (void)didCloseInterstitial:(CBLocation)location {
  NSLog(@"did close interstitial at location %@", location);
}

/*!
 Called after an interstitial has been clicked.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an interstitial has been click for a given CBLocation.
 "Clicked" is defined as clicking the creative interface for the interstitial.
 */
- (void)didClickInterstitial:(CBLocation)location {
  NSLog(@"did click interstitial at location %@", location);
}


#pragma mark - Rewarded Video Delegate

/*!
 Called before a rewarded video will be displayed on the screen.
 
 @param location The location for the Chartboost impression type.
 
 @return YES if execution should proceed, NO if not.
 
 @discussion Implement to control if the Charboost SDK should display a rewarded video
 for the given CBLocation.  This is evaluated if the showRewardedVideo:(CBLocation)
 is called.  If YES is returned the operation will proceed, if NO, then the
 operation is treated as a no-op and nothing is displayed.
 
 Default return is YES.
 */
- (BOOL)shouldDisplayRewardedVideo:(CBLocation)location {
  NSLog(@"should display rewarded video: YES");
  return YES;
}

/*!
 Called after a rewarded video has been displayed on the screen.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has
 been displayed on the screen for a given CBLocation.
 */
- (void)didDisplayRewardedVideo:(CBLocation)location {
  NSLog(@"did display Rewarded Video at location %@", location);
}

/*!
 Called after a rewarded video has been loaded from the Chartboost API
 servers and cached locally.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has been loaded from the Chartboost API
 servers and cached locally for a given CBLocation.
 */
- (void)didCacheRewardedVideo:(CBLocation)location {
  NSLog(@"did cache Rewarded Video at location %@", location);
}

/*!
 Called after a rewarded video has been dismissed.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has been dismissed for a given CBLocation.
 "Dismissal" is defined as any action that removed the rewarded video UI such as a click or close.
 */
- (void)didDismissRewardedVideo:(CBLocation)location {
  NSLog(@"did dismiss Rewarded Video at location %@", location);
}

/*!
 Called after a rewarded video has been closed.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has been closed for a given CBLocation.
 "Closed" is defined as clicking the close interface for the rewarded video.
 */
- (void)didCloseRewardedVideo:(CBLocation)location {
  NSLog(@"did close Rewarded Video at location %@", location);
}

/*!
 Called after a rewarded video has been clicked.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has been click for a given CBLocation.
 "Clicked" is defined as clicking the creative interface for the rewarded video.
 */
- (void)didClickRewardedVideo:(CBLocation)location {
  NSLog(@"did click Rewarded Video at location %@", location);
}

/*!
 Called before a video has been displayed on the screen.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a video will
 be displayed on the screen for a given CBLocation.  You can then do things like mute
 effects and sounds.
 */
- (void)willDisplayVideo:(CBLocation)location {
  NSLog(@"will displat video at location %@", location);
}

/*!
 Called after the App Store sheet is dismissed, when displaying the embedded app sheet.
 
 @discussion Implement to be notified of when the App Store sheet is dismissed.
 */
- (void)didCompleteAppStoreSheetFlow {
  NSLog(@"did complete app store sheet flow");
}

/*!
 Called if Chartboost SDK pauses click actions awaiting confirmation from the user.
 
 @discussion Use this method to display any gating you would like to prompt the user for input.
 Once confirmed call didPassAgeGate:(BOOL)pass to continue execution.
 */
- (void)didPauseClickForConfirmation {
  NSLog(@"did pause click for confirmation");
}



@end
