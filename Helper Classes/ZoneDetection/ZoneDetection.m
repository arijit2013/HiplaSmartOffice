//
//  ZoneDetection.m
//  @TCS
//
//  Created by FNSPL on 28/04/18.
//  Copyright © 2018 fnspl3. All rights reserved.
//

#import "ZoneDetection.h"

static ZoneDetection *sharedZone = nil;

@implementation ZoneDetection

+(ZoneDetection *) sharedZoneDetection {
    
    @synchronized([ZoneDetection class])
    {
        if (!sharedZone) {
         
            sharedZone = [[self alloc] init];
//            [sharedZone getZone];
            [sharedZone navigationTick:nil];
            
            [sharedZone navigineSetup];
            
           // [sharedZone getZone];
            
        }
        
        return sharedZone;
    }
    
    return nil;
    
}


-(void)getZone{
    
    [SVProgressHUD show];
    
    NSDictionary *headers = @{ @"Cache-Control": @"no-cache",
                               @"Postman-Token": @"f1f0cb74-102c-4317-95fc-85e6c5b2f428" };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.navigine.com/zone_segment/getAll?userHash=0F17-DAE1-4D0A-1778&sublocationId=3247"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    
                                                    if (error) {
                                                        
                                                        [SVProgressHUD dismiss];
                                                        
                                                        NSLog(@"%@", error);
                                                        
                                                    } else {
                                                        
                                                        [SVProgressHUD dismiss];
                                                        
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        
                                                        NSLog(@"%@", httpResponse);
                                                        
                                                        if(httpResponse.statusCode == 200)
                                                        {
                                                            NSError *parseError = nil;
                                                            
                                                            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                                            
                                                            NSLog(@"The response is - %@",responseDictionary);
                                                            
                                                            self->_zoneArray = [NSArray arrayWithArray:[responseDictionary objectForKey:@"zoneSegments"]];
                                                            
                                                        }
                                                    }
                                                }];
    [dataTask resume];
    
}



- (void) navigationTick: (NSTimer *)timer {
    
    if (_delegate) {
        
        [_delegate navigationTicker];
    }
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        // Your code here
        [sharedZone navigationTick:nil];
        
    });
    
}

- (void) navigineSetup {
    
    [SVProgressHUD show];
    
    _navigineCore = [[NavigineCore alloc] initWithUserHash: @"0F17-DAE1-4D0A-1778"
                                                    server: @"https://api.navigine.com"];
    
    _navigineCore.delegate = sharedZone;
    
    [_navigineCore downloadLocationByName:@"Future Netwings"
                              forceReload:true
                             processBlock:^(NSInteger loadProcess) {
                                 NSLog(@"%ld",(long)loadProcess);
                             } successBlock:^(NSDictionary *userInfo) {
                                 
                                 [self->_navigineCore startNavigine];
                                 [self->_navigineCore startPushManager];
                                 
                             } failBlock:^(NSError *error) {
                                 NSLog(@"%@",error);
                             }];
    
}


- (NSDictionary *)didEnterZoneWithPoint:(CGPoint)currentPoint {
    
    NSDictionary* zone = nil;
    
    if (_zoneArray) {
        
        for (NSInteger i = 0; i < [_zoneArray count]; i++) {
            
            NSDictionary* dicZone = [NSDictionary dictionaryWithDictionary:[_zoneArray objectAtIndex:i]];
            
            NSArray* coordinates = [NSArray arrayWithArray:[dicZone objectForKey:@"coordinates"]];
            
            if ([coordinates count]>0) {
                
                UIBezierPath* path = [[UIBezierPath alloc]init];
                
                for (NSInteger j=0; j < [coordinates count]; j++) {
                    
                    NSDictionary* dicCoordinate = [NSDictionary dictionaryWithDictionary:[coordinates objectAtIndex:j]];
                    
                    if ([[dicCoordinate allKeys] containsObject:@"kx"]) {
                        
                        float xPoint = (float)[[dicCoordinate objectForKey:@"kx"] floatValue];
                        float yPoint = (float)[[dicCoordinate objectForKey:@"ky"] floatValue];
                        
                        CGPoint point = CGPointMake(xPoint, yPoint);
                        
                        if (j == 0) {
                            
                            [path moveToPoint:point];
                            
                        } else {
                            
                            [path addLineToPoint:point];
                        }
                    }
                }
                
                [path closePath];
                
                if ([path containsPoint:currentPoint]) {
                    
                    zone = [NSDictionary dictionaryWithDictionary:dicZone];
                    
                    break;
                    
                } else {
                    
                    zone = nil;
                    
                }
            }
        }
        
    } else {
        
    }
    
    return zone;
}


@end
