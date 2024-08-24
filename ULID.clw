    member
    
_ABCLinkMode_   equate(1)    
    
    map
        module('Windows.DLL')
            GetSystemTime(*SYSTEMTIME),PASCAL,RAW
        end         
        include( 'ULID.inc' ),once
        include( 'CWUTIL.INC' ),once
        include( 'i64.inc' ),once        
    end !* end *
    
    map
        mod( *decimal _dec, long base ),long
        DecToHexa( *decimal _dec ),string
    end !* map *        

SYSTEMTIME      GROUP,TYPE              !System time struct
wYear               USHORT
wMonth              USHORT
wDayOfWeek          USHORT
wDay                USHORT
wHour               USHORT
wMinute             USHORT
wSecond             USHORT
wMilliseconds       USHORT
                END 

NewUUIDv7       procedure()
GMT             long(+3)            ! GMT-3 is Buenos Aires.
sUUID           cstring(37)
uuid            byte,dim(16)
days_since_1970 long
iToday          decimal(31)
iClock          decimal(31)
timeStamp       decimal(31)
SysTime         like(SystemTime)
i64             like(Int64)
uuid8           byte,dim(8),over(i64)
j               long
    code
    GetSystemTime( SysTime )
    iToday = date( SysTime.wMonth, SysTime.wDay, SysTime.wYear )
    days_since_1970 = iToday - date( 01, 01, 1970 )
    
    iClock = (((SysTime.wHour+GMT) * 3600) + (SysTime.wMinute * 60) + SysTime.wSecond) + SysTime.wMilliseconds
    timestamp = ((days_since_1970 * 86400) + iClock) * 1000 + SysTime.wMilliseconds
    
    i64FromDecimal( i64, timestamp )            
    uuid[ 1 ] = uuid8[ 6 ]
    uuid[ 2 ] = uuid8[ 5 ]
    uuid[ 3 ] = uuid8[ 4 ]
    uuid[ 4 ] = uuid8[ 3 ]
    uuid[ 5 ] = uuid8[ 2 ]
    uuid[ 6 ] = uuid8[ 1 ]
   
    loop j = 7 to 16
        uuid[j] = random( 0, 255 )
    end !* loop *        

	! Set version (7) and variant bits (2 MSB as 01)
	uuid[7] = bor( band(uuid[7], 00FH), bshift(7, 4) )
	uuid[9] = bor( band(uuid[9], 03FH), 080H )
	
	loop j = 1 to 16
	    if j = 4
	        sUUID = sUUID & '-'    
	    elsif j = 6
	        sUUID = sUUID & '-'
	    elsif j = 8
	        sUUID = sUUID & '-'
	    elsif j = 10
	        sUUID = sUUID & '-'
        end !* case *   
    	sUUID = sUUID & ByteToHex( uuid[j] )
    end !* loop * 
    
	return sUUID


mod             procedure( *decimal _dec, long _base )!,long
dividend        decimal(31)
divisor         decimal(31)
quotient        decimal(31)
remainder       decimal(31)
    code
    dividend = _dec
    divisor = _base 
    quotient = round( (dividend / divisor) - 0.5, 1 )
    remainder = dividend - (quotient * divisor)
    _dec = quotient
    !add_txt( 'Dividendo: ' & dividendo & ' / ' & divisor & ' = ' & cociente & ' -> (cociente * divisor) = ' & (cociente * divisor) &  ' MOD = ' & resto )
    return remainder
    
DecToHexa       procedure( *decimal _dec )!,string
v               decimal(31)
s               cstring(64)
b               long(16)
ConvStr         cstring('0123456789ABCDEF')
idx             long
    code
    s = ''
    v = _dec
    loop
        idx = mod( v, b ) + 1
        s = ConvStr[ idx ] & s
        if v < 1 
            break
        end !* if *
    end !* loop *
    return s
    
!* end *