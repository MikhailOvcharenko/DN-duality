# Mixed blocks of the intersection matrix on the lattice L_lambda
pencil_LG_lattice_mixed_blocks = (matrix(ZZ, ((0, 0, 1, 0, 0, 0, 0, 0),
                                              (0, 0, 0, 0, 0, 0, 0, 0),
                                              (1, 0, 0, 0, 0, 0, 0, 0),
                                              (0, 0, 0, 0, 0, 0, 0, 0))),
                                  matrix(ZZ, ((0, 0, 0, 0, 1, 0, 0, 0),
                                              (0, 0, 0, 1, 0, 0, 0, 0))),
                                  matrix(ZZ, ((0, 0, 0, 0, 0, 1, 0, 0),
                                              (0, 0, 0, 0, 0, 0, 0, 0),
                                              (0, 1, 0, 0, 0, 0, 0, 0),
                                              (0, 0, 0, 0, 0, 0, 1, 0))));

# Is the intersection matrix on the lattice L_lambda non-degenerate?
pencil_LG_lattice_nondegenerate = True;

# Is the degree of the Picard--Fuchs operator of
# the toric Landau--Ginzburg model equals to (22 - rk(L_lambda))?
pencil_LG_lattice_rank_is_expected = True;

# Does the absolute Galois group acts trivially on the lattice L_lambda?
pencil_LG_lattice_galois_action_trivial = True;

# Selected generators of the discriminant group of the lattice L_S
pencil_LS_lattice_disc_group_generators = \
    ((16/29, 7/29, 27/29, 28/29, 12/29, 26/29, 22/29, 2/29, 11/29,
      1/29, 19/29, 19/29, 25/29, 11/29, 27/29, 13/29, 20/29, 10/29),);

# Selected generators of the discriminant group of its orthogonal complement
pencil_LS_lattice_orthogonal_complement_disc_group_generators = \
    ((0, 0, 16/29, 1/29),);
