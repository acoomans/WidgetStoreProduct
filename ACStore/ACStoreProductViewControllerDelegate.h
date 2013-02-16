//
//  ACStoreProductViewControllerDelegate.h
//  ACStoreExample
//
//  Created by Arnaud Coomans on 15/02/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACStoreProductViewController;

@protocol ACStoreProductViewControllerDelegate <NSObject>
@optional
- (void)productViewControllerDidFinish:(ACStoreProductViewController *)viewController;
@end
