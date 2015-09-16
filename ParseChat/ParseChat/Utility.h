//
//  Utility.h
//  ParseChat
//
//  Created by Cristan Zhang on 9/16/15.
//  Copyright (c) 2015 FastTrack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

extern NSString *kMessageClassName;
extern NSString *kMessageTextPropertyName;

+(void)showAlert:(id)target with:(NSString *)title withMessage:(NSString *)message;

@end
