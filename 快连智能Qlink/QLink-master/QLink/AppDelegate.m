//
//  AppDelegate.m
//  QLink
//
//  Created by 尤日华 on 14-9-17.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DataUtil.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"首页_nav.png"] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.translucent = NO;
    [nav.navigationBar setHidden:YES];
    self.window.rootViewController = nav;
    
    //复制数据库 copy the path to the database file
    NSString *databasePath = [[NSString alloc] initWithString:[[DataUtil getDirectoriesInDomains] stringByAppendingPathComponent:DBNAME]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:databasePath] == NO)
    {
        NSError*error;
        NSString *dbPath =[[NSBundle mainBundle] pathForResource:@"QLink" ofType:@"sqlite"];
        [filemgr copyItemAtPath:dbPath toPath:databasePath error:&error];
    }
    
    [self.window makeKeyAndVisible];
    
    //处理为正常模式
    [DataUtil setGlobalIsAddSence:NO];//设置当前为非添加模式
    [SQLiteUtil removeShoppingCar];
    
    [self checkDefaultCustom];
    
    return YES;
}

//是否有自定义引导页显示
-(void)checkDefaultCustom
{
    Control *control = [SQLiteUtil getControlObj];
    if (control && control.OpenPic) {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[DataUtil getDirectoriesInDomains] stringByAppendingPathComponent:@"help.png"]];
        UIImageView *ivDefault = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        ivDefault.image = image;
        [self.window addSubview:ivDefault];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ivDefault removeFromSuperview];
        });
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([sourceApplication isEqualToString:@"xxx.xxx.xxx"]) {
        //xx
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
