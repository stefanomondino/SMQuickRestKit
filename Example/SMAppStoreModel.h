//
//  SMAppStoreModel.h
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import "SMSavedModel.h"

@interface SMAppStoreModel : SMSavedModel
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* artworkUrl;
@property (nonatomic,strong) NSString* genre;
@end
