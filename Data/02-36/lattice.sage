# Mixed blocks of the intersection matrix on the lattice L_lambda
pencil_LG_lattice_mixed_blocks = (matrix(ZZ, ((1, 0, 0),
                                              (0, 0, 0))),
                                  matrix(ZZ, ((0, 1, 0),
                                              (0, 0, 0),
                                              (0, 0, 0),
                                              (0, 0, 0),
                                              (1, 0, 0),
                                              (0, 0, 0))),
                                  matrix(ZZ, ((0, 1, 0),
                                              (0, 0, 0),
                                              (0, 0, 0),
                                              (0, 0, 0),
                                              (0, 0, 0),
                                              (0, 0, 0))),
                                  matrix(ZZ, ((0, 1, 0))));

# Is the intersection matrix on the lattice L_lambda non-degenerate?
pencil_LG_lattice_nondegenerate = True;

# Is the degree of the Picard--Fuchs operator of
# the toric Landau--Ginzburg model equals to (22 - rk(L_lambda))?
pencil_LG_lattice_rank_is_expected = True;

# Does the absolute Galois group acts trivially on the lattice L_lambda?
pencil_LG_lattice_galois_action_trivial = True;

# Selected generators of the discriminant group of the lattice L_S
pencil_LS_lattice_disc_group_generators = \
    ((2/5, 1/5, 2/5, 1/5, 0, 4/5, 3/5, 4/5, 4/5,
      0, 1/5, 2/5, 3/5, 4/5, 4/5, 3/5, 3/5, 1/5),);

# Selected generators of the discriminant group of its orthogonal complement
pencil_LS_lattice_orthogonal_complement_disc_group_generators = \
    ((0, 0, 0, 1/5),);
