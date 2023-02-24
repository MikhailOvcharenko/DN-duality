# Mixed blocks of the intersection matrix on the lattice L_lambda
pencil_LG_lattice_mixed_blocks = (matrix(ZZ, ((1, 0, 0),
                                              (0, 0, 0),
                                              (0, 0, 0),
                                              (0, 1, 0))),
                                  matrix(ZZ, ((1, 0, 0),
                                              (0, 0, 0),
                                              (0, 0, 1))),
                                  matrix(ZZ, ((0, 1, 0),
                                              (0, 0, 0),
                                              (0, 0, 1))),
                                  matrix(ZZ, ((0, 1, 0))),
                                  matrix(ZZ, ((0, 0, 1),
                                              (0, 0, 0),
                                              (0, 0, 0))));

# Is the intersection matrix on the lattice L_lambda non-degenerate?
pencil_LG_lattice_nondegenerate = True;

# Is the degree of the Picard--Fuchs operator of
# the toric Landau--Ginzburg model equals to (22 - rk(L_lambda))?
pencil_LG_lattice_rank_is_expected = True;

# Does the absolute Galois group acts trivially on the lattice L_lambda?
pencil_LG_lattice_galois_action_trivial = True;

# Selected generators of the discriminant group of the lattice L_S
pencil_LS_lattice_disc_group_generators = \
    ((6/11, 4/11, 2/11, 0, 10/11, 1/11, 3/11, 5/22, 7/11,
      1/22, 9/22, 13/22, 8/11, 19/22, 8/11, 9/11, 5/11),);

# Selected generators of the discriminant group of its orthogonal complement
pencil_LS_lattice_orthogonal_complement_disc_group_generators = \
    ((0, 0, 25/11, 9/22, -5/11),);
