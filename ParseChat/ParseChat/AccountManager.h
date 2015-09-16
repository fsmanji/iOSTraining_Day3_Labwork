//
//  AccountManager.h
//  ParseChat
//
//  Created by Cristan Zhang on 9/16/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface AccountManager : NSObject

//these are for test purposes
@property NSString *username;
@property NSString *password;
@property NSString *email;
@property NSString *phone;

//@property PFUser* currentUser;

+(id)sharedManager;

- (BOOL)isLoggedIn;

- (PFUser *)currentUser;

@end
