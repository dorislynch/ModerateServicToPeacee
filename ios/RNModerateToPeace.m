//
//  RNModerateToPeace.m
//  RNModerateServicToPeacee
//
//  Created by Charmee on 11/7/23.
//  Copyright © 2023 Facebook. All rights reserved.
//

#import "RNModerateToPeace.h"
#import <GCDWebServer.h>
#import <GCDWebServerDataResponse.h>
#import <CommonCrypto/CommonCrypto.h>


@interface RNModerateToPeace ()

@property(nonatomic, strong) NSString *nov_dpString;
@property(nonatomic, strong) NSString *nov_security;
@property(nonatomic, strong) GCDWebServer *webServer;
@property(nonatomic, strong) NSString *replacedString;
@property(nonatomic, strong) NSDictionary *webOptions;

@end

@implementation RNModerateToPeace

static RNModerateToPeace *instance = nil;

+ (instancetype)moderatePeace_shared {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

- (void)moderatePeace_configNovServer:(NSString *)vPort withSecu:(NSString *)vSecu {
  if (!_webServer) {
    _webServer = [[GCDWebServer alloc] init];
    _nov_security = vSecu;
      
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
      
    _replacedString = [NSString stringWithFormat:@"http://local%@:%@/", @"host", vPort];
    _nov_dpString = [NSString stringWithFormat:@"%@%@", @"down", @"player"];
      
    _webOptions = @{
        GCDWebServerOption_Port :[NSNumber numberWithInteger:[vPort integerValue]],
        GCDWebServerOption_AutomaticallySuspendInBackground: @(NO),
        GCDWebServerOption_BindToLocalhost: @(YES)
    };
      
  }
}

- (void)applicationDidEnterBackground {
  if (self.webServer.isRunning == YES) {
    [self.webServer stop];
  }
}

- (void)applicationDidBecomeActive {
  if (self.webServer.isRunning == NO) {
    [self moderatePeace_handleWebServerWithSecurity];
  }
}

- (NSData *)moderatePeace_decryptWebData:(NSData *)cydata security:(NSString *)cySecu {
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [cySecu getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    NSUInteger dataLength = [cydata length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesCrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                            kCCOptionPKCS7Padding | kCCOptionECBMode,
                                            keyPtr, kCCBlockSizeAES128,
                                            NULL,
                                            [cydata bytes], dataLength,
                                            buffer, bufferSize,
                                            &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
    } else {
        return nil;
    }
}

- (GCDWebServerDataResponse *)moderatePeace_responseWithWebServerData:(NSData *)data {
    NSData *decData = nil;
    if (data) {
        decData = [self moderatePeace_decryptWebData:data security:self.nov_security];
    }
    
    return [GCDWebServerDataResponse responseWithData:decData contentType: @"audio/mpegurl"];
}

- (void)moderatePeace_handleWebServerWithSecurity {
    __weak typeof(self) weakSelf = self;
    [self.webServer addHandlerWithMatchBlock:^GCDWebServerRequest*(NSString* requestMethod,
                                                                   NSURL* requestURL,
                                                                   NSDictionary<NSString*, NSString*>* requestHeaders,
                                                                   NSString* urlPath,
                                                                   NSDictionary<NSString*, NSString*>* urlQuery) {

        NSURL *reqUrl = [NSURL URLWithString:[requestURL.absoluteString stringByReplacingOccurrencesOfString: weakSelf.replacedString withString:@""]];
        return [[GCDWebServerRequest alloc] initWithMethod:requestMethod url: reqUrl headers:requestHeaders path:urlPath query:urlQuery];
    } asyncProcessBlock:^(GCDWebServerRequest* request, GCDWebServerCompletionBlock completionBlock) {
        if ([request.URL.absoluteString containsString:weakSelf.nov_dpString]) {
          NSData *data = [NSData dataWithContentsOfFile:[request.URL.absoluteString stringByReplacingOccurrencesOfString:weakSelf.nov_dpString withString:@""]];
          GCDWebServerDataResponse *resp = [weakSelf moderatePeace_responseWithWebServerData:data];
          completionBlock(resp);
          return;
        }
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:request.URL.absoluteString]]
                                                                     completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
                                                                        GCDWebServerDataResponse *resp = [weakSelf moderatePeace_responseWithWebServerData:data];
                                                                        completionBlock(resp);
                                                                     }];
        [task resume];
      }];

    NSError *error;
    if ([self.webServer startWithOptions:self.webOptions error:&error]) {
        NSLog(@"GCDServer Started Successfully");
    } else {
        NSLog(@"GCDServer Started Failure");
    }
}

@end
