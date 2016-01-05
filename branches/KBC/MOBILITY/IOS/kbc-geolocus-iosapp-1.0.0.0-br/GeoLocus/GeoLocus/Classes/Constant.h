//Created by Insurance H3 Team
//
//GeoLocus App
//

#define DATA_COLLECTION_INTERVAL 1
#define DATA_POSTING_INTERVAL 4

//#define HOST @"ec2-54-224-38-157.compute-1.amazonaws.com"
//#define PORT 9090

#define HOST @"ec2-54-183-64-73.us-west-1.compute.amazonaws.com"
#define PORT 9091


// GeoLocusViewController

#define LATITUDE @"Latitude"
#define LONGITUDE @"Longitude"
#define ALTITUDE @"Altitude"
#define VERTICAL_ACCURACY @"Vertical Accuracy"
#define BATTERYLEVEL @"Battery Level"
#define SPEED @"Speed"
#define ACCELERATION @"Acceleration"
#define DEVICEID @"Device ID"
#define DISTANCETRAVELLED @"Distance Travelled"
#define BREAKING @"Breaking"
#define HEADING @"Heading"

#define STARTEVENTJSON @"{\"params\":\{\"thresholdValue\":\{\"value\":\%d},\"dataSource\":\{\"value\":\"%@\"},\"totalDistCovered\":\{\"value\":\%d},\"altitude\":\{\"value\":\%d},\"acceleration\":\{\"value\":\%d},\"endTime\":\{\"value\":\%@},\"rawdata\":\{\"value\":\"%@\"},\"startTime\":\{\"value\":\%@},\"distance\":\{\"value\":\%d},\"braking\":\{\"value\":\%d},\"description\":\{\"value\":\"%@\"},\"ruleName\":\{\%@},\"eventCategoryName\":\{\"value\":\"%@\"},\"deviceType\":\{\"value\":\"%@\"},\"creationTime\":\{\"value\":\%@},\"longitude\":\{\"value\":\%.14f},\"geozoneId\":\{\%@},\"speed\":\{\"value\":\%d},\"provider\":\{\"value\":\"%@\"},\"dataReceivedTimestamp\":\{\"value\":\%@},\"gpsAge\":\{\"value\":\%d},\"lbl\":\{\"value\":\%d},\"ck\":\{\"value\":\"%@\"},\"msgType\":\{\"value\":\"%@\"},\"latitude\":\{\"value\":\%.14f},\"accuracy\":\{\"value\":\%d},\"deviceNumber\":\{\"value\":\"%@\"},\"heading\":\{\"value\":\"%@\"}}}"

#define STOPEVENTJSON @"{\"params\":\{\"thresholdValue\":\{\"value\":\%d},\"dataSource\":\{\"value\":\"%@\"},\"totalDistCovered\":\{\"value\":\%f},\"altitude\":\{\"value\":\%d},\"acceleration\":\{\"value\":\%d},\"endTime\":\{\"value\":\%@},\"rawdata\":\{\"value\":\"%@\"},\"startTime\":\{\"value\":\%@},\"distance\":\{\"value\":\%f},\"braking\":\{\"value\":\%d},\"description\":\{\"value\":\"%@\"},\"ruleName\":\{\%@},\"eventCategoryName\":\{\"value\":\"%@\"},\"deviceType\":\{\"value\":\"%@\"},\"creationTime\":\{\"value\":\%@},\"longitude\":\{\"value\":\%.14f},\"geozoneId\":\{\%@},\"speed\":\{\"value\":\%d},\"provider\":\{\"value\":\"%@\"},\"dataReceivedTimestamp\":\{\"value\":\%@},\"gpsAge\":\{\"value\":\%d},\"lbl\":\{\"value\":\%d},\"ck\":\{\"value\":\"%@\"},\"msgType\":\{\"value\":\"%@\"},\"latitude\":\{\"value\":\%.14f},\"accuracy\":\{\"value\":\%d},\"deviceNumber\":\{\"value\":\"%@\"},\"heading\":\{\"value\":\"%@\"}}}"

#define FINALJSONDATA @"{\"params\":\{\"dataSource\":\{\"value\":\"%@\"},\"msgType\":\{\"value\":\"%@\"},\"provider\":\{\"value\":\"%@\"},\"creationTime\":\{\"value\":%@},\"dataReceivedTimestamp\":\{\"value\":%@},\"gpsAge\":\{\"value\":\%d},\"totalDistCovered\":\{\"value\":\%f},\"rawdata\":\{\"value\":\"%@\"},\"lbl\":\{\"value\":\%d},\"ck\":\{\"value\":\"%@\"},\"longitude\":\{\"value\":\%.14f},\"latitude\":\{\"value\":\%.14f},\"deviceNumber\":\{\"value\":\"%@\"},\"accuracy\":\{\"value\":\%d},\"speed\":\{\"value\":\%d},\"altitude\":\{\"value\":\%d},\"acceleration\":\{\"value\":\%d},\"braking\":\{\"value\":\%d},\"heading\":\{\"value\":\"%@\"},\"deviceType\":\{\"value\":\"%@\"}}}"

// CorelocationController
#define MOTIONTYPE_NOTMOVING @"Not Moving"
#define MOTIONTYPE_NONVEHICLE @"Walking or Running"
#define MOTIONTYPE_AUTOMOTIVE @"Automotive"

#define DEVICE_ID @"A991F82E-6C86-4A6F-9277-4A51843C29F3"

//#define DEVICE_ID @"1200-9945733522"