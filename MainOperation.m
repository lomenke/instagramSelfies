//
//  MainOperation.m
//  PhotoTag
//
//  Created by LHM on 10/27/14.
//  Copyright (c) 2014 LP&E. All rights reserved.
//

#import "MainOperation.h"

@implementation MainOperation

// Set with low resolution.
- (void) main
{
    [self.selfie setImgLowRes:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.selfie.strURLLowRes]]]];
    
    // Just return for now.
    if (self.isCancelled)
    {
        return;
    }
    
    // Now a asynchronize dispatch a call to the main queue.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionCell setBackgroundView:[[UIImageView alloc]initWithImage:self.selfie.imgLowRes]];
        
        // Perform the animations then return alpha to 1.
        double timeDuration = 0.25f;
        double alphaFull    = 1.0f;
        [UIView animateWithDuration:timeDuration animations:^{
            self.collectionCell.alpha = alphaFull;
        }];
    });
}

@end
