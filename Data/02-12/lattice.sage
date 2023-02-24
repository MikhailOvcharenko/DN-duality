# Mixed blocks of the intersection matrix on the lattice L_lambda
pencil_LG_lattice_mixed_blocks = (matrix(ZZ, ((0, 0, 1, 0, 0, 0),
                                              (0, 0, 0, 0, 0, 0),
                                              (0, 0, 0, 1, 0, 0),
                                              (0, 0, 0, 0, 0, 1))),
                                  matrix(ZZ, ((1, 1, 0, 0, 0, 0))),
                                  matrix(ZZ, ((1, 0, 0, 0, 1, 1))),
                                  matrix(ZZ, ((0, 1, 0, 0, 0, 1))),
                                  matrix(ZZ, ((1, 0, 1, 0, 0, 0),
                                              (0, 0, 0, 0, 0, 0),
                                              (0, 0, 0, 0, 0, 0))),
                                  matrix(ZZ, ((0, 1, 0, 1, 0, 0),
                                              (0, 0, 0, 0, 0, 0),
                                              (0, 0, 0, 0, 1, 0))),
                                  matrix(ZZ, ((0, 0, 0, 0, 0, 1))),
                                  matrix(ZZ, ((0, 0, 0, 0, 0, 1))));

# Is the intersection matrix on the lattice L_lambda non-degenerate?
pencil_LG_lattice_nondegenerate = False;

# Indexes of the selected integral basis of the lattice L_lambda
pencil_LG_lattice_integral_basis = \
    (1, 2, 3, 4, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21);

# Is the degree of the Picard--Fuchs operator of
# the toric Landau--Ginzburg model equals to (22 - rk(L_lambda))?
pencil_LG_lattice_rank_is_expected = True;

# Does the absolute Galois group acts trivially on the lattice L_lambda?
pencil_LG_lattice_galois_action_trivial = False;

# Galois orbits on the lattice L_lambda
pencil_LG_lattice_galois_orbits = \
    ((1,), (2,), (3,), (4,), (5,), (6,), (7,), (8,), (9,), (10,), (11,), (12,),
     (13,), (14, 15), (16,), (17,), (18,), (19,), (20,), (21,));

# Indexes of the selected integral basis of the lattice L_S
pencil_LS_lattice_integral_basis = \
    (1, 2, 3, 4, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20);

# Selected generators of the discriminant group of the lattice L_S
pencil_LS_lattice_disc_group_generators = \
    ((0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1/2, 0, 0, 0, 0, 0, 0),
     (2/5, 3/10, 4/5, 2/5, 3/5, 3/5, 2/5, 1/5, 4/5, 3/5,
      2/5, 1/2, 3/10, 7/10, 1/2, 3/10, 1/5, 1/2));

# Selected generators of the discriminant group of its orthogonal complement
pencil_LS_lattice_orthogonal_complement_disc_group_generators = \
    ((0, 0, 1/2, 0),
     (0, 0, 3/5, 1/10));
