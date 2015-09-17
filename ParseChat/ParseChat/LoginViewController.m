//
//  LoginViewController.m
//  ParseChat
//
//  Created by Cristan Zhang on 9/16/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "Utility.h"
#import "AccountManager.h"
#import "ChatViewController.h"
#import "SettingViewController.h"
#import <ParseFacebookUtilsv4/PFFacebookUtils.h>


@interface LoginViewController ()


@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;

@property (weak, nonatomic) IBOutlet UIButton *signinButton;

@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@property AccountManager* accountManager;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        self.title = @"Parse Chat Login";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _accountManager = [AccountManager sharedManager];
    
    //load test account into view
    self.usernameInput.text = _accountManager.username;
    self.passwordInput.text = _accountManager.password;
}

- (IBAction)loginWithFacebook:(id)sender {
    [PFFacebookUtils logInInBackgroundWithReadPermissions:nil block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            [Utility showAlert:self with:@"Signin Failed" withMessage:@"Uh oh. The user cancelled the Facebook login."];
        } else{
            [self exitView];
        }
    }];
}

- (IBAction)onSignInClicked:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.usernameInput.text password:self.passwordInput.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"Login sucessful: %@", user);
                                            [self exitView];
                                        } else {
                                            // The login failed. Check error to see why.
                                            
                                            NSString *errorString = [error userInfo][@"error"];
                                            [Utility showAlert:self with:@"Signin Failed" withMessage:errorString];
                                        }
                                    }];
    
    
}

- (IBAction)onSignUpClicked:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.usernameInput.text;
    user.password = self.passwordInput.text;
    user.email = @"tomtom123@gmail.com";
    
    // other fields can be set just like with PFObject
    user[@"phone"] = @"415-392-0202";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            NSLog(@"Signup sucessful: %@", user);

            [self exitView];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            
            [Utility showAlert:self with:@"SignUp Failed" withMessage:errorString];
        }
    }];
    
}

-(void)exitView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) showChatView {
   ChatViewController* chatViewController = [[ChatViewController alloc] init];
    [self.navigationController pushViewController:chatViewController animated:YES];
}

-(void)showSettingView {
    SettingViewController* viewController = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onUsernameChanged:(id)sender {
}

- (IBAction)onPasswordChanged:(id)sender {
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}
- (IBAction)onTapOutside:(id)sender {
    [self dismissKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
