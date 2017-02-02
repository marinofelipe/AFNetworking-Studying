//
//  FMNetworking.h
//  Weather
//
//  Created by Felipe Lefèvre Marino on 1/28/17.
//  Copyright © 2017 Scott Sherwood. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FMNetworkingDelegate <NSObject>

@optional
- (void)requestSucess:(id) responseObject;
- (void)requestFailure:(NSError *) error;
- (void)requestSucessWithXMLResponse:(id) responseObject;

@end

@interface FMNetworkingManager : NSObject

@property(nonatomic,weak) id <FMNetworkingDelegate> delegate;

- (void)managerDoGetForUrl:(NSURL *)url dataType:(NSString *)dataType;
- (void)managerDoGetReturningResponseAsXMLforUrl:(NSURL *)url;

@end
