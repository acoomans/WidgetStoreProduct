# ACStore

## Description

[SKStoreProductViewController](http://developer.apple.com/library/ios/#documentation/StoreKit/Reference/SKITunesProductViewController_Ref/Introduction/Introduction.html) is a view controller from Apple's StoreKit framework. It lets you display an iTunes product in your app, lets the user preview/prelisten it and buy it on iTunes. 

The problem is _SKStoreProductViewController_ doesn't take affiliate links. Official answer from Apple is it's not supported nor planned; you're on your own.

_ACStoreProductViewController_ is an attempt to use [iTunes' widgets](http://widgets.itunes.apple.com/builder/) to replace _SKStoreProductViewController_ , being compatible with iOS5 and accepting affiliate links.

*Warning* : This should be seen as an experiment and I wouldn't advice using it in production code.

At this stage, overall experience isn't great. iTunes product is shown (poorly in HTML, not native). When selected, iOS applications lead to the store; iTunes music doesn't play the preview; and others products weren't tested.

## Usage

1. Drop the _ACStore_ directory in your xcode project
2. Use exactly like SKStoreProductViewController but change the _SK_ prefix by _AC_:

    ACStoreProductViewController *storeProductViewController = [[ACStoreProductViewController alloc] init];
    storeProductViewController.affiliateIdentifier = @"2141033";
    storeProductViewController.partnerIdentifier = @"24379";
    storeProductViewController.delegate = self;
	
    [self presentViewController:storeProductViewController animated:YES completion:^{
	    NSDictionary *parameters = @{ACStoreProductParameterITunesItemIdentifier:productIdentifier};
        [storeProductViewController loadProductWithParameters:parameters completionBlock:^(BOOL result, NSError *error) {
        }];
    }];