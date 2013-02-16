//
//  ACStoreProductViewController.h
//  ACStoreExample
//
//  Created by Arnaud Coomans on 15/02/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "ACStoreProductViewControllerDelegate.h" // SKStoreProductViewControllerDelegate equivalent

extern NSString *const ACStoreProductParameterITunesItemIdentifier; // SKStoreProductParameterITunesItemIdentifier equivalent for iOS < 5

@interface ACStoreProductViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic, weak) id<ACStoreProductViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *affiliateIdentifier;
@property (nonatomic, strong) NSString *partnerIdentifier;


- (id)initWithAffiliate:(NSString*)affiliateIdentifier
				partner:(NSString*)partnerIdentifier
			   delegate:(id<SKStoreProductViewControllerDelegate>)delegate;

/* SKStoreProductViewController */
- (void)loadProductWithParameters:(NSDictionary *)parameters completionBlock:(void (^)(BOOL result, NSError *error))block;

@end
