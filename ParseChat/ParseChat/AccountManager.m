//
//  AccountManager.m
//  ParseChat
//
//  Created by Cristan Zhang on 9/16/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "AccountManager.h"

@implementation AccountManager

#pragma mark Singleton Methods

+ (id)sharedManager {
    static AccountManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.username = @"tomtom123";
        self.password = @"123456";
        self.email = @"tomtom123@gmail.com";
        self.phone = @"415-392-0202";
    }
    return self;
}

-(BOOL)isLoggedIn {
    PFUser *currentUser = [PFUser currentUser];
    return currentUser != nil;
}

-(PFUser *)currentUser {
    return [PFUser currentUser];
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


@end
