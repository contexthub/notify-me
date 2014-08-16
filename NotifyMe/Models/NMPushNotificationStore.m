//
//  NMPushNotificationStore.m
//  NotifyMe
//
//  Created by Jeff Kibuule on 8/14/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "NMPushNotificationStore.h"

#import "NMConstants.h"

@interface NMPushNotificationStore ()
@end

@implementation NMPushNotificationStore

static NMPushNotificationStore * __instance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[NMPushNotificationStore alloc] init];
    });
    
    return __instance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // Load notifications from file
        _notifications = [self loadArray];
        
        return self;
    }
    
    return nil;
}

- (void)addNotification:(NMPushNotification *)notification {
    
    if (notification) {
        [self.notifications insertObject:notification atIndex:0];
        [self saveNotifications];
    }
}

- (void)deleteNotifications {
    [self.notifications removeAllObjects];
    [self saveNotifications];
}

// Saves notifications to a plist
- (void)saveNotifications {
    [self saveArray:self.notifications];
}

#pragma mark - Loading/saving data

// Gets the path to the app's Documents folder
- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return paths[0];
}

// Gets the path to the data file
- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:NMNotificationsFileName];
}

// Loads the array from the file or creates a new array if no file present
- (NSMutableArray *)loadArray
{
    NSMutableArray *array;
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        array = [unarchiver decodeObjectForKey:@"MY_ARRAY"];
        [unarchiver finishDecoding];
    } else {
        array = [[NSMutableArray alloc] init];
    }
    return array;
}

// Saves the array to a file
- (void)saveArray:(NSMutableArray *)array
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:array forKey:@"MY_ARRAY"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

@end