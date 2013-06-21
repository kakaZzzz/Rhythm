//
//  BTConfigs.h
//  SmartBat
//
//  Created by kaka' on 13-6-4.
//  Copyright (c) 2013年 kaka'. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTAppDelegate.h"
#import "BTEntity.h"
#import "BTConstants.h"

@interface BTGlobals : NSObject{
    NSManagedObjectContext* _context;
    BTEntity* _globalsInEntity;
}

//这里是全局变量
@property(assign, nonatomic) int beatPerMinute;
@property(assign, nonatomic) int beatPerMeasure;
@property(assign, nonatomic) float noteType;
@property(assign, nonatomic) int subdivision;
@property(assign, nonatomic) int lastCheckVersionDate;
@property(assign, nonatomic) int installDate;
@property(assign, nonatomic) int hasAskGrade;

@property(assign, nonatomic) int currentMeasureDuration;
@property(assign, nonatomic) int currentNoteDuration;
@property(assign, nonatomic) int currentSubdivisionDuration;


+(BTGlobals*)sharedGlobals;
-(void)applicationWillResignActive:(NSNotification*) notification;

@end
