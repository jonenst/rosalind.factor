!
!

USING: kernel sequences strings math.parser ;
IN: rosalind.util

: as-string ( seq -- str )
    SBUF" " clone swap [ " " append ] [ number>string append ] interleave
    >string
;