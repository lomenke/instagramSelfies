//
//  CollectionViewController.h
//  PhotoTag
//
//  Created by LHM on 10/27/14.
//  Copyright (c) 2014 LP&E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebConnection.h"
#import "JSONParsing.h"
#import "ImageDetails.h"

// Add the new delegates created for web connection and JSON parsing.
@interface CollectionViewController : UICollectionViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,WebConnectionDelegate, JSONParsingDelegate>

@property (strong, nonatomic) NSString                  *hashTagStr;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
