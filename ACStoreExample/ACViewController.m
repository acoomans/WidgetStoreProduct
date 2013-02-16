//
//  ACViewController.m
//  ACStoreExample
//
//  Created by Arnaud Coomans on 15/02/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "ACViewController.h"

@interface ACViewController ()
@end

@implementation ACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (IBAction)buttonTapped:(id)sender {
	
	NSString *productIdentifier = @"543013018";		// software
	//NSString *productIdentifier = @"560398387";		// album
	//NSString *productIdentifier = @"475526561";		// ebook
	//NSString *productIdentifier = @"183240799";		// tv show
	//NSString *productIdentifier = @"286334988";		// movie
	//NSString *productIdentifier = @"497799835";		// mac software
	
	ACStoreProductViewController *storeProductViewController = [[ACStoreProductViewController alloc] init];
	storeProductViewController.affiliateIdentifier = @"2141033";
	storeProductViewController.partnerIdentifier = @"24379";
	storeProductViewController.delegate = self;
	
	[self presentViewController:storeProductViewController animated:YES completion:^{
		NSDictionary *parameters = @{ACStoreProductParameterITunesItemIdentifier:productIdentifier};
		[storeProductViewController loadProductWithParameters:parameters completionBlock:^(BOOL result, NSError *error) {
		}];
	}];
}

#pragma mark - ACStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(ACStoreProductViewController *)viewController {
	NSLog(@"productViewControllerDidFinish");
}

@end
