//
//  SMQuickObjectMapper.m
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 25/10/13.
//  Copyright (c) 2013 Stefano Mondino. All rights reserved.
//

#import "SMQuickObjectMapper.h"
#import "SMArrayValueTransformer.h"
#import <CoreData+MagicalRecord.h>
#import "SMArrayValueTransformer.h"
//#import "RKXMLReaderSerialization.h"

//Thanks to airdrummingfool for this tip!
@interface NSManagedObjectContext (Private)

+ (void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc;

@end

@interface SMQuickObjectMapper()
@property (nonatomic,strong) NSMutableDictionary* objectManagers;
@end
@implementation SMQuickObjectMapper

static SMQuickObjectMapper* sharedMapper = nil;
+ (SMQuickObjectMapper *)sharedObjectMapper{
    if (sharedMapper == nil){
        sharedMapper = [[SMQuickObjectMapper alloc] init];
        sharedMapper.objectManagers = [NSMutableDictionary dictionary];
    }
    return sharedMapper;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized (self)
    {
        if (sharedMapper== nil) {
            sharedMapper = [super allocWithZone:zone];
            return sharedMapper;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (NSDictionary*) allObjectManagers {
    return self.objectManagers;
}

+ (RKObjectManager*) objectManagerWithBaseurl:(NSString*) baseurl {
    
    if (!baseurl) return nil;
    return [[[self sharedObjectMapper] allObjectManagers] objectForKey:baseurl];
    
}
+ (AFHTTPClient*) initWithBaseurl:(NSString*) baseurl shouldUseCoreData:(BOOL) shouldUseCoreData; {
    return [self initWithURL:[NSURL URLWithString:baseurl] shouldUseCoreData:shouldUseCoreData];
}
+ (AFHTTPClient*) initWithURL:(NSURL *)baseurl shouldUseCoreData:(BOOL)shouldUseCoreData{
    /* Initialize RestKit framework */
    
    if ([self objectManagerWithBaseurl:[baseurl absoluteString]]) {
        return [[self objectManagerWithBaseurl:[baseurl absoluteString] ] HTTPClient];
    }
                
    RKObjectManager * objectManager = [self objectManagerWithBaseurl:[baseurl absoluteString]];
    NSURL *baseURL = baseurl;
    if (objectManager){
        [[objectManager operationQueue] cancelAllOperations];
    }
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    [[self sharedObjectMapper].objectManagers setObject:objectManager forKey:[baseurl absoluteString]];
    [client setDefaultHeader:@"Accept" value: RKMIMETypeJSON];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    if (shouldUseCoreData){
        [MagicalRecord setupAutoMigratingCoreDataStack];
        RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithPersistentStoreCoordinator:[NSPersistentStoreCoordinator MR_newPersistentStoreCoordinator]];
        objectManager.managedObjectStore = managedObjectStore;
        [managedObjectStore createManagedObjectContexts];
        
        [NSManagedObjectContext MR_setRootSavingContext: managedObjectStore.persistentStoreManagedObjectContext];
        [NSManagedObjectContext MR_setDefaultContext: managedObjectStore.mainQueueManagedObjectContext];

        [NSValueTransformer setValueTransformer:[[SMArrayValueTransformer alloc] init] forName:@"SMArrayValueTransformer"];
    }

    return client;
}

+ (void) registerClass:(Class) class forMIMEType:(id)MIMETypeStringOrRegularExpression {
    [RKMIMETypeSerialization registerClass:class forMIMEType:MIMETypeStringOrRegularExpression];
}
@end

