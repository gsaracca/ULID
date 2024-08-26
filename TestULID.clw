    program

    map        
        include( 'ULID.INC' ),once   
        module('')
            sleep(LONG),pascal
        end
        main()
        init_log( string _fname )
        add_log( string _msg )
        done_log()        
    end !* map *
       
xText       file,driver('ascii','/clip=on'),create
record          record
xLine               string(1000)
                end !* record *
            end !* file *                    
       
    code
    MAIN()
    
MAIN        procedure()
rta         cstring(37)
startTime   long
endTime     long
max_gen     long(1000000)
i           long
    code 
    SetGMT( +3 )                ! GMT-3 is Buenos Aires.
    
    startTime = clock()    
    init_log( 'NewUUIDv7.txt' )	
	loop i = 1 to max_gen
		rta = NewUUIDv7( 1 )
		add_log( 'NewUUIDv7 --> ' & i & ' --> ' & rta )
	end !* loop *		
	endTime = clock()
	
	add_log( 'Elapsed time (sec) --> ' & (endTime - startTime + 1) / 100 )
    done_log()
    

init_log    procedure( string _fname )
    code
    xText{ prop:name } = clip( _fname )
    create( xText )
    open( xText )
    
add_log     procedure( string _msg )
    code
    xText.xLine = clip(_msg)
    add( xText )
    
done_log    procedure()
    code
    close( xText )
    
!* end *
