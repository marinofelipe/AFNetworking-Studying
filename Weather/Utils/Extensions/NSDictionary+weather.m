//
//  NSDictionary+weather.m
//  Weather
//
//  Created by Scott on 26/01/2013.
//  Updated by Joshua Greene 16/12/2013.
//
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//

#import "NSDictionary+weather.h"

@implementation NSDictionary (weather)

- (NSNumber *)cloudCover
{
    NSString *cc = self[@"cloudcover"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)humidity
{
    NSString *cc = self[@"humidity"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSDate *)observationTime
{
//    NSString *cc = [self currentWeather][@"observation_time"];
    NSDate *n = [NSDate date]; // parse instead "09:07 PM";
    return n;
}

- (NSNumber *)precipMM
{
    NSString *cc = self[@"precipMM"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)pressue
{
    NSString *cc = self[@"pressure"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)tempCinSection:(NSUInteger)section
{
    NSNumber *n;
    
    if (section == 0) {
        NSString *cc = self[@"temp_C"];
        n = @([cc intValue]);
    }
    else {
        NSArray *hourly = self[@"hourly"];
        NSDictionary *hr = hourly[0];
        NSString *cc = hr[@"tempC"];
        n = @([cc intValue]);
    }
    
    
    return n;
}

- (NSNumber *)tempF
{
    NSString *cc = self[@"temp_F"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)visibility
{
    NSString *cc = self[@"visibility"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)weatherCode
{
    NSString *cc = self[@"weatherCode"];
    NSNumber *n = @([cc intValue]);
    return n;
}

-(NSString *)windDir16Point
{
    return self[@"winddir16Point"];
}

- (NSNumber *)windDirDegree
{
    NSString *cc = self[@"winddirDegree"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)windSpeedKmph
{
    NSString *cc = self[@"windspeedKmph"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)windSpeedMiles
{
    NSString *cc = self[@"windspeedMiles"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSString *)weatherDescriptionInSection:(NSUInteger)section
{
    NSDictionary *dict;
    
    //current weather
    if (section == 0) {
        NSArray *ar = self[@"weatherDesc"];
        dict = ar[0];
    }
    //upcoming weather
    else {
        NSArray *hourly = self[@"hourly"];
        NSDictionary *hr = hourly[0];
        NSArray *ar = hr[@"weatherDesc"];
        dict = ar[0];
    }
    
    return dict[@"value"];
}

- (NSString *)weatherIconURLInSection:(NSUInteger)section
{
    NSDictionary *dict;
    
    //curent weather
    if (section == 0) {
        NSArray *ar = self[@"weatherIconUrl"];
        dict = ar[0];
    }
    //upcoming weather
    else {
        NSArray *hourly = self[@"hourly"];
        NSDictionary *hr = hourly[0];
        NSArray *ar = hr[@"weatherIconUrl"];
        dict = ar[0];
    }
    
    return dict[@"value"];
}

- (NSDate *)date
{
//    NSString *dateStr = self[@"date"]; // date = "2013-01-15";
    return [NSDate date];
}

- (NSNumber *)tempMaxCinSection:(NSUInteger)section
{
    NSNumber *n;
    
    if (section == 0) {
        NSString *cc = self[@"tempMaxC"];
        n = @([cc intValue]);
    }
    else {
        NSArray *hourly = self[@"hourly"];
        NSDictionary *hr = hourly[0];
        NSString *cc = hr[@"tempMaxC"];
        n = @([cc intValue]);

    }
    
    return n;
}

- (NSNumber *)tempMaxF
{
    NSString *cc = self[@"tempMaxF"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)tempMinCinSection:(NSUInteger)section
{
    NSNumber *n;
    
    if (section == 0) {
        NSString *cc = self[@"tempMinC"];
        n = @([cc intValue]);
    }
    else {
        NSArray *hourly = self[@"hourly"];
        NSDictionary *hr = hourly[0];
        NSString *cc = hr[@"tempMinC"];
        n = @([cc intValue]);
    }
    
    return n;
}

- (NSNumber *)tempMinF
{
    NSString *cc = self[@"tempMinF"];
    NSNumber *n = @([cc intValue]);
    return n;
}

@end
