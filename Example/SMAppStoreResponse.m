//
//  SMAppStoreResponse.m
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 21/03/14.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import "SMAppStoreResponse.h"
#import "SMAppStoreModel.h"
@implementation SMAppStoreResponse
+ (void)setupMapping:(RKEntityMapping *)mapping forBaseurl:(NSString *)baseurl {
 [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"results" toKeyPath:@"movies" withMapping:[SMAppStoreModel mappingForBaseurl:baseurl]]];
    [mapping addAttributeMappingsFromArray:@[@"resultCount"]];
}
@end
