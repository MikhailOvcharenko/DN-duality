# Irreducible components of the member of the pencil over infinity
pencil_infinity_member_components = (CR_flattened.ideal(X),
                                     CR_flattened.ideal(Y),
                                     CR_flattened.ideal(Z),
                                     CR_flattened.ideal(T));

# Irredubible components of the base locus of the pencil
pencil_base_locus_components = (CR_flattened.ideal(X, Y),
                                CR_flattened.ideal(Z, T),
                                CR_flattened.ideal(X, Z + T),
                                CR_flattened.ideal(Y, Z + T),
                                CR_flattened.ideal(Z, X + Y),
                                CR_flattened.ideal(Z, X + T),
                                CR_flattened.ideal(Z, Y + T),
                                CR_flattened.ideal(T, X + Y),
                                CR_flattened.ideal(T, X + Z),
                                CR_flattened.ideal(T, Y + Z),
                                CR_flattened.ideal(X, Y + Z + T),
                                CR_flattened.ideal(Y, X + Z + T));

# Irreducible components of reducible members of the pencil
# (apart from the member over infinity)
pencil_reducible_members_components = (CR_flattened.ideal(l + 4, X + Y),
                                       CR_flattened.ideal(l + 4, Z + T),
                                       CR_flattened.ideal(l + 4, X + Z + T),
                                       CR_flattened.ideal(l + 4, Y + Z + T));

# Is it possible to reduce the number of
# the integral generators of the group A_S?
pencil_AS_integral_generators_are_extractable = True;

# Indexes of the selected integral generators of the group A_S
pencil_AS_integral_generators = (1, 2, 3, 6, 10, 13);

# Singular points of a general member of the pencil
pencil_general_member_singularities = (CR_flattened.ideal(X, Z, T),
                                       CR_flattened.ideal(Y, Z, T),
                                       CR_flattened.ideal(X, Y, Z + T),
                                       CR_flattened.ideal(Z, T, X + Y));

# Types of singularities of a general member of the pencil
pencil_general_member_singularities_types = \
    (('A', 3), ('A', 3), ('A', 5), ('A', 1));
