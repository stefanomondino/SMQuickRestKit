//
//  SMUnsavedModel.h
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit.h>
@interface SMUnsavedModel : NSObject
+ (void) setupMapping: (RKObjectMapping*) mapping forBaseurl:(NSString *)baseurl;
+(id) mappingWithKeyPath:(NSString *)keypath forBaseurl:(NSString*)baseurl path:(NSString*) path;
@end
