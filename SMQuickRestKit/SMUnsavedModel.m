//
//  SMUnsavedModel.m
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import "SMUnsavedModel.h"
#import "SMQuickObjectMapper.h"

@implementation SMUnsavedModel
+(RKObjectMapping *) mapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    return mapping;
}

+(RKObjectMapping *) mappingForBaseurl:(NSString *)baseurl  {
    RKObjectManager* objectManager = [SMQuickObjectMapper objectManagerWithBaseurl:baseurl];
    if (objectManager){
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
        [self setupMapping:mapping forBaseurl:baseurl];
        return mapping;
    }
    return nil;
}


+(id) mappingWithKeyPath:(NSString *)keypath forBaseurl:(NSString*)baseurl path:(NSString*) path{
    RKObjectManager* objectManager = [SMQuickObjectMapper objectManagerWithBaseurl:baseurl];
    path = [[path componentsSeparatedByString:@"?"] objectAtIndex:0];
    if (objectManager){
        RKObjectMapping *mapping = [self mappingForBaseurl:baseurl];
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:path keyPath:keypath statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [objectManager addResponseDescriptor: responseDescriptor];
        return mapping;
    }
    return nil;
}
+ (void) setupMapping: (RKObjectMapping*) mapping forBaseurl:(NSString *)baseurl {
    //Override and configure
}



@end
