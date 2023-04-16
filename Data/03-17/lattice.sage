# Mixed blocks of the intersection matrix on the lattice L_lambda
pencil_LG_lattice_mixed_blocks = (matrix(ZZ, ((1, 1, 0, 0, 0, 0),
                                              (0, 0, 0, 1, 0, 0))),
                                  matrix(ZZ, ((0, 1, 0, 0, 1, 0))),
                                  matrix(ZZ, ((0, 0, 0, 1, 0, 0),
                                              (0, 0, 0, 0, 0, 0),
                                              (0, 0, 1, 0, 0, 0),
                                              (0, 0, 0, 0, 1, 0))),
                                  matrix(ZZ, ((1, 0, 0, 0, 0, 0))),
                                  matrix(ZZ, ((0, 1, 0, 0, 0, 0),
                                              (0, 0, 0, 0, 0, 0))),
                                  matrix(ZZ, ((0, 0, 0, 0, 1, 0))));

# Is the intersection matrix on the lattice L_lambda non-degenerate?
pencil_LG_lattice_nondegenerate = True;

# Is the degree of the Picard--Fuchs operator of
# the toric Landau--Ginzburg model equals to (22 - rk(L_lambda))?
pencil_LG_lattice_rank_is_expected = False;

# Does the absolute Galois group acts trivially on the lattice L_lambda?
pencil_LG_lattice_galois_action_trivial = True;

# Selected generators of the discriminant group of the lattice L_S
pencil_LS_lattice_disc_group_generators = \
    ((17/28, 5/14, 19/28, 5/7, 9/28, 13/14, 6/7, 1/7, 5/7,
      6/7, 25/28, 2/7, 4/7, 19/28, 3/28, 11/14, 1/7),);

# Selected generators of the discriminant group of its orthogonal complement
pencil_LS_lattice_orthogonal_complement_disc_group_generators = \
    ((0, 0, -17/28, -3/28, 1/14),);
