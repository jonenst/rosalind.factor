!
!

USING: kernel io math math.parser math.functions sequences assocs
       rosalind rosalind.fasta rosalind.util ;
IN: rosalind.sol.gc

: rosalind-gc ( -- )
    read-fasta dup keys dup [ gc-content ] map argsup* 
    [ swap nth swap at print ] dip 
    100 * .01 round-to float>string "%" append print
;

MAIN: rosalind-gc