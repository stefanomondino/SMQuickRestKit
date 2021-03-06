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
#import <CoreData.h>
#import <RestKit.h>
#import "SMQuickObjectMapper.h"
#define kSMOperationDictionaryKey @"kSMOperationDictionaryKey"
#define kSMAssociatedRequestingObject @"kSMAssociatedRequestingObject"


#import <RKObjectManager.h>
@interface NSObject(SMPrivateQuickDownload)
@property (nonatomic,strong) NSMutableDictionary* operationDictionary;
@property (nonatomic,strong) NSMutableArray* simultaneousOperationQueue;
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

- (RKObjectRequestOperation*) downloadDataWithObjectRequest:(SMObjectRequest*) objectRequest {
    return [self downloadDataWithObjectRequest:objectRequest isSimultaneous:NO];
}
- (RKObjectRequestOperation*) downloadDataWithObjectRequest:(SMObjectRequest*) objectRequest isSimultaneous:(BOOL) isSimultaneous {
    
    RKObjectManager *objectManager = [SMQuickObjectMapper objectManagerWithBaseurl:objectRequest.baseurl];
    
    if (!objectManager) return nil;
    
    if (isSimultaneous) {
        [self showSimultaneousLoadingView];
    }
    else {
        if (objectRequest.shouldShowLoader){
            [self showLoadingView ];
        }
    }
    __weak NSObject* weakSelf = self;
    void (^success)(RKObjectRequestOperation *, RKMappingResult*) = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            //        [self.operationArray removeObject:operation];
            [weakSelf.operationDictionary removeObjectForKey:[NSString stringWithFormat:@"%p",operation]];
            objc_setAssociatedObject(operation, kSMAssociatedRequestingObject, nil, OBJC_ASSOCIATION_RETAIN);
            
            if (objectRequest.shouldShowLoader && !isSimultaneous){
                [weakSelf hideLoadingView];
            }
            
            [weakSelf downloadDidCompleteWithMappingResults:[mappingResult array] objectRequest:objectRequest];
            
            if ([weakSelf.operationDictionary allKeys].count == 0 && isSimultaneous) {
                [self simultaneousDownloadsDidComplete];
                [self hideSimultaneousLoadingView];
            }
        });
    };
    void (^failure)(RKObjectRequestOperation*, NSError*) = ^(RKObjectRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            objc_setAssociatedObject(operation, kSMAssociatedRequestingObject, nil, OBJC_ASSOCIATION_RETAIN);
            //[self.operationArray removeObject:operation];
            [weakSelf.operationDictionary removeObjectForKey:[NSString stringWithFormat:@"%p",operation]];
            if (objectRequest.shouldShowLoader && !isSimultaneous){
                [weakSelf hideLoadingView];
            }
            if (operation.HTTPRequestOperation.isCancelled) {
                [weakSelf downloadDidCancelWithObjectRequest:objectRequest];
            }
            [weakSelf downloadDidFailWithError:error objectRequest:objectRequest];
            
            if ([weakSelf.operationDictionary allKeys].count == 0) {
                [self simultaneousDownloadsDidComplete];
                [self hideSimultaneousLoadingView];
            }
        });
    };
    RKObjectRequestOperation* __weak operation;
    if (objectRequest.multipartDataDictionary) {
        NSURLRequest* request = [objectManager multipartFormRequestWithObject:nil method:(objectRequest.method == SM_GET?RKRequestMethodGET :RKRequestMethodPOST) path:objectRequest.path parameters:objectRequest.parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:objectRequest.multipartDataDictionary[kMultipartData] name:objectRequest.multipartDataDictionary[kMultipartName] fileName:objectRequest.multipartDataDictionary[kMultipartFilename] mimeType:objectRequest.multipartDataDictionary[kMultipartMIMEType]];
        }];
        if (objectRequest.isManaged){
            operation =  [objectManager managedObjectRequestOperationWithRequest:request managedObjectContext: objectManager.managedObjectStore.mainQueueManagedObjectContext success:nil failure:nil];
        }
        else {
            operation =     [objectManager objectRequestOperationWithRequest:request success:nil failure:nil];
        }
        
    }
    else {
        operation = [objectManager appropriateObjectRequestOperationWithObject:nil method:(objectRequest.method == SM_GET?RKRequestMethodGET :RKRequestMethodPOST) path: objectRequest.path parameters:objectRequest.parameters];
    }
    NSData* jsonParameters = [objectRequest valueForKey:@"serializedParameters"];
    if (jsonParameters) {
        NSMutableURLRequest* request =  (NSMutableURLRequest*) operation.HTTPRequestOperation.request;
        [request setHTTPBody:jsonParameters];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    [operation setCompletionBlockWithSuccess:success failure:failure];
    [operation.HTTPRequestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //if (self.operationDictionary[operation] == nil) {
        if (totalBytesExpectedToRead<0) return;
        [weakSelf.operationDictionary setValue:@{@"operation":operation,@"read":@(totalBytesRead),@"total":@(totalBytesExpectedToRead)} forKey:[NSString stringWithFormat:@"%p",operation]];
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
    [weakSelf.operationDictionary setValue:@{@"operation":operation,@"read":@(0),@"total":@(NSIntegerMax)} forKey:[NSString stringWithFormat:@"%p",operation]];
    [objectManager enqueueObjectRequestOperation:operation];
    return operation;
}

- (NSArray*) simultaneousDownloadsWithObjectRequests:(NSArray*) objectRequests {
    NSMutableArray* downloads = [NSMutableArray array];
    for (SMObjectRequest* request in objectRequests) {
        if ([request isKindOfClass:[SMObjectRequest class]]) {
            [downloads addObject:[self downloadDataWithObjectRequest:request isSimultaneous:YES] ];
        }
    }
    return downloads;
}

- (void) cancelAllDownloads {
    [self.operationDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        RKObjectRequestOperation* operation = obj[@"operation"];
        if (objc_getAssociatedObject(self, kSMAssociatedRequestingObject) == self) {
            [operation.HTTPRequestOperation cancel];
        }
    }];
}

- (void) downloadDidProgressWithPercentage:(CGFloat) percentage {
}

- (void) downloadDidCompleteWithMappingResults: (NSArray*) mappingResults objectRequest:(SMObjectRequest*) objectRequest {
}
- (void) downloadDidFailWithError: (NSError*) error objectRequest:(SMObjectRequest*) objectRequest {
}
- (void) downloadDidCancelWithObjectRequest:(SMObjectRequest*) objectRequest {
    
}
- (void) simultaneousDownloadsDidComplete {
    
}
- (void) showLoadingView {
}
- (void) hideLoadingView {
}
- (void) showSimultaneousLoadingView {
    
}
- (void) hideSimultaneousLoadingView {
    
}
@end
