//
//  NSObject+SMQuickDownload.h
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMObjectRequest.h"
@interface NSObject (SMQuickDownload)
- (void) downloadDataWithObjectRequest:(SMObjectRequest*) objectRequest;

- (void) downloadDidProgressWithPercentage:(CGFloat) percentage;
- (void) downloadDidCompleteWithMappingResults: (NSArray*) mappingResults objectRequest:(SMObjectRequest*) objectRequest;
- (void) downloadDidFailWithError: (NSError*) error objectRequest:(SMObjectRequest*) objectRequest;
- (void) showLoadingView;
- (void) hideLoadingView;
@end
