//
//  NSMutableURLRequest+EasyParams.h
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (EasyParams)
//  Creates a new url request with the url, method, and params encoded.
+(NSMutableURLRequest*)urlWithString:(NSString*)url andMethod:(NSString*)method andParams:(NSDictionary*)params;

//  Creates a new url request with the url, method, and data to send as JSON.
+(NSMutableURLRequest*)urlWithString:(NSString*)url andMethod:(NSString*)method andJSON:(NSDictionary*)json;
@end
