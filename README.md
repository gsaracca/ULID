# ULID (uuid7 a Clarion Implementation)
uuid7 - time-sortable UUIDs
UUID v7 Implementacion in Clarion


This module implements the version 7 UUIDs, proposed by Peabody and Davis in https://www.ietf.org/id/draft-peabody-dispatch-new-uuid-format-02.html as an extension to RFC4122.

Version 7 has the nice characteristic that the start of a UUID encodes the time with a chronological sort order and potentially ~50ns time resolution, while the end of the UUID includes sufficient random bits to ensure consecutive UUIDs will remain unique.

The first 48-bits are the timeStamp in milliseconds on days since 1970-01-01.

# Usage
on MAP add : include( 'ULID.INC' ),once

on code call :
    s = NewUUIDv7()

    this generate an UUID version 7 like: 
  "0191944D-8EC4-7A70-86F5-8AA506DEE33A"

This version on standard i5 Gen 12 generate 1.000.000 of ULID in less than 7 secs.
