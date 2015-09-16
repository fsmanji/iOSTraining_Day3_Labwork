//
//  Utility.m
//  ParseChat
//
//  Created by Cristan Zhang on 9/16/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+(void)showAlert:(id)target with:(NSString *)title withMessage:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:target
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

@end
