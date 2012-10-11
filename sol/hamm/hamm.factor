!
!

USING: io math.parser rosalind ;
IN: rosalind.sol.hamm

: rosalind-hamm ( -- ) 
    readln readln hamming number>string print 
;

MAIN: rosalind-hamm