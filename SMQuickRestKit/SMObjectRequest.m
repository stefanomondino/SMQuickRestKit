//
//  SMObjectRequest.m
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import "SMObjectRequest.h"

@implementation SMObjectRequest

+ (SMObjectRequest*) objectRequestWithBaseurl:(NSString*) baseurl path:(NSString*) path parameters:(NSDictionary*) parameters method:(SMHTTPMETHOD) method {
    SMObjectRequest* objectRequest = [[self alloc] init];
    objectRequest.baseurl = baseurl;
    objectRequest.path = path;
    objectRequest.parameters = parameters;
    objectRequest.method = method;
    objectRequest.shouldShowLoader = YES;
    return objectRequest;
}

+ (SMObjectRequest*) objectRequestWithBaseurl:(NSString*) baseurl path:(NSString*) path parameters:(NSDictionary*) parameters method:(SMHTTPMETHOD) method shouldShowLoader:(BOOL) shouldShowLoader{
    SMObjectRequest* objectRequest = [self objectRequestWithBaseurl:baseurl path:path parameters:parameters method:method];
    objectRequest.shouldShowLoader = shouldShowLoader;
    return objectRequest;
}

@end
