!
!

USING: io arrays rosalind rosalind.util ;
IN: rosalind.sol.dna

: rosalind-dna ( -- ) 
    readln nucleotides 4array as-string print 
;

MAIN: rosalind-dna