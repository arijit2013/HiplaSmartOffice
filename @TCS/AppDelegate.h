//
//  AppDelegate.h
//  @TCS
//
//  Created by FNSPL on 18/04/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Constants.h"
#import "CustomTabBarController.h"
#import "LoginViewController.h"
#import "RightSideDrawerViewController.h"
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import "SplashViewController.h"
#import "Database.h"
#import "LocationManager.h"
#import "FragmentManageViewController.h"

//LocationManager
@class LocationManager;
@class SplashViewController;
@class LoginViewController;
@class CustomTabBarController;
@class FragmentManageViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate,CLLocationManagerDelegate, UIAlertViewDelegate>
{
    NSDictionary *userinfo;
    NSDictionary *userDict;
    NSString *userId;
    LoginViewController *login;
    RightSideDrawerViewController *drawer;
    SplashViewController *splash;
    CustomTabBarController *tabBarVC;
    Database *db;
    UINavigationController *nav;
    UIButton *btn;
    
    int i;
    
    NSTimer *seduledTimer;
    BOOL isTimerClosed;
}

//LocationManager
@property(strong,nonatomic) LocationManager *shareModel;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FragmentManageViewController* fmViewController;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSFileManager *filemgr;
@property (nonatomic, strong) NSString *NewDir;
@property (nonatomic, strong) NSArray *dirPaths;
@property (nonatomic, strong) NSString *docsDir;

- (void)saveContext;
- (void)update_badgeWithViewControllerIndex;

@end

