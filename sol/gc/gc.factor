!
!

USING: kernel io math.parser math.functions sequences rosalind rosalind.fasta ;
IN: rosalind.sol.gc

: rosalind-gc ( -- ) 
    read-fasta dup [ gc-content ] map
    argsup* [ swap nth print nl ] dip .01 floor-to float>string print nl
;

MAIN: rosalind-gc