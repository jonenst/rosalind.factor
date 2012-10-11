!
!

USING: io math.parser math.functions rosalind ;
IN: rosalind.sol.prtm

: rosalind-prtm ( -- ) readln mass .01 floor-to float>string print ;

MAIN: rosalind-prtm