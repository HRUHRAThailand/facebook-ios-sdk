/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "FBSDKPaymentProductRequestorFactory.h"

#import "FBSDKAppEvents+EventLogging.h"
#import "FBSDKAppStoreReceiptProviding.h"
#import "FBSDKGateKeeperManager.h"
#import "FBSDKGateKeeperManaging.h"
#import "FBSDKLoggerFactory.h"
#import "FBSDKPaymentProductRequestor.h"
#import "FBSDKProductRequestFactory.h"
#import "FBSDKProductsRequestProtocols.h"
#import "FBSDKSettings+Internal.h"
#import "NSUserDefaults+FBSDKDataPersisting.h"

@interface FBSDKPaymentProductRequestorFactory ()

@property (nonatomic, readonly) id<FBSDKSettings> settings;
@property (nonatomic, readonly) id<FBSDKEventLogging> eventLogger;
@property (nullable, nonatomic) Class<FBSDKGateKeeperManaging> gateKeeperManager;
@property (nullable, nonatomic) id<FBSDKDataPersisting> store;
@property (nullable, nonatomic) id<FBSDKLoggingCreating> loggerFactory;
@property (nonatomic, readonly) id<FBSDKProductsRequestCreating> productsRequestFactory;
@property (nonatomic, readonly) id<FBSDKAppStoreReceiptProviding> appStoreReceiptProvider;

@end

@implementation FBSDKPaymentProductRequestorFactory

- (instancetype)init
{
  return [self initWithSettings:FBSDKSettings.sharedSettings
                      eventLogger:FBSDKAppEvents.shared
                gateKeeperManager:FBSDKGateKeeperManager.class
                            store:NSUserDefaults.standardUserDefaults
                    loggerFactory:[FBSDKLoggerFactory new]
           productsRequestFactory:[FBSDKProductRequestFactory new]
          appStoreReceiptProvider:[NSBundle bundleForClass:self.class]];
}

- (instancetype)initWithSettings:(id<FBSDKSettings>)settings
                     eventLogger:(id<FBSDKEventLogging>)eventLogger
               gateKeeperManager:(Class<FBSDKGateKeeperManaging>)gateKeeperManager
                           store:(id<FBSDKDataPersisting>)store
                   loggerFactory:(id<FBSDKLoggingCreating>)loggerFactory
          productsRequestFactory:(id<FBSDKProductsRequestCreating>)productsRequestFactory
         appStoreReceiptProvider:(id<FBSDKAppStoreReceiptProviding>)receiptProvider
{
  if ((self = [super init])) {
    _settings = settings;
    _eventLogger = eventLogger;
    _gateKeeperManager = gateKeeperManager;
    _store = store;
    _loggerFactory = loggerFactory;
    _productsRequestFactory = productsRequestFactory;
    _appStoreReceiptProvider = receiptProvider;
  }

  return self;
}

- (nonnull FBSDKPaymentProductRequestor *)createRequestorWithTransaction:(SKPaymentTransaction *)transaction
{
  return [[FBSDKPaymentProductRequestor alloc] initWithTransaction:transaction
                                                          settings:self.settings
                                                       eventLogger:self.eventLogger
                                                 gateKeeperManager:self.gateKeeperManager
                                                             store:self.store
                                                     loggerFactory:self.loggerFactory
                                            productsRequestFactory:self.productsRequestFactory
                                           appStoreReceiptProvider:self.appStoreReceiptProvider];
}

@end
