    member
    
_ABCLinkMode_   equate(1)    

    map
        include( 'ULID.inc' ),once
    end !* end *            
    map
        module('Windows.DLL')
            GetSystemTime(*SYSTEMTIME),pascal,raw
        end         
        include( 'CWUTIL.INC' ),once
        include( 'i64.inc' ),once        
    end !* end *
    
SYSTEMTIME      GROUP,TYPE              !System time struct
wYear               USHORT
wMonth              USHORT
wDayOfWeek          USHORT
wDay                USHORT
wHour               USHORT
wMinute             USHORT
wSecond             USHORT
wMilliseconds       USHORT
                END !* group *

UnixStartTime   equate( 61730 ) ! equal to "date( 01, 01, 1970 )"
UUID_SIZE       equate(16)
GMT             long( 0 )

SetGMT          procedure( long _gmt ) 
    code
    GMT = _gmt

NewUUIDv7       procedure( long flag=0 )!,string
sUUID           cstring(37)
uuid            byte,dim(UUID_SIZE)
j               long
    code
    NewUUIDv7Array( uuid )	
	loop j = 1 to UUID_SIZE
	    if j = 4
	        sUUID = sUUID & '-'    
	    elsif j = 6
	        sUUID = sUUID & '-'
	    elsif j = 8
	        sUUID = sUUID & '-'
	    elsif j = 10
	        sUUID = sUUID & '-'
        end !* case *   
    	sUUID = sUUID & ByteToHex( uuid[j], flag )
    end !* loop * 
    
    return sUUID

! ---------------------------------------------------------------------------------------------------
! Binary Version
! ---------------------------------------------------------------------------------------------------
NewUUIDv7Array  procedure( *byte[] _ulid )
days_since_1970 long
iToday          decimal(31)
iClock          decimal(31)
timeStamp       decimal(31)
SysTime         like(SystemTime)
i64             like(Int64)
uuid8           byte,dim(8),over(i64)
j               long
    code
    if maximum( _ulid, 1 ) >= UUID_SIZE
        GetSystemTime( SysTime )
        iToday = date( SysTime.wMonth, SysTime.wDay, SysTime.wYear )
        days_since_1970 = iToday - UnixStartTime
        
        iClock = (((SysTime.wHour+GMT) * 3600) + (SysTime.wMinute * 60) + SysTime.wSecond) + SysTime.wMilliseconds
        timestamp = ((days_since_1970 * 86400) + iClock) * 1000 + SysTime.wMilliseconds
        
        i64FromDecimal( i64, timestamp )            
        _ulid[ 1 ] = uuid8[ 6 ]
        _ulid[ 2 ] = uuid8[ 5 ]
        _ulid[ 3 ] = uuid8[ 4 ]
        _ulid[ 4 ] = uuid8[ 3 ]
        _ulid[ 5 ] = uuid8[ 2 ]
        _ulid[ 6 ] = uuid8[ 1 ]
       
        loop j = 7 to UUID_SIZE
            _ulid[j] = random( 0, 255 )
        end !* loop *        

        ! Set version (7) and variant bits (2 MSB as 01)
        _ulid[7] = bor( band(_ulid[7], 00FH), bshift(7, 4) )
        _ulid[9] = bor( band(_ulid[9], 03FH), 080H )
    end !* if *	    
    
!* end *
