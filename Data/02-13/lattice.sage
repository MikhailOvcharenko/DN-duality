# Mixed blocks of the intersection matrix on the lattice L_lambda
pencil_LG_lattice_mixed_blocks = (matrix(ZZ, ((1, 1, 0, 0, 0, 1))),
                                  matrix(ZZ, ((0, 0, 1, 1, 0, 0))),
                                  matrix(ZZ, ((0, 1, 1, 0, 1, 0))),
                                  matrix(ZZ, ((0, 0, 0, 1, 0, 0),
                                              (1, 0, 0, 0, 0, 0),
                                              (0, 0, 0, 0, 0, 0),
                                              (0, 0, 0, 0, 0, 0),
                                              (0, 0, 0, 0, 1, 0))),
                                  matrix(ZZ, ((0, 1, 0, 0, 0, 0))),
                                  matrix(ZZ, ((0, 0, 1, 0, 0, 0),
                                              (0, 0, 0, 0, 0, 1))),
                                  matrix(ZZ, ((0, 0, 0, 1, 0, 0))));

# Is the intersection matrix on the lattice L_lambda non-degenerate?
pencil_LG_lattice_nondegenerate = True;

# Is the degree of the Picard--Fuchs operator of
# the toric Landau--Ginzburg model equals to (22 - rk(L_lambda))?
pencil_LG_lattice_rank_is_expected = True;

# Does the absolute Galois group acts trivially on the lattice L_lambda?
pencil_LG_lattice_galois_action_trivial = True;

# Selected generators of the discriminant group of the lattice L_S
pencil_LS_lattice_disc_group_generators = \
    ((0, 1/2, 0, 1/2, 0, 0, 0, 0, 0, 1/2, 0, 0, 1/2, 0, 0, 0, 0, 1/2),
     (5/6, 3/4, 5/12, 1/4, 1/2, 1/12, 2/3, 1/4, 3/4,
      5/6, 1/6, 0, 2/3, 1/2, 1/2, 0, 5/6, 1/2));

# Selected generators of the discriminant group of its orthogonal complement
pencil_LS_lattice_orthogonal_complement_disc_group_generators = \
    ((0, 0, 1/2, 0),
     (0, 0, 3/4, 1/12));
