#import "SpotifySdkPlugin.h"

static NSString * const SpotifyClientID = @"03237b2409b24752a3f0c33262ad2d02";
static NSString * const SpotifyRedirectURLString = @"spotify-ios-quick-start://spotify-login-callback";
static NSString * const trackIdentifier = @"spotify:track:58kNJana4w5BIjlZE2wq5m";

@implementation SpotifySdkPlugin


//- (SPTConfiguration *) configuration {
//    if (!_configuration) {
//        _configuration = [SPTConfiguration configurationWithClientID:SpotifyClientID redirectURL:[NSURL URLWithString:SpotifyRedirectURLString]];
//    }
//
//    return _configuration;
//}
//
//- (SPTSessionManager *) sessionManager {
//    if (!_sessionManager) {
//        _sessionManager = [SPTSessionManager sessionManagerWithConfiguration:_configuration delegate:self];
//    }
//
//    return _sessionManager;
//}

//- (SPTAppRemote *) appRemote {
//    if (!_appRemote) {
//        _appRemote = [[SPTAppRemote alloc] initWithConfiguration:_configuration logLevel:SPTAppRemoteLogLevelDebug];
//    }
//
//    _appRemote.delegate = self;
//
//    return _appRemote;
//}


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"spotify_sdk"
                                     binaryMessenger:[registrar messenger]];
    SpotifySdkPlugin* instance = [[SpotifySdkPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"connectToSpotify" isEqualToString:call.method]) {
        
        printf("HELLO");
        NSString * clientId = call.arguments[@"paramClientId"];
        NSString * redirectUrl = call.arguments[@"paramRedirectUrl"];
        
        [self connectToSpotify:clientId redirectUrl:redirectUrl result:result];
        
        
        
    }
    else if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)connectToSpotify:(NSString *)clientId redirectUrl:(NSString *)redirectUrl result:(FlutterResult)result {
    
    SPTConfiguration * configuration = [SPTConfiguration configurationWithClientID:SpotifyClientID redirectURL:[NSURL URLWithString:SpotifyRedirectURLString]];
    
    configuration.tokenSwapURL = [NSURL URLWithString:@"http://localhost:1234/swap"];
    configuration.tokenRefreshURL = [NSURL URLWithString:@"http://localhost:1234/refresh"];
    configuration.playURI = trackIdentifier;
    
    
    self.sessionManager = [[SPTSessionManager alloc] initWithConfiguration:configuration delegate:self];
    
    SPTScope requestedScope = SPTAppRemoteControlScope;
    if (@available(iOS 11.0, *)) {
        [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
    } else {
        // Fallback on earlier versions
    }
    
}

#pragma mark - SPTSessionManagerDelegate

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    self.appRemote.connectionParameters.accessToken = session.accessToken;
    [self.appRemote connect];
//    NSLog(@"success: %@", session);
}

- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"fail: %@", error);
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
    NSLog(@"renewed: %@", session);
}

#pragma mark - SPTAppRemoteDelegate

- (void)appRemoteDidEstablishConnection:(SPTAppRemote *)appRemote
{
    NSLog(@"connected");
    
    self.appRemote.playerAPI.delegate = self;
    [self.appRemote.playerAPI subscribeToPlayerState:^(id  _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
        }
    }];
}

- (void)appRemote:(SPTAppRemote *)appRemote didDisconnectWithError:(NSError *)error
{
    NSLog(@"disconnected");
}

- (void)appRemote:(SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(NSError *)error
{
    NSLog(@"failed");
}

- (void)playerStateDidChange:(id<SPTAppRemotePlayerState>)playerState
{
    NSLog(@"Track name: %@", playerState.track.name);
}




@end
