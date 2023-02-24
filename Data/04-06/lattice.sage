# Mixed blocks of the intersection matrix on the lattice L_lambda
pencil_LG_lattice_mixed_blocks = (matrix(ZZ, ((1, 1, 0, 1, 0, 0, 0))),
                                  matrix(ZZ, ((1, 0, 1, 0, 0, 0, 0),
                                              (0, 0, 0, 0, 0, 0, 0),
                                              (0, 0, 0, 0, 1, 0, 0))),
                                  matrix(ZZ, ((0, 1, 1, 0, 0, 1, 0))),
                                  matrix(ZZ, ((0, 0, 0, 0, 1, 0, 0),
                                              (0, 0, 0, 1, 0, 0, 0),
                                              (0, 0, 0, 0, 0, 1, 0))),
                                  matrix(ZZ, ((0, 1, 0, 0, 0, 0, 0))));

# Is the intersection matrix on the lattice L_lambd} non-degenerate?
pencil_LG_lattice_nondegenerate = True;

# Is the degree of the Picard--Fuchs operator of
# the toric Landau--Ginzburg model equals to (22 - rk(L_lambda))?
pencil_LG_lattice_rank_is_expected = True;

# Does the absolute Galois group acts trivially on the lattice L_lambda?
pencil_LG_lattice_galois_action_trivial = True;

# Selected generators of the discriminant group of the lattice L_S
pencil_LS_lattice_disc_group_generators = \
    ((11/13, 7/13, 28/39, 35/39, 23/39, 2/13, 3/13, 28/39,
      7/39, 29/39, 14/39, 8/13, 23/39, 1/13, 8/39, 4/39),);

# Selected generators of the discriminant group of its orthogonal complement
pencil_LS_lattice_orthogonal_complement_disc_group_generators = \
    ((0, 0, -31/39, -19/39, -25/39, 1/39),);
