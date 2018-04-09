//
//  AppDelegate.m
//  UberNewDriver
//
//  Created by Deep Gami on 27/09/14.
//  Copyright (c) 2014 Deep Gami. All rights reserved.
//

#import "AppDelegate.h"
#import "FacebookUtility.h"
#import "SignInVC.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "DGActivityIndicatorView.h"
#import <CoreLocation/CoreLocation.h>

//#import <SplunkMint-iOS/SplunkMint-iOS.h>

@implementation AppDelegate
{
    MBProgressHUD *HUD;
    
}
@synthesize viewLoading;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    //For Push Noti Reg.
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//
    
    [Fabric with:@[[Crashlytics class]]];
    [GMSServices provideAPIKey:Google_Map_API_Key];
    
    //Language Settings
    [self LanguageSelectionRefresh];
    
#ifdef __IPHONE_8_0
    //Right, that is the point
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#else
    //register to receive notifications
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif

    if([CLLocationManager locationServicesEnabled])
    {

    }
    else
    {

    }
    
    return YES;
    
    
    /*if (device_token==nil)
    {
        device_token=@"11111";
    }
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setObject:device_token forKey:PREF_DEVICE_TOKEN];
    [pref synchronize];
    
    [[FacebookUtility sharedObject]getFBToken];
    
    if ([[FacebookUtility sharedObject]isLogin])
    {
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate userLoggedIn];
        SignInVC *obj=[[SignInVC alloc]init];
        UIButton *loginButton = [obj btnFacebook];
        [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    }
    // Override point for customization after application launch.
        
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        //register to receive notifications
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    [[Mint sharedInstance] initAndStartSession:@"3431d0c8"];*/
    
}



- (void)userLoggedIn
{
    // Set the button title as "Log out"
    
    SignInVC *obj=[[SignInVC alloc]init];
    UIButton *loginButton = obj.btnFacebook;
    [loginButton setTitle:@"Log out" forState:UIControlStateNormal];
    
    // Welcome message
    // [self showMessage:@"You're now logged in" withTitle:@"Welcome!"];
    
}
#pragma mark -
#pragma mark - GPPDeepLinkDelegate

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink
{
    // An example to handle the deep link data.
//    UIAlertView *alert = [[UIAlertView alloc]
//                          initWithTitle:@"Deep-link Data"
//                          message:[deepLink deepLinkID]
//                          delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil];
//    [alert show];


    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Deep-link Data"
                                                                          message:[deepLink deepLinkID]
                                                                   preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                   }];
    [alert addAction:cancelButton];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation
{
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if([self.navbck isEqual:@"1"])
    {
        self.navbck=@"0";
    }
    else
    {
        UIApplication *app = [UIApplication sharedApplication];
        UIBackgroundTaskIdentifier bgTask = 0;
        bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            [app endBackgroundTask:bgTask];
        }];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -
#pragma mark - Directory Path Methods

- (NSString *)applicationCacheDirectoryString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return cacheDirectory;
}


#pragma mark-
#pragma mark- Handle Push Method

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

//For interactive notification only
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

- (NSString*)stringWithDeviceToken:(NSData*)deviceToken
{
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++)
    {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    return [token copy] ;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* strdeviceToken = [[NSString alloc]init];
    strdeviceToken=[self stringWithDeviceToken:deviceToken];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:strdeviceToken forKey:PREF_DEVICE_TOKEN];
    
    [prefs synchronize];
    //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Token " message:strdeviceToken delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    //[alert show];
    NSLog(@"My token is: %@",strdeviceToken);
    
    /*
     
     NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceToken);
     NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
     dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
     device_token=dt;
     
     if(dt==nil)
     {
     device_token=@"r11";
     
     }
     //    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Token " message:dt delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     // [alert show];
     NSLog(@"My token is: %@", dt);
     NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
     [pref setObject:device_token forKey:PREF_DEVICE_TOKEN];
     [pref synchronize];
     */
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
    NSLog(@"Failed to get token, error: %@", error);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"121212121212121212" forKey:PREF_DEVICE_TOKEN];
    [prefs synchronize];
    
    /*
     if (device_token==nil)
     {
     device_token=@"11111";
     }
     NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
     [pref setObject:device_token forKey:PREF_DEVICE_TOKEN];
     [pref synchronize];
     */
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSMutableDictionary *aps=[userInfo valueForKey:@"aps"];
    NSMutableDictionary *msg=[aps valueForKey:@"request_data"];
    NSLog(@"%@", msg);
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",msg] message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"cancel", nil];
    
    //[alert show];
}
-(void)handleRemoteNitification:(UIApplication *)application userInfo:(NSDictionary *)userInfo
{
    NSMutableDictionary *aps=[userInfo valueForKey:@"aps"];
    NSMutableDictionary *msg=[aps valueForKey:@"request_data"];
    NSLog(@"%@", msg);
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",msg] message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"cancel", nil];
    //[alert show];
    
    
}

#pragma mark-
#pragma mark- Indicator Delegate


