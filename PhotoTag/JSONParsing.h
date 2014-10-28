//
//  JSONParsing.h
//  PhotoTag
//
//  Created by LHM on 10/27/14.
//  Copyright (c) 2014 LP&E. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSONParsingDelegate <NSObject>
- (void) jsonParseSuccess:(NSMutableArray *) parsedObjects;
- (void) jsonParseFailure:(NSError *)        parseError;
@end

@interface JSONParsing : NSObject

@property (weak, nonatomic) id delegate;

- (void) startJSONParsing:(NSData *) webData;

@end

