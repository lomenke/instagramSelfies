//
//  MainOperation.h
//  PhotoTag
//
//  Created by LHM on 10/27/14.
//  Copyright (c) 2014 LP&E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDetails.h"

@interface MainOperation : NSOperation

@property (weak, nonatomic) NSIndexPath          *indexPath;        // Indcies.
@property (weak, nonatomic) UICollectionViewCell *collectionCell;   // Working image cell.

@property (weak, nonatomic) ImageDetails         *selfie;           // A selfie.

@end
