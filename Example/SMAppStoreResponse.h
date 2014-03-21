//
//  SMAppStoreResponse.h
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 21/03/14.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import "SMUnsavedModel.h"

@interface SMAppStoreResponse : SMUnsavedModel
@property (nonatomic,strong) NSArray* movies;
@property (nonatomic,strong) NSNumber* resultCount;
@end
