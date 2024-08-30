##load kmc
ml kmc

##1. get kmer counts for each subgenome
kmc -k15 -fm Yanli_A.fa subA . 
kmc -k15 -fm Yanli_B.fa subB .
kmc -k15 -fm Yanli_C.fa subC .
kmc -k15 -fm Yanli_D.fa subD .

##2. get kmer counts for each intermediate polyploid
kmc_tools simple subC -ci100 subD -ci100 intersect tetra_all
kmc_tools simple tetra_all -ci100 subB -ci100 intersect hex_all
kmc_tools simple hex_all -ci100 subA -ci100 intersect shared

##3. get specific kmers for each intermediate polyploid
kmc_tools simple tetra_all hex_all kmers_subtract tetra_int
kmc_tools simple hex_all shared kmers_subtract hex_int
kmc_tools simple tetra_int subA -ci10 kmers_subtract tetra_sp
kmc_tools simple hex_int subA -ci10 kmers_subtract hex_sp
kmc_tools simple tetra_sp subB -ci10 kmers_subtract tetra_sp1

##4.get subgenome specific kmers
touch subB.par1
echo "
INPUT:
set1 = subA -ci10
set2 = subB -ci100
set3 = subC -ci10
set4 = subD -ci10
OUTPUT:
sp_subB = set2 - (set1 + set3 + set4)
OUTPUT_PARAMS:
" >> subB.par1
##Repeat for other four subgenomes



##5. get subgenome specific kmers
kmc_tools complex subA.par1
kmc_tools complex subB.par1
kmc_tools complex subC.par1
kmc_tools complex subD.par1

##6. Extract Kmer sequences for each kmer set 
kmc_tools transform sp_subA dump sp_subA.txt
kmc_tools transform sp_subB dump sp_subB.txt
kmc_tools transform sp_subC dump sp_subC.txt
kmc_tools transform sp_subD dump sp_subD.txt
kmc_tools transform hex_sp dump hex_sp.txt
kmc_tools transform tetra_sp1 dump tetra_sp1.txt
