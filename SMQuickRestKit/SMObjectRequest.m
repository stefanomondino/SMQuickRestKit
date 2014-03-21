//
//  SMObjectRequest.m
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import "SMObjectRequest.h"
/**
 @deprecated
 */
@interface SMObjectRequest()
@property (nonatomic,strong) NSData*serializedParameters;
@end
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
+ (SMObjectRequest *)objectRequestWithBaseurl:(NSString *)baseurl path:(NSString *)path parameters:(NSDictionary *)parameters method:(SMHTTPMETHOD)method shouldShowLoader:(BOOL)shouldShowLoader {
    return [self objectRequestWithBaseurl:baseurl path:path parameters:parameters method:method shouldShowLoader:shouldShowLoader multipartDataDictionary:nil isManaged:NO];
}
+ (SMObjectRequest*) objectRequestWithBaseurl:(NSString*) baseurl path:(NSString*) path parameters:(NSDictionary*) parameters method:(SMHTTPMETHOD) method shouldShowLoader:(BOOL) shouldShowLoader multipartDataDictionary:(id)multipartDataDictionary isManaged:(BOOL) isManaged{
    SMObjectRequest* objectRequest = [self objectRequestWithBaseurl:baseurl path:path parameters:parameters method:method];
    objectRequest.shouldShowLoader = shouldShowLoader;
    objectRequest.multipartDataDictionary = multipartDataDictionary;
    return objectRequest;
}

- (void) setJsonParameters:(NSDictionary*) customParameters {
    
   self.serializedParameters = [NSJSONSerialization dataWithJSONObject:customParameters
                                                          options:NSJSONWritingPrettyPrinted
                                                            error:nil];
    
    //NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",jsonString);
}

@end
