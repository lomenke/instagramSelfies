//
//  WebConnection.h
//  PhotoTag
//
//  Created by LHM on 10/27/14.
//  Copyright (c) 2014 LP&E. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebConnectionDelegate <NSObject>
- (void) webConnectionSuccess:(NSData *)  responseData;
- (void) webConnectionFailure:(NSError *) error;
@end

@interface WebConnection : NSObject

@property (weak, nonatomic) id delegate;

// Start web connection using URL.
- (void) startWebConnectionURL:(NSURL *) url;

@end
