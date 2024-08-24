! -------------------------------------------------------------------------
!
! Universally Unique Lexicographically Sortable Identifier
!
! -------------------------------------------------------------------------

    module( 'ULID.CLW' )
        NewUUIDv7(),string
    end !* module *
    
COMPILE('Link', _ABCLinkMode_)
    PRAGMA('compile(ULID.CLW)')
!Link