//
//  Datausage.m
//  Datausage
//
//  Created by Wearables Mac Mini on 11/12/15.
//  Copyright © 2015 Cognizant. All rights reserved.
//

#import "Datausage.h"


#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>


@implementation Datausage

static NSString *const DataCounterKeyWWANSent = @"WWANSent";
static NSString *const DataCounterKeyWWANReceived = @"WWANReceived";
static NSString *const DataCounterKeyWiFiSent = @"WiFiSent";
static NSString *const DataCounterKeyWiFiReceived = @"WiFiReceived";

NSDictionary *DataCounters()
{
  
  struct ifaddrs *addrs;
  const struct ifaddrs *cursor;
  
  u_int32_t WiFiSent = 0;
  u_int32_t WiFiReceived = 0;
  u_int32_t WWANSent = 0;
  u_int32_t WWANReceived = 0;
  
  if (getifaddrs(&addrs) == 0)
  {
    cursor = addrs;
    while (cursor != NULL)
    {
      if (cursor->ifa_addr->sa_family == AF_LINK)
      {
#ifdef DEBUG
        const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;
        if(ifa_data != NULL)
        {
          NSLog(@"Interface name %s: sent %tu received %tu",cursor->ifa_name,ifa_data->ifi_obytes,ifa_data->ifi_ibytes);
        }
#endif
        
        // name of interfaces:
        // en0 is WiFi
        // pdp_ip0 is WWAN
        NSString *name = [NSString stringWithFormat:@"%s",cursor->ifa_name];
        if ([name hasPrefix:@"en"])
        {
          const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;
          if(ifa_data != NULL)
          {
            WiFiSent += ifa_data->ifi_obytes;
            WiFiReceived += ifa_data->ifi_ibytes;
          }
        }
        
        if ([name hasPrefix:@"pdp_ip"])
        {
          const struct if_data *ifa_data = (struct if_data *)cursor->ifa_data;
          if(ifa_data != NULL)
          {
            WWANSent += ifa_data->ifi_obytes;
            WWANReceived += ifa_data->ifi_ibytes;
          }
        }
      }
      
      cursor = cursor->ifa_next;
    }
    
    freeifaddrs(addrs);
  }
  
  return @{DataCounterKeyWiFiSent:[NSNumber numberWithUnsignedInt:WiFiSent],
           DataCounterKeyWiFiReceived:[NSNumber numberWithUnsignedInt:WiFiReceived],
           DataCounterKeyWWANSent:[NSNumber numberWithUnsignedInt:WWANSent],
           DataCounterKeyWWANReceived:[NSNumber numberWithUnsignedInt:WWANReceived]};
}

+ (NSDictionary *)getDatas{
  NSDictionary *temp = DataCounters();
//  NSLog(@"temp :%@",temp);
  return temp;
}


@end
