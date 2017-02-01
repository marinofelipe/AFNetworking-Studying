//
//  WeatherHTTPClient.m
//  Weather
//
//  Created by Felipe Marino on 2/1/17.
//  Copyright © 2017 Scott Sherwood. All rights reserved.
//

#import "WeatherHTTPClient.h"

static NSString * const kWorldWeatherOnlineAPIKey = @"b6e116eed6bb4cdf822134901170102";
static NSString * const kWorldWeatherOnlineURLString = @"http://api.worldweatheronline.com/free/v1/";

@implementation WeatherHTTPClient

+(WeatherHTTPClient *)sharedWeatherHTTPClient
{
    static WeatherHTTPClient *_sharedWeatherHTTPClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedWeatherHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kWorldWeatherOnlineURLString]];
    });
    
    return _sharedWeatherHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

@end
