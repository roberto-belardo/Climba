//
//  MyLog.h
//  MyLog
//
//   Francesca Iacona on 4/4/11.
//  Copyright 2011 Reply. All rights reserved.
//


#ifdef DEBUG
    #define DLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__);
    #define DDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//    #define DLog(...)
//    #define DDLog(...)


    #define DSeparator(fmt) DLog( @"──────────────────────────────────── %@ ────────────────────────────────────────",fmt );

    #define DLogObject(fmt, arg ) DLog( @"%@ - Object: %@", fmt, arg ); 
    #define DLogInt(fmt, arg ) DLog( @"%@ - integer: %i", fmt,arg ); 
    #define DLogFloat(fmt, arg ) DLog( @"%@ - float: %f", fmt, arg ); 
    #define DLogRect(fmt, arg ) DLog( @"%@ - CGRect ( %f, %f, %f, %f)", fmt, arg.origin.x, arg.origin.y, arg.size.width, arg.size.height ); 
    #define DLogPoint(fmt, arg ) DLog( @"%@ - CGPoint ( %f, %f )", fmt, arg.x, arg.y ); 
    #define DLogBool(fmt, arg ) DLog( @"%@ - Boolean: %@", fmt, ( arg == YES ? @"YES" : @"NO" ) ); 


    #define DDSeparator(fmt) DDLog( @"──────────────────────────────────── %@ ────────────────────────────────────────",fmt );

    #define DDLogObject(fmt, arg ) DDLog( @"%@ - Object: %@", fmt, arg ); 
    #define DDLogInt(fmt, arg ) DDLog( @"%@ - integer: %i", fmt,arg ); 
    #define DDLogFloat(fmt, arg ) DDLog( @"%@ - float: %f", fmt, arg ); 
    #define DDLogRect(fmt, arg ) DDLog( @"%@ - CGRect ( %f, %f, %f, %f)", fmt, arg.origin.x, arg.origin.y, arg.size.width, arg.size.height ); 
    #define DDLogPoint(fmt, arg ) DDLog( @"%@ - CGPoint ( %f, %f )", fmt, arg.x, arg.y ); 
    #define DDLogBool(fmt, arg ) DDLog( @"%@ - Boolean: %@", fmt, ( arg == YES ? @"YES" : @"NO" ) ); 

    #define GridVCLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__);
    #define CacheLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__);

//    #define GridVCLog(...)
//    #define CacheLog(...)


#else
    #define DLog(...)
    #define DDLog(...)
    #define CacheLog(...)
    #define GridVCLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


/*

#ifdef RELEASE_VERSION // Logs disabilitati in caso release
    #define MySeparator ;
    #define MyLog(...);
    #define MyFLog ;
    #define MyFELog ;
    #define MyFLogFull ;
    #define MyFELogFull ;
    #define MyLogTime;
    /// /// /// ////// ///// log per tipi specifici 
    #define MyLogObject(arg);
    #define MyLogInt(arg);
    #define MyLogFloat(arg);
    #define MyLogRect(arg);
    #define MyLogPoint(arg);
    #define MyLogBool(arg);

    #define CustomSeparator(fmt);
    #define CustomFLog(fmt);
    #define CustomFELog(fmt);
    #define CustomFLogFull(fmt);
    #define CustomFELogFull(fmt);
    #define CustomLogTime(fmt);
    /// /// /// ////// ///// log per tipi specifici
    #define CustomLogObject(fmt, arg );
    #define CustomLogInt(fmt, arg );
    #define CustomLogFloat(fmt, arg );
    #define CustomLogRect(fmt, arg );
    #define CustomLogPoint(fmt, arg );
    #define CustomLogBool(fmt, arg );
#else // Logs abilitati in caso debug
    #define MySeparator NSLog( @"────────────────────────────────────────────────────────────────────────────" );
    #define MyLog(...) NSLog( __VA_ARGS__ );
    #define MyFLog NSLog( @"%s", __func__ );
    #define MyFELog NSLog( @"%s - END", __func__ );
    #define MyFLogFull NSLog(@"Line:%d : %s : %s", __LINE__,__FILE__,__FUNCTION__);
    #define MyFELogFull NSLog(@"Line:%d : %s : %s - END", __LINE__,__FILE__,__FUNCTION__);
    #define MyLogTime NSLog(@"%s time: %@", __PRETTY_FUNCTION__, [NSDate date]);
    /// /// /// ////// ///// log per tipi specifici
    #define MyLogObject( arg ) NSLog( @"Object: %@", arg ); 
    #define MyLogInt( arg ) NSLog( @"integer: %i", arg ); 
    #define MyLogFloat( arg ) NSLog( @"float: %f", arg ); 
    #define MyLogRect( arg ) NSLog( @"CGRect ( %f, %f, %f, %f)", arg.origin.x, arg.origin.y, arg.size.width, arg.size.height ); 
    #define MyLogPoint( arg ) NSLog( @"CGPoint ( %f, %f )", arg.x, arg.y ); 
    #define MyLogBool( arg ) NSLog( @"Boolean: %@", ( arg == YES ? @"YES" : @"NO" ) ); 

    #define CustomSeparator(fmt) NSLog( @"──────────────────────────────────── %@ ────────────────────────────────────────",fmt );
    #define CustomFLog(fmt) NSLog( @"%s %@", __func__,fmt );
    #define CustomFELog(fmt) NSLog( @"%s - END %@", __func__,fmt );
    #define CustomFLogFull(fmt) NSLog(@"[Line:%d : %s : %s] %@", __LINE__,__FILE__,__FUNCTION__,fmt );
    #define CustomFELogFull(fmt) NSLog(@"[Line:%d : %s : %s - END] %@", __LINE__,__FILE__,__FUNCTION__,fmt );
    #define CustomLogTime(fmt) NSLog(@"%s time: %@ - %@", __PRETTY_FUNCTION__, [NSDate date], fmt);
    /// /// /// ////// ///// log per tipi specifici
    #define CustomLogObject(fmt, arg ) NSLog( @"%@\nObject: %@", fmt, arg ); 
    #define CustomLogInt(fmt, arg ) NSLog( @"%@\ninteger: %i", fmt,arg ); 
    #define CustomLogFloat(fmt, arg ) NSLog( @"%@\nfloat: %f", fmt, arg ); 
    #define CustomLogRect(fmt, arg ) NSLog( @"%@\nCGRect ( %f, %f, %f, %f)", fmt, arg.origin.x, arg.origin.y, arg.size.width, arg.size.height ); 
    #define CustomLogPoint(fmt, arg ) NSLog( @"%@\nCGPoint ( %f, %f )", fmt, arg.x, arg.y ); 
    #define CustomLogBool(fmt, arg ) NSLog( @"%@\nBoolean: %@", fmt, ( arg == YES ? @"YES" : @"NO" ) ); 
#endif // RELEASE_VERSION
 
*/



