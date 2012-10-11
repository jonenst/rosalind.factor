!
!

USING: kernel sequences strings math math.functions math.parser ;
IN: rosalind.util

: as-string ( seq -- str )
    SBUF" " clone swap [ " " append ] [ number>string append ] interleave
    >string
;

: round-to ( x step -- y )
    [ [ / round ] [ * ] bi ] unless-zero 
;