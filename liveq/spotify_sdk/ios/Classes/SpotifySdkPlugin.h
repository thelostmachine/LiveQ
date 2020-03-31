#import <Flutter/Flutter.h>
#import <SpotifyiOS/SpotifyiOS.h>

@interface SpotifySdkPlugin : NSObject<FlutterPlugin, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate>

@property (nonatomic, strong) SPTSessionManager * sessionManager;
@property (nonatomic, strong) SPTConfiguration * configuration;
@property (nonatomic, strong) SPTAppRemote * appRemote;

@end