-(void) showHUDLoadingView:(NSString *)strTitle
{
    HUD = [[MBProgressHUD alloc] initWithView:self.window];
    [self.window addSubview:HUD];
    //HUD.delegate = self;
    //HUD.labelText = [strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    HUD.detailsLabelText=[strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    [HUD show:YES];
}

-(void) hideHUDLoadingView
{
    [HUD removeFromSuperview];
    [HUD setHidden:YES];
    [HUD show:NO];
}

-(void)showToastMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window
                                              animated:YES];
    
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.detailsLabelText = message;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:0.5];
}

#pragma mark -
#pragma mark - Loading View

-(void)showLoadingWithTitle:(NSString *)title
{
    if (viewLoading==nil) {
        viewLoading=[[UIView alloc]initWithFrame:self.window.bounds];
        viewLoading.backgroundColor=[UIColor whiteColor];
        viewLoading.alpha=0.6f;
        
        
        DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)DGActivityIndicatorAnimationTypeBallClipRotatePulse  tintColor:[UberStyleGuide colorDefault]];
        activityIndicatorView.frame = CGRectMake(viewLoading.frame.size.width/2 - 25, viewLoading.frame.size.height/2 - 25, 50.0f, 50.0f);
        [viewLoading addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
/*
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((viewLoading.frame.size.width-88)/2, ((viewLoading.frame.size.height-30)/2)-30, 88, 30)];
        img.backgroundColor=[UIColor clearColor];
        img.animationImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"loading_1.png"],[UIImage imageNamed:@"loading_2.png"],[UIImage imageNamed:@"loading_3.png"], nil];
        img.animationDuration = 1.0f;
        img.animationRepeatCount = 0;
        [img startAnimating];
        [viewLoading addSubview:img];
        
        UITextView *txt=[[UITextView alloc]initWithFrame:CGRectMake((viewLoading.frame.size.width-250)/2, ((viewLoading.frame.size.height-60)/2)+20, 250, 60)];
        txt.textAlignment=NSTextAlignmentCenter;
        txt.backgroundColor=[UIColor clearColor];
        txt.text=[title uppercaseString];
        txt.font=[UIFont systemFontOfSize:16];
        txt.userInteractionEnabled=FALSE;
        txt.scrollEnabled=FALSE;
        txt.textColor=[UberStyleGuide colorDefault];
        [viewLoading addSubview:txt];
 */
    }
    
    [self.window addSubview:viewLoading];
    [self.window bringSubviewToFront:viewLoading];
}

-(void)hideLoadingView
{
    
    if (viewLoading) {
        [viewLoading removeFromSuperview];
        viewLoading=nil;
    }
}

-(void)LanguageSelectionRefresh
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject * object = [prefs objectForKey:@"TranslationDocumentName"];
    if(object == nil)
    {
        [prefs setObject:@"LocalizableArabic" forKey:@"TranslationDocumentName"];
    }
    [prefs synchronize];
}
#pragma mark-
#pragma mark- Test Internet


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return (networkStatus != NotReachable);
}

#pragma mark -
#pragma mark - sharedAppDelegate

+(AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark-
#pragma mark- Font Descriptor

-(id)setBoldFontDiscriptor:(id)objc
{
    if([objc isKindOfClass:[UIButton class]])
    {
        UIButton *button=objc;
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0f];
        return button;
    }
    else if([objc isKindOfClass:[UITextField class]])
    {
        UITextField *textField=objc;
        textField.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0f];
        return textField;
        
        
    }
    else if([objc isKindOfClass:[UILabel class]])
    {
        UILabel *lable=objc;
        lable.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0f];
        return lable;
    }
    return objc;
}

@end
/*
 -(id)setBoldFontDiscriptor:(id)objc
 {
 if([objc isKindOfClass:[UIButton class]])
 {
 UIButton *button=objc;
 button.titleLabel.font=[UberStyleGuide fontRegularBold:13.0f];
 UIFontDescriptor * fontD = [button.font.fontDescriptor
 fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold
 ];
 button.font = [UIFont fontWithDescriptor:fontD size:10.0f];
 return button;
 }
 else if([objc isKindOfClass:[UITextField class]])
 {
 UITextField *textField=objc;
 textField.font=[UberStyleGuide fontRegularBold];
 UIFontDescriptor * fontD = [textField.font.fontDescriptor
 fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold
 ];
 textField.font = [UIFont fontWithDescriptor:fontD size:0];
 return textField;
 
 
 }
 else if([objc isKindOfClass:[UILabel class]])
 {
 UILabel *lable=objc;
 lable.font=[UberStyleGuide fontRegularBold];
 UIFontDescriptor * fontD = [lable.font.fontDescriptor
 fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold
 ];
 lable.font = [UIFont fontWithDescriptor:fontD size:0];
 return lable;
 
 
 }
 return objc;
 }
 */
/*-(void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application
 {
 [NSUserDefaults resetStandardUserDefaults];
 }*/
