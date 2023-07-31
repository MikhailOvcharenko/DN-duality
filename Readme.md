# Dolgachev--Nikulin duality for fibers of toric Landau--Ginzburg models of smooth Fano threefolds

Author: Mikhail Ovcharenko.

We construct the Dolgachev--Nikulin dual lattice to the Picard lattice of a general anticanonical section for any smooth Fano threefold in Mori--Mukai classification, following ``Modularity of Landau--Ginzburg models'' by Doran--Harder--Katzarkov--Ovcharenko--Przyjalkowski  (see [arXiv:2307.15607](https://arxiv.org/abs/2307.15607)).

For any details regarding this code, contact me at <ovcharenko@mi-ras.ru>.

The code runs using Sage 9.5 or more recent versions.

## How to run

The following command prints the main information on the construction of the Dolgachev--Nikulin dual lattice to the Picard group of a general anticanonical section of a smooth Fano threefold:

`sage ./Reports/rank-familyno.sage`

e.g.,

`sage ./Reports/04-03.sage`

For families no. 2.34, 3.27, 3.28, 4.11, 5.3, 6.1, 7.1, and 8.1 there is also available the parametrized version of the construction, i.e., the construction for a general fiber of the toric Landau--Ginzburg model for a pair (X, D). The corresponding command is

`sage ./Reports/parametrized/rank-familyno.sage`

e.g.,

`sage ./Reports/parametrized/03-27.sage`

## Structure

The file structure is organized as follows.

1. `Library.sage` provides necessary tools for the construction of Dolgachev--Nikulin dual lattice.

2. `Reports` directory contains scripts describing all main steps of the construction.

3. `Data` contains intermediate computations of the construction of the Dolgachev--Nikulin dual lattice. More precisely, for any Fano threefold the directory `Data/rank-familyno` contains
    - `setup.sage`: the basic information on the Fano threefold and its toric Landau--Ginzburg model;
    - `pencil.sage`: the description of the base locus of the pencil and of the singular locus of its general member;
    - `resolution.sage`: the description of the minimal resolution of a general member of the pencil;
    - `lattice.sage`: the auxiliary information on the construction of the Dolgachev--Nikulin dual lattice.

4. `delPezzo` contains the implementation of Przyjalkowski's algorithm of the computation of a toric Landau--Ginzburg model for a pair (X, D), where X is a smooth del Pezzo surface with very ample anticanonical class (see [arXiv:1609.09740](https://arxiv.org/abs/1609.09740)).
