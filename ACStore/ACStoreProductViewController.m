//
//  ACStoreProductViewController.m
//  ACStoreExample
//
//  Created by Arnaud Coomans on 15/02/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "ACStoreProductViewController.h"
#import "NSDictionary+QueryStringBuilder.h"

NSString *const ACStoreProductParameterITunesItemIdentifier = @"id";

const NSString *kACStoreProductTypeSoftware = @"software";
const NSString *kACStoreProductTypeAlbum = @"album";
const NSString *kACStoreProductTypeEbook = @"ebook";
const NSString *kACStoreProductTypeTvSeason = @"tvSeason";
const NSString *kACStoreProductTypeMovie = @"movie";
const NSString *kACStoreProductTypeMacSoftware = @"macSoftware";


const NSString *kACStoreProductViewControllerWidgetURLString = @"http://widgets.itunes.apple.com/widget.html";
const NSString *kACStoreProductViewControllerLookupURLString = @"http://itunes.apple.com/lookup";

@interface ACStoreProductViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) void (^completionBlock)(BOOL result, NSError *error);
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSString *productType;
@property (nonatomic, strong) NSDictionary *parameters;
- (NSURLRequest*)requestForProductWithParameters:(NSDictionary *)parameters;
@end

@implementation ACStoreProductViewController


- (id)initWithAffiliate:(NSString*)affiliateIdentifier
				partner:(NSString*)partnerIdentifier
			   delegate:(id<ACStoreProductViewControllerDelegate>)delegate {
	self = [super init];
    if (self) {
        // Custom initialization
		self.delegate = delegate;
		self.affiliateIdentifier = affiliateIdentifier;
		self.partnerIdentifier = partnerIdentifier;
		self.activityIndicatorView = nil;
		self.webView = nil;
		self.completionBlock = ^(BOOL result, NSError *error){};
    }
    return self;
}

- (id)init {
    return [self initWithAffiliate:nil
						   partner:nil
						  delegate:nil];
}

- (void)dealloc {
	[self.connection cancel];
}

- (void)loadView {
	CGRect frame = CGRectMake(0, 0, 320, 480);
	self.view = [[UIView alloc] initWithFrame:frame];
	self.view.backgroundColor = [UIColor colorWithWhite:254/255.0 alpha:1.0];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
	navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	navigationBar.items = @[self.navigationItem];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil)
																			 style:UIBarButtonItemStyleBordered
																			target:self
																			action:@selector(closeButtonTapped:)];
	[self.view addSubview:navigationBar];
	
	self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.activityIndicatorView.center = self.view.center;
	self.activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	[self.view insertSubview:self.activityIndicatorView belowSubview:navigationBar];
	
	self.webView = [[UIWebView alloc] initWithFrame:CGRectOffset(self.view.frame, 0, 15)];
	self.webView.delegate = self;
	self.webView.hidden = YES;
	self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view insertSubview:self.webView belowSubview:self.activityIndicatorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - widget

- (NSURLRequest*)requestForProductWithParameters:(NSDictionary *)parameters {
	NSString *queryString = [@{
							 @"c": @"",
							 @"d": @"",
							 @"t": @"",
							 @"m": @"",
							 @"e": self.productType,
							 @"w": [NSString stringWithFormat:@"%.f", round(self.webView.bounds.size.width)],
							 @"h": [NSString stringWithFormat:@"%.f", round(self.webView.bounds.size.height)],
							 @"ids": [(parameters[ACStoreProductParameterITunesItemIdentifier] ? parameters[ACStoreProductParameterITunesItemIdentifier] : @0) description],
							 @"wt": @"discovery",
							 @"affiliate_id": (self.affiliateIdentifier ? self.affiliateIdentifier : @"2141033"),
							 @"partnerId": (self.partnerIdentifier ? self.partnerIdentifier : @"24379")
							 } queryString];
	NSString *urlString = [kACStoreProductViewControllerWidgetURLString stringByAppendingString:queryString];
	return [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
}

#pragma mark - SKStoreProductViewController

- (void)loadProductWithParameters:(NSDictionary *)parameters completionBlock:(void (^)(BOOL result, NSError *error))block {
	self.completionBlock = block;
	[self.activityIndicatorView startAnimating];
	self.webView.hidden = YES;
	
	self.parameters = parameters;
	NSString *queryString = [@{
							 @"id": [(parameters[ACStoreProductParameterITunesItemIdentifier] ? parameters[ACStoreProductParameterITunesItemIdentifier] : @0) description],
							 } queryString];
	NSString *urlString = [kACStoreProductViewControllerLookupURLString stringByAppendingString:queryString];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
	self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (self.connection) {
		self.receivedData = [NSMutableData data];
	}
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.completionBlock(YES, nil);
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('app_name').innerText"];
		[webView stringByEvaluatingJavaScriptFromString:@"$('#scrollbar').remove()"];
		[webView stringByEvaluatingJavaScriptFromString:@"$('#container').css('width', '100%')"];
		[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"$('.width_minus_border').css('width', '%.fpx')", round(self.webView.bounds.size.width)]];
		[webView stringByEvaluatingJavaScriptFromString:@"$('#container .top_payload').css('margin', 0)"];
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			[webView stringByEvaluatingJavaScriptFromString:@"$('#background').remove()"];
			[webView stringByEvaluatingJavaScriptFromString:@"$('#footer').remove()"];
		}
		
		webView.hidden = NO;
		[self.activityIndicatorView stopAnimating];
	});
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	self.completionBlock(NO, error);
}

#pragma mark - actions

- (void)closeButtonTapped:(id)sender {
	[self dismissViewControllerAnimated:YES completion:^{
		if ([self.delegate respondsToSelector:@selector(productViewControllerDidFinish:)]) {
			[self.delegate productViewControllerDidFinish:self];
		}
	}];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.connection = nil;
	self.receivedData = nil;
    NSLog(@"Connection failed! Error - %@ %@",
		  [error localizedDescription],
		  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSString *content = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
	self.productType = [self productTypeFromDescription:content];
	
	[self.webView loadRequest:[self requestForProductWithParameters:self.parameters]];
	
    self.connection = nil;
	self.receivedData = nil;
}

- (NSString*)productTypeFromDescription:(NSString*)description {
	if ([description rangeOfString:@"kind\":\"software"].location != NSNotFound) {
		return (NSString*)kACStoreProductTypeSoftware;
	} else
	if ([description rangeOfString:@"collectionType\":\"Album"].location != NSNotFound) {
		return (NSString*)kACStoreProductTypeAlbum;
	} else
	if ([description rangeOfString:@"kind\":\"ebook"].location != NSNotFound) {
		return (NSString*)kACStoreProductTypeEbook;
	} else
	/* background problem
	if ([description rangeOfString:@"collectionType\":\"TV Season"].location != NSNotFound) {
		return (NSString*)kACStoreProductTypeTvSeason;
	} else
	*/
	/* background problem
	if ([description rangeOfString:@"kind\":\"feature-movie"].location != NSNotFound) {
		return (NSString*)kACStoreProductTypeMovie;
	} else
	*/
	if ([description rangeOfString:@"kind\":\"mac-software"].location != NSNotFound) {
		return (NSString*)kACStoreProductTypeMacSoftware;
	}
	return (NSString*)kACStoreProductTypeEbook;;
}

#pragma mark - interface orientations

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"$('.width_minus_border').css('width', '%fpx')", round(self.webView.bounds.size.width)]];
	
}

@end
