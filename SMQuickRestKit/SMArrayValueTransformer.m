//
//  SMQuickObjectMapper.m
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//


#import "SMArrayValueTransformer.h"



@implementation SMArrayValueTransformer

+ (BOOL) allowsReverseTransformation {
    return YES;
}

+ (Class) transformedValueClass {
    return [NSData class];
}

- (id) transformedValue:(id)value {
    if( !value )
        return nil;
    
    if( [value isKindOfClass: [NSData class]] )
        return value;
    
    return [NSKeyedArchiver archivedDataWithRootObject: value];
}

- (id) reverseTransformedValue:(id)value {
    return [[NSKeyedUnarchiver unarchiveObjectWithData: value] mutableCopy];
}

@end
