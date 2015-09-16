//
//  SettingViewController.m
//  ParseChat
//
//  Created by Cristan Zhang on 9/16/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "AccountManager.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AccountManager *manager = [AccountManager sharedManager];

    self.logoutButton.enabled = [manager isLoggedIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogout:(id)sender {
    AccountManager *manager = [AccountManager sharedManager];
    if([manager isLoggedIn]) {
        [manager logOut];
        [self showLoginView];
    }
}

//show login view modally
-(void)showLoginView {
    LoginViewController* viewController = [[LoginViewController alloc] init];
    [self.navigationController popViewControllerAnimated:YES];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
