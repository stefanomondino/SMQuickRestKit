//
//  NSObject+SMQuickDownload.m
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NSObject+SMQuickDownload.h"
#import <objc/runtime.h>
#import <RestKit.h>
#import "SMQuickObjectMapper.h"
#define kSMOperationDictionaryKey @"kSMOperationDictionaryKey"
#define kSMAssociatedRequestingObject @"kSMAssociatedRequestingObject"
#import <RKObjectManager.h>
@interface NSObject(SMPrivateQuickDownload)
@property (nonatomic,strong) NSMutableDictionary* operationDictionary;
@end

@implementation NSObject (SMQuickDownload)


- (void) setOperationDictionary:(NSMutableDictionary *)operationDictionary {
    objc_setAssociatedObject([[UIApplication sharedApplication] delegate], kSMOperationDictionaryKey, operationDictionary,OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)operationDictionary {
    NSMutableDictionary* d = objc_getAssociatedObject([[UIApplication sharedApplication] delegate], kSMOperationDictionaryKey);
    if (!d){
        d =[NSMutableDictionary dictionary] ;
        [self setOperationDictionary:d];
        
    }
    return d;
    
}

- (void) downloadDataWithObjectRequest:(SMObjectRequest*) objectRequest {
    
    RKObjectManager *objectManager = [SMQuickObjectMapper objectManagerWithBaseurl:objectRequest.baseurl];
    
    if (!objectManager) return;
    
    if (objectRequest.shouldShowLoader){
        [self showLoadingView ];
    }
    __weak NSObject* weakSelf = self;
    void (^success)(RKObjectRequestOperation *, RKMappingResult*) = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //        [self.operationArray removeObject:operation];
        [weakSelf.operationDictionary removeObjectForKey:[NSString stringWithFormat:@"%p",operation]];
        objc_setAssociatedObject(operation, kSMAssociatedRequestingObject, nil, OBJC_ASSOCIATION_RETAIN);
        if (objectRequest.shouldShowLoader){
            [weakSelf hideLoadingView];
        }
        [weakSelf downloadDidCompleteWithMappingResults:[mappingResult array] objectRequest:objectRequest];
    };
    void (^failure)(RKObjectRequestOperation*, NSError*) = ^(RKObjectRequestOperation *operation, NSError *error) {
        objc_setAssociatedObject(operation, kSMAssociatedRequestingObject, nil, OBJC_ASSOCIATION_RETAIN);
        //[self.operationArray removeObject:operation];
        [weakSelf.operationDictionary removeObjectForKey:operation];
        if (objectRequest.shouldShowLoader){
            [weakSelf hideLoadingView];
        }
        [weakSelf downloadDidFailWithError:error objectRequest:objectRequest];
    };
    RKObjectRequestOperation* __weak operation;
    if (objectRequest.multipartDataDictionary) {
        NSURLRequest* request = [objectManager multipartFormRequestWithObject:nil method:(objectRequest.method == SM_GET?RKRequestMethodGET :RKRequestMethodPOST) path:objectRequest.path parameters:objectRequest.parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
           [formData appendPartWithFormData:objectRequest.multipartDataDictionary[@"data"] name:objectRequest.multipartDataDictionary[@"name"]] ;
        }];
        if (objectRequest.isManaged){
           operation =  [objectManager managedObjectRequestOperationWithRequest:request managedObjectContext: objectManager.managedObjectStore.mainQueueManagedObjectContext success:nil failure:nil];
        }
        else {
            operation = [objectManager objectRequestOperationWithRequest:request success:nil failure:nil];
        }
        
    }
    else {
        operation = [objectManager appropriateObjectRequestOperationWithObject:nil method:(objectRequest.method == SM_GET?RKRequestMethodGET :RKRequestMethodPOST) path: objectRequest.path parameters:objectRequest.parameters];
    }
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [operation.HTTPRequestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //if (self.operationDictionary[operation] == nil) {
        if (totalBytesExpectedToRead<0) return;
        [weakSelf.operationDictionary setValue:@{@"read":@(totalBytesRead),@"total":@(totalBytesExpectedToRead)} forKey:[NSString stringWithFormat:@"%p",operation]];
        //}
        __block long long total = 0;
        __block long long read = 0;
        [weakSelf.operationDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            total+= [obj[@"total"] longLongValue];
            read+= [obj[@"read"] longLongValue];
        }];
        CGFloat perc = MIN(((CGFloat)read/(CGFloat)total),1);
        [weakSelf downloadDidProgressWithPercentage:perc];
    }];
    objc_setAssociatedObject(operation,kSMAssociatedRequestingObject, self, OBJC_ASSOCIATION_RETAIN);
    [objectManager enqueueObjectRequestOperation:operation];
    
}

- (void) downloadDidProgressWithPercentage:(CGFloat) percentage {
}

- (void) downloadDidCompleteWithMappingResults: (NSArray*) mappingResults objectRequest:(SMObjectRequest*) objectRequest {
}
- (void) downloadDidFailWithError: (NSError*) error objectRequest:(SMObjectRequest*) objectRequest {
}

- (void) showLoadingView {
}
- (void) hideLoadingView {
}

@end
