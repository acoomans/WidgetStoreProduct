# iOS-Store

ACStoreProductViewController is a replacement for SKStoreProductViewController compatible with iOS5 *and* which accepts affiliates links.

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