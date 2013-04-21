//
//  PocketActivity.m
//  newsyc
//
//  Created by Joseph Fabisevich on 1/5/13.
//
//

#import "PocketActivity.h"
#import "ProgressHUD.h"

@implementation PocketActivity

- (id)init
{
    if (self == [super init]) {
        hud = [[ProgressHUD alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [hud release];
    [super dealloc];
}

- (NSString *)activityType {
    return @"pocket-oauth-v1";
}

- (NSString *)activityTitle {
    return @"Pocket It";
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"pocket.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    [PocketAPI sharedAPI].consumerKey = @"13340-885192a1af03a091e6c59527";
    if ([[PocketAPI sharedAPI] isLoggedIn]) {
        [[PocketAPI sharedAPI] saveURL:[activityItems objectAtIndex:0] delegate:self];
        [hud setText:@"Saving"];
        [hud showInWindow:[[UIApplication sharedApplication] keyWindow]];
    } else {
        [[PocketAPI sharedAPI] loginWithDelegate:self];
        [hud setText:@"Request Login"];
        [hud showInWindow:[[UIApplication sharedApplication] keyWindow]];
    }
}

- (void)performActivity {
    [self activityDidFinish:YES];
}


////////////////////////////////////////////////////////////////////////////////
#pragma mark - Pocket API stuffs

-(void)pocketAPILoggedIn:(PocketAPI *)api
{
    [hud setText:@"Logged In!"];
    [hud setState:kProgressHUDStateCompleted];
    [hud dismissAfterDelay:0.8f animated:YES];
}

-(void)pocketAPI:(PocketAPI *)api hadLoginError:(NSError *)error
{
    [hud setText:@"Couldn't Log In :("];
    [hud setState:kProgressHUDStateError];
    [hud dismissAfterDelay:0.8f animated:YES];
}

-(void)pocketAPI:(PocketAPI *)api savedURL:(NSURL *)url
{
    [hud setText:@"Saved!"];
    [hud setState:kProgressHUDStateCompleted];
    [hud dismissAfterDelay:0.8f animated:YES];
}

-(void)pocketAPI:(PocketAPI *)api failedToSaveURL:(NSURL *)url error:(NSError *)error
{
    [hud setText:@"Error Saving"];
    [hud setState:kProgressHUDStateError];
    [hud dismissAfterDelay:0.8f animated:YES];   
}

@end
