//
//  DTFacebookManager.m
//  Debty
//
//  Created by Tanguy Hélesbeux on 05/07/2014.
//  Copyright (c) 2014 Debty. All rights reserved.
//

#import "MSFacebookManager.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "MSSportner.h"

#define CAPTION @"MySportner"

@implementation MSFacebookManager

+ (void)fetchUserWithCompletionHandler:(FBRequestHandler)completionHandler
{
    FBRequest *meRequest = [FBRequest requestForMe];
    [meRequest startWithCompletionHandler:completionHandler];
}

+ (void)fetchFriendsWithCompletionHandler:(FBRequestHandler)completionHandler
{
    FBRequest *friendRequest = [FBRequest requestForMyFriends];
    [friendRequest startWithCompletionHandler:completionHandler];
}

+ (NSString *)facebookIDForUser:(id<FBGraphUser>)user
{
    return [user objectForKey:@"id"];
}

+ (NSArray *)facebookIDForUserArray:(NSArray *)users
{
    NSMutableArray *tempIDs = [[NSMutableArray alloc] init];
    for (id<FBGraphUser> user in users) {
        [tempIDs addObject:[MSFacebookManager facebookIDForUser:user]];
    }
    return tempIDs;
}

+ (void)requestForMyFriendsWithBlock:(PFArrayResultBlock)block
{
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        NSArray *facebookFriends = [result objectForKey:@"data"];
        NSMutableArray *facebookIDs = [[NSMutableArray alloc] init];
        
        for (NSDictionary<FBGraphUser>* friend in facebookFriends) {
            [facebookIDs addObject:friend.objectID];
        }
        
        [self getSportnersFromFacebookIDArray:facebookIDs withBlock:block];
    }];
}

+ (void)getSportnersFromFacebookIDArray:(NSArray *)facebookIDs withBlock:(PFArrayResultBlock)block
{
    PFQuery *query = [MSSportner query];
    [query whereKey:@"facebookID" containedIn:facebookIDs];
    [query findObjectsInBackgroundWithBlock:block];
}

+ (void)toggleSession
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:FACEBOOK_PERMISSIONS
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Call the sessionStateChanged:state:error method to handle session state changes
             [self sessionStateChanged:session state:state error:error completionHandler:nil];
         }];
    }
}

+ (void)handleAppColdStart
{
//    // Note this handler block should be the exact same as the handler passed to any open calls.
//    [FBSession.activeSession setStateChangeHandler:
//     ^(FBSession *session, FBSessionState state, NSError *error) {
//         
//         // Call the sessionStateChanged:state:error method to handle session state changes
//         [self sessionStateChanged:session state:state error:error completionHandler:nil];
//     }];
}

+ (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
          completionHandler:(FBRequestHandler)completionHandler
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedInWithCompletionHandler:completionHandler];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

+ (void)logInWithCompletionHandler:(FBRequestHandler)completionHandler
{
    // Open a session showing the user the login UI
    // You must ALWAYS ask for public_profile permissions when opening a session
    [FBSession openActiveSessionWithReadPermissions:FACEBOOK_PERMISSIONS
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Call the sessionStateChanged:state:error method to handle session state changes
         [self sessionStateChanged:session state:state error:error completionHandler:completionHandler];
     }];
}

+ (void)logOut
{
    // Close the session and remove the access token from the cache
    // The session state handler (in the app delegate) will be called automatically
    [FBSession.activeSession closeAndClearTokenInformation];
}

+ (BOOL)isSessionAvailable
{
    return (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded || FBSession.activeSession.state == FBSessionStateCreatedOpening || [self isSessionOpen]);
}

+ (BOOL)isSessionOpen
{
    return (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended);
}

+ (void)showMessage:(NSString *)alertText withTitle:(NSString *)alertTitle
{
    NSLog(@"[DTFacebookManager showMessage:withTitle]\n%@\%@", alertTitle, alertText);
}

+ (void)userLoggedInWithCompletionHandler:(FBRequestHandler)completionHandler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DTNotificationFacebookUserLoggedIn object:nil];
    
    if (completionHandler) {
        [self fetchUserWithCompletionHandler:completionHandler];
    }
}

+ (void)userLoggedOut
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DTNotificationFacebookUserLoggedOut object:nil];
}

#pragma mark - Share

+ (void)shareSignUp
{
    NSString *shareTitlePattern = NSLocalizedString(@"What a great App!! Hurry to join!!", @"Facebook share pattern");
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"http://www.mysportner.com"];
    params.name = shareTitlePattern;
    params.caption = CAPTION;
    params.picture = [NSURL URLWithString:@"https://pbs.twimg.com/profile_images/378800000551667532/b81759440b14ba757bb8b0d7ccceae34.png"];
    params.linkDescription = @"blabla";
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present the share dialog
        [MSFacebookManager presentShareDialogWithParameters:params];
    } else {
        // Present the feed dialog
        [MSFacebookManager presentFeedDialogWithParameters:params];
    }
}

+ (void)shareInviteFriends
{
    NSString *shareTitlePattern = NSLocalizedString(@"We need more players, join us on MySportner!", @"Facebook invite pattern");
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"http://www.mysportner.com"];
    params.name = shareTitlePattern;
    params.caption = CAPTION;
    params.picture = [NSURL URLWithString:@"https://pbs.twimg.com/profile_images/378800000551667532/b81759440b14ba757bb8b0d7ccceae34.png"];
    params.linkDescription = @"blabla";
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present the share dialog
        [MSFacebookManager presentShareDialogWithParameters:params];
    } else {
        // Present the feed dialog
        [MSFacebookManager presentFeedDialogWithParameters:params];
    }
}

+ (void)presentShareDialogWithParameters:(FBLinkShareParams *)params
{
    
    // Present share dialog
    [FBDialogs presentShareDialogWithLink:params.link
                                     name:params.name
                                  caption:params.caption
                              description:params.linkDescription
                                  picture:params.picture
                              clientState:nil
                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      if(error) {
                                          // An error occurred, we need to handle the error
                                          // See: https://developers.facebook.com/docs/ios/errors
                                          NSLog(@"%@", error);
                                      } else {
                                          // Success
                                          NSLog(@"result %@", results);
                                      }
                                  }];
}

+ (void)presentFeedDialogWithParameters:(FBLinkShareParams *)parameters
{
    // Put together the dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   parameters.name, @"name",
                                   parameters.caption, @"caption",
                                   parameters.linkDescription, @"description",
                                   parameters.link.description, @"link",
                                   parameters.picture.description, @"picture",
                                   nil];
    
    // Show the feed dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  if (error) {
                                                      // An error occurred, we need to handle the error
                                                      // See: https://developers.facebook.com/docs/ios/errors
                                                      NSLog(@"%@", error);
                                                  } else {
                                                      if (result == FBWebDialogResultDialogNotCompleted) {
                                                          // User cancelled.
                                                          NSLog(@"User cancelled.");
                                                      } else {
                                                          // Handle the publish feed callback
                                                          NSDictionary *urlParams = [MSFacebookManager parseURLParams:[resultURL query]];
                                                          
                                                          if (![urlParams valueForKey:@"post_id"]) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                              
                                                          } else {
                                                              // User clicked the Share button
                                                              NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                              NSLog(@"result %@", result);
                                                          }
                                                      }
                                                  }
                                              }];
}


// A function for parsing URL parameters returned by the Feed Dialog.
+ (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

@end
