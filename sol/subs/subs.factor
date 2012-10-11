!
!

USING: io math sequences rosalind rosalind.util ;
IN: rosalind.sol.subs

: rosalind-subs ( -- ) 
    readln readln motifs [ 1 + ] map as-string print 
;

MAIN: rosalind-subs