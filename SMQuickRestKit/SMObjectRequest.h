//
//  SMObjectRequest.h
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SM_GET,
    SM_POST,
    SM_PUT,
    SM_DELETE
} SMHTTPMETHOD;

@interface SMObjectRequest : NSObject

@property (nonatomic,strong) NSString* baseurl;
@property (nonatomic,strong) NSString* path;
@property (nonatomic,strong) NSDictionary* parameters;
@property (nonatomic,assign) BOOL shouldShowLoader;
@property (assign) SMHTTPMETHOD method;

+ (SMObjectRequest*) objectRequestWithBaseurl:(NSString*) baseurl path:(NSString*) path parameters:(NSDictionary*) parameters method:(SMHTTPMETHOD) method ;
+ (SMObjectRequest*) objectRequestWithBaseurl:(NSString*) baseurl path:(NSString*) path parameters:(NSDictionary*) parameters method:(SMHTTPMETHOD) method shouldShowLoader:(BOOL) shouldShowLoader;

@end
