//
//  FMNetworking.m
//  Weather
//
//  Created by Felipe Lefèvre Marino on 1/28/17.
//  Copyright © 2017 Scott Sherwood. All rights reserved.
//

#import "FMNetworkingManager.h"

@implementation FMNetworkingManager


#pragma mark - GET with serializer as JSON or PLIST
- (void)managerDoGetForUrl:(NSURL *)url dataType:(NSString *)dataType
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if ([dataType isEqualToString:@"plist"])
        manager.responseSerializer = [AFPropertyListResponseSerializer serializer];
    
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.delegate requestSucess:(NSDictionary *)responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.delegate requestFailure:error];
    }];
}

#pragma mark - GET with return as XML

@end
