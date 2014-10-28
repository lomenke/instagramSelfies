//
//  CollectionViewController.m
//  PhotoTag
//
//  Created by LHM on 10/27/14.
//  Copyright (c) 2014 LP&E. All rights reserved.
//

#import "CollectionViewController.h"
#import "MainOperation.h"
#import "ImageDetails.h"

@interface CollectionViewController ()
@property (strong, nonatomic) NSArray          *arrayCollection;    // Store processed data into array for display.
@property (strong, nonatomic) WebConnection    *myWebConnection;    // Web connection class and methods.
@property (strong, nonatomic) JSONParsing      *myJSONParser;       // JSON parser class and methods.
@property (strong, nonatomic) NSURL            *currentURL;         // Current URL.
@property (strong, nonatomic) NSOperationQueue *imageQueue;         // Image from operation queue.
@property BOOL                                  isFetchingData;     // Set to allow for next download trigger from cellForItemAtIndexpath.
@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    // Initialize operation queue, data array, and web connection.
    _imageQueue      = [[NSOperationQueue alloc] init];
    _arrayCollection = [[NSArray alloc] init];
    _myWebConnection = [[WebConnection alloc] init];
    
    // Set delegate.
    [_myWebConnection setDelegate:self];

    // Set URL and the web connection.
    NSString *clientIDStr        = @"e178eb183d2249f0bad6330f04ec9619";
    NSString *instagramStr1      = [@"https://api.instagram.com/v1/tags/" stringByAppendingString:_hashTagStr];
    NSString *instagramStr2      = [instagramStr1 stringByAppendingString:@"/media/recent?client_id="];
    NSString *instagramUserIDStr = [instagramStr2 stringByAppendingString:clientIDStr];
    _currentURL                  = [NSURL URLWithString:instagramUserIDStr];
    [_myWebConnection startWebConnectionURL:_currentURL];

    // Set JASON delegate.
    _myJSONParser    = [[JSONParsing alloc] init];
    [_myJSONParser setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

// One section as usual.
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// Size of array collection.
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self.arrayCollection count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Start web connection URL and set the fetching data logical.
    if ((indexPath.row / (float)_arrayCollection.count) >= 0.75f && !_isFetchingData)
    {
        [_myWebConnection startWebConnectionURL:_currentURL];
        _isFetchingData = YES;
    }
    
    // Define the cell for the collection view for a given index value.
    UICollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    ImageDetails *currentSelfie = [_arrayCollection objectAtIndex:indexPath.row];
    cell.alpha                  = 0;
    
    // If low resolution.
    if (currentSelfie.imgLowRes)
    {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:currentSelfie.imgLowRes];
        [cell setBackgroundView:imgView];
        cell.alpha           = 1.0f;
    }
    // Otherwise
    else
    {
        MainOperation *myOperation = [[MainOperation alloc] init];
        [myOperation setSelfie:currentSelfie];
        [myOperation setIndexPath:indexPath];
        [myOperation setCollectionCell:cell];
        
        [_imageQueue addOperation:myOperation];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

// Fitting the images into the collection view.
- (CGSize) collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
   sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int largeImage = 300;
    int smallImage = 145;
    if (indexPath.row % 3 == 0)
    {
        return CGSizeMake(largeImage, largeImage);
    }
    else
    {
        return CGSizeMake(smallImage, smallImage);
    }
}

// End of cell.
-(void)collectionView:(UICollectionView *)collectionView
 didEndDisplayingCell:(UICollectionViewCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (MainOperation *checkOperation in [_imageQueue operations])
    {
        if (checkOperation.indexPath == indexPath)
        {
            [checkOperation cancel];
        }
    }
}


#pragma mark - Web Connection Delegate Methods
-(void) webConnectionSuccess:(NSData *) responseData
{
    [_myJSONParser startJSONParsing:responseData];
}

-(void) webConnectionFailure:(NSError *)error
{
    NSLog(@"Web connection failure delegate operation");
}


#pragma mark - JSON Parsing Delegate Methods
-(void) jsonParseSuccess:(NSMutableArray *) parsedObjects
{
    _currentURL      = [parsedObjects lastObject];
    [parsedObjects removeLastObject];
    _arrayCollection = [_arrayCollection arrayByAddingObjectsFromArray:[parsedObjects copy]];
    [self.collectionView reloadData];
    _isFetchingData  = NO;
}

-(void) jsonParseFailure:(NSError *)parseError
{
    NSLog(@"JSON parsing failure delegate operation");
}

@end

