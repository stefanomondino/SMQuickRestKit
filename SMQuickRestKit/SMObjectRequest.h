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

#define kMultipartData @"kMultipartData"
#define kMultipartName @"kMultipartName"
#define kMultipartFilename @"kMultipartFilename"
#define kMultipartMIMEType @"kMultipartMIMEType"

@interface SMObjectRequest : NSObject

@property (nonatomic,strong) NSString* baseurl;
@property (nonatomic,strong) NSString* path;
@property (nonatomic,strong) NSDictionary* parameters;
@property (nonatomic,assign) BOOL shouldShowLoader;
@property (nonatomic,assign) BOOL isManaged;
@property (nonatomic,strong) NSDictionary* multipartDataDictionary;
@property (assign) SMHTTPMETHOD method;

+ (SMObjectRequest*) objectRequestWithBaseurl:(NSString*) baseurl path:(NSString*) path parameters:(NSDictionary*) parameters method:(SMHTTPMETHOD) method ;
+ (SMObjectRequest*) objectRequestWithBaseurl:(NSString*) baseurl path:(NSString*) path parameters:(NSDictionary*) parameters method:(SMHTTPMETHOD) method shouldShowLoader:(BOOL) shouldShowLoader;
+ (SMObjectRequest*) objectRequestWithBaseurl:(NSString*) baseurl path:(NSString*) path parameters:(NSDictionary*) parameters method:(SMHTTPMETHOD) method shouldShowLoader:(BOOL) shouldShowLoader multipartDataDictionary:(NSDictionary*) multipartDataDictionary isManaged:(BOOL) isManaged;
@end
