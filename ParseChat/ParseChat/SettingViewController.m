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
#import <ParseFacebookUtilsv4/PFFacebookUtils.h>

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property AccountManager *accountManager;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _accountManager = [AccountManager sharedManager];

    self.logoutButton.enabled = [_accountManager isLoggedIn];
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateFacebookButton];
}

-(void)updateFacebookButton {
    PFUser* user = [_accountManager currentUser];
    NSString* title = ![PFFacebookUtils isLinkedWithUser:user]?
    @"Link to Facebook" :
    @"Unlink to Facebook";
    [self.facebookButton setTitle:title forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)linkToFacebook:(id)sender {
    PFUser* user = [_accountManager currentUser];
    if (![PFFacebookUtils isLinkedWithUser:user]) {
        [PFFacebookUtils linkUserInBackground:user withReadPermissions:nil block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Woohoo, user is linked with Facebook!");
                [self updateFacebookButton];
            }
        }];
    } else {
        [PFFacebookUtils unlinkUserInBackground:user block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"The user is no longer associated with their Facebook account.");
                [self updateFacebookButton];
            }
        }];
    }
}

- (IBAction)onLogout:(id)sender {
    
    if([_accountManager isLoggedIn]) {
        [_accountManager logOut];
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
