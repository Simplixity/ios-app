//
//  MockDataTransfer.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "DataTransfer.h"

//  Mock data transfer system for startup weekend.
@interface MockDataTransfer : NSObject<DataTransfer>
//  User whos data is being requested.
@property(nonatomic, readonly)User *user;

//  Target the data is being sent to.
@property(nonatomic, readonly)NSString *targetId;
@end
