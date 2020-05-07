//
//  FragmentManageViewController.m
//  @TCS
//
//  Created by FNSPL on 09/05/18.
//  Copyright © 2018 FNSPL. All rights reserved.
//

#import "FragmentManageViewController.h"

@interface FragmentManageViewController ()

@end

@implementation FragmentManageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableWithNotification:) name:@"RefreshTable" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadViewWithNotification:) name:@"ReloadView" object:nil];
    
}

// Add this method just beneath viewDidLoad:
- (void)refreshTableWithNotification:(NSNotification *)notification
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.mmVC = [storyboard instantiateViewControllerWithIdentifier:@"ManageMeetingViewController"];
    
    [self.mmVC setFmViewController:self];
    
    self.mmVC.isRequestMeeting = self.isRequestMeeting;
    
    [self.mmVC reloadData];
}

// Add this method just beneath viewDidLoad:
- (void)reloadViewWithNotification:(NSNotification *)notification
{
    [self.view setNeedsLayout];
    
    [self viewWillAppear:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self setFragmentMenu];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//    [self setFragmentMenu];
//}

-(void)setFragmentMenu
{
    NSMutableArray *arrControllers = [NSMutableArray new];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    ManageMeetingViewController *controller1 = [storyboard instantiateViewControllerWithIdentifier:@"ManageMeetingViewController"];
    
    [controller1 setFmViewController:self];
    
    controller1.title= @"My Meetings";
    
    controller1.isRequestMeeting = @"NO";
    
    controller1.isGroupAppointment = NO;
    
    
    [arrControllers addObject:controller1];
    
    
    ManageMeetingViewController *controller2 = [storyboard instantiateViewControllerWithIdentifier:@"ManageMeetingViewController"];
    
    [controller2 setFmViewController:self];
    
    controller2.title=@"Request Received";
    
    controller2.isRequestMeeting = @"YES";
    
    controller2.isGroupAppointment = NO;

    
    [arrControllers addObject:controller2];
    
    
    ManageMeetingViewController *controller3 = [storyboard instantiateViewControllerWithIdentifier:@"ManageMeetingViewController"];
    
    [controller3 setFmViewController:self];
    
    controller3.title=@"Group Meetings";
    
    controller3.isRequestMeeting = @"NO";
    
    controller3.isGroupAppointment = YES;
    
    
    [arrControllers addObject:controller3];
    
    
    NSDictionary *parameters = @{
                                 KPSmartTabBarOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0],
                                 KPSmartTabBarOptionMenuItemSelectedFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0],
                                 KPSmartTabBarOptionMenuItemSeparatorWidth : @(4.3),
                                 KPSmartTabBarOptionMenuItemSeparatorColor : [UIColor lightGrayColor],
                                 KPSmartTabBarOptionScrollMenuBackgroundColor : [UIColor blackColor],
                                 KPSmartTabBarOptionViewBackgroundColor : [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0],
                                 KPSmartTabBarOptionSelectionIndicatorColor : [UIColor colorWithHexString:@"1f8fcf"],
                                 KPSmartTabBarOptionMenuMargin:@(20.0),
                                 KPSmartTabBarOptionMenuHeight: @(40.0),
                                 KPSmartTabBarOptionSelectedMenuItemLabelColor:[UIColor colorWithHexString:@"1f8fcf"],
                                 KPSmartTabBarOptionUnselectedMenuItemLabelColor :[UIColor lightGrayColor],
                                 KPSmartTabBarOptionCenterMenuItems: @(YES),
                                 KPSmartTabBarOptionUseMenuLikeSegmentedControl : @(YES),
                                 KPSmartTabBarOptionMenuItemSeparatorRoundEdges:@(YES),
                                 KPSmartTabBarOptionEnableHorizontalBounce:@(NO),
                                 KPSmartTabBarOptionMenuItemSeparatorPercentageHeight:@(0.1),
                                 KPSmartTabBarOptionSelectionIndicatorHeight:@(2.0),
                                 KPSmartTabBarOptionAddBottomMenuHairline : @(YES),
                                 KPSmartTabBarOptionBottomMenuHairlineHeight : @(1.0),
                                 KPSmartTabBarOptionBottomMenuHairlineColor : [UIColor darkGrayColor]
                                 };
    
    _tabbar = [[KPSmartTabBar alloc] initWithViewControllers:arrControllers frame:CGRectMake(0.0, 88.0, self.view.frame.size.width, (self.view.frame.size.height-88)) options:parameters];
    
    [self.view addSubview:_tabbar.view];
    
}

    

#pragma mark - FragmentManageViewControllerDelegate
    
- (void)didSelectedRow:(NSDictionary *)item {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ManageMeetingDetailViewController* mmdVC = [storyboard instantiateViewControllerWithIdentifier:@"ManageMeetingDetailViewController"];
    
    mmdVC.isRequestMeeting = self.isRequestMeeting;
    mmdVC.isGroupAppointment = self.isGroupAppointment;
    mmdVC.dictMeetingDetails = item;
    
    [self.navigationController pushViewController:mmdVC animated:YES];
    
}

    
- (void)didSelectedNavigation:(NSDictionary *)item {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_objc" bundle:nil];
    ViewController *myVC = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    [self.navigationController pushViewController:myVC animated:YES];
    
}
    
    
- (void)reloadDataFromManageMeeting{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.mmVC = [storyboard instantiateViewControllerWithIdentifier:@"ManageMeetingViewController"];
    
    [self.mmVC setFmViewController:self];
    
    self.mmVC.isRequestMeeting = self.isRequestMeeting;
    
    //[self.mmVC reloadData];
    
    [self.mmVC performSelector:@selector(reloadData) withObject:self afterDelay:0.0];
    
}

    
- (void)openModal:(NSString *)strTitle withMessage:(NSString *)strMessage withOK:(BOOL)OK andCancel:(BOOL)Cancel withDict:(NSDictionary *)item
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:strTitle
                                 message:strMessage
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    if ((OK=YES) && (Cancel==YES)) {
        
        UIAlertAction* ok = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                        
                                        self.mmVC = [storyboard instantiateViewControllerWithIdentifier:@"ManageMeetingViewController"];
                                        
                                        [self.mmVC setFmViewController:self];
                                        
                                        [self.mmVC changeAppointment:item];
                                        
                                    }];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
    }
    else
    {
        UIAlertAction* ok = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                        
                                        
                                    }];
        
        [alert addAction:ok];
        
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}
    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    
}


@end
