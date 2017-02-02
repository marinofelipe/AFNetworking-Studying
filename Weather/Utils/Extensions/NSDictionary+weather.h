//
//  NSDictionary+weather.h
//  Weather
//
//  Created by Scott on 26/01/2013.
//  Updated by Joshua Greene 16/12/2013.
//
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (weather)

- (NSNumber *)cloudCover;
- (NSNumber *)humidity;
- (NSDate *)observationTime;
- (NSNumber *)precipMM;
- (NSNumber *)pressue;
- (NSNumber *)tempCinSection:(NSUInteger)section;
- (NSNumber *)tempF;
- (NSNumber *)visibility;
- (NSNumber *)weatherCode;
- (NSString *)windDir16Point;
- (NSNumber *)windDirDegree;
- (NSNumber *)windSpeedKmph;
- (NSNumber *)windSpeedMiles;
- (NSString *)weatherDescriptionInSection:(NSUInteger)section;
- (NSString *)weatherIconURLInSection:(NSUInteger)section;
- (NSDate *)date;
- (NSNumber *)tempMaxCinSection:(NSUInteger)section;
- (NSNumber *)tempMaxF;
- (NSNumber *)tempMinCinSection:(NSUInteger)section;
- (NSNumber *)tempMinF;

@end
