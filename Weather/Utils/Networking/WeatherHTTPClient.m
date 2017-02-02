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

+ (WeatherHTTPClient*)sharedWeatherHTTPClient
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
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

- (void)updateWeatherAtLocation:(CLLocation *)location forNumberOfDays:(NSUInteger)number
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"number_of_days"] = @(number);
    parameters[@"q"] = [NSString stringWithFormat:@"%f, %f", location.coordinate.latitude, location.coordinate.longitude];
    parameters[@"format"] = @"json";
    parameters[@"key"] = kWorldWeatherOnlineAPIKey;
    
    [self GET:@"weather.ashx" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([self.delegate respondsToSelector:@selector(weatherHTTPClient:didUpdateWithWeather:)]) {
            [self.delegate weatherHTTPClient:self didUpdateWithWeather:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if ([self.delegate respondsToSelector:@selector(weatherHTTPClient:didFailWithError:)]) {
            [self.delegate weatherHTTPClient:self didFailWithError:error];
        }
    }];
}

@end
