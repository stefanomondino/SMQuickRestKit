//
//  SMQuickObjectMapper.h
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPClient.h>
#import <CoreData.h>
#import <RestKit.h>

@interface SMQuickObjectMapper : NSObject
+ (SMQuickObjectMapper *) sharedObjectMapper;
- (NSDictionary*) allObjectManagers;
+ (AFHTTPClient*) initWithBaseurl:(NSString*) baseurl shouldUseCoreData:(BOOL) shouldUseCoreData;
+ (void) registerClass:(Class) class forMIMEType:(id)MIMETypeStringOrRegularExpression;
+ (RKObjectManager*) objectManagerWithBaseurl:(NSString*) baseurl;
@end
