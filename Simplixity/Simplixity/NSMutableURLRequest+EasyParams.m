//
//  NSMutableURLRequest+EasyParams.m
//  Simplixity
//
//  Created by Donald Ritter on 9/20/14.
//  Copyright (c) 2014 Simplixity. All rights reserved.
//

#import "NSMutableURLRequest+EasyParams.h"

@implementation NSMutableURLRequest (EasyParams)
+(NSMutableURLRequest*)urlWithString:(NSString*)url andMethod:(NSString*)method andParams:(NSDictionary*)params {
    method = [method uppercaseString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:method];
    
    if (params) {
        NSMutableString *body = [[NSMutableString alloc] init];
        NSString *value;
        
        for (NSString *key in [params allKeys]) {
            value = [params objectForKey:key];
            
            if (key && value) {
                [body appendFormat:@"&%@=%@", key, [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        NSArray *methodsWithURLParams = [NSArray arrayWithObjects:@"get", @"head", nil];
        
        if ([methodsWithURLParams indexOfObject:method] != NSNotFound) {
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", url, body]]];
        }
        else {
            NSData *postData = [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody:postData];
        }
    }
    
    return request;
}

+(NSMutableURLRequest*)urlWithString:(NSString*)url andMethod:(NSString*)method andJSON:(NSDictionary*)json {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:method];
    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&jsonError];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:jsonData];
    
    return request;
}
@end
