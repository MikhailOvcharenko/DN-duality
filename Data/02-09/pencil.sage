# Irreducible components of the member of the pencil over infinity
pencil_infinity_member_components = (CR_flattened.ideal(X),
                                     CR_flattened.ideal(Y),
                                     CR_flattened.ideal(Z),
                                     CR_flattened.ideal(T));

# Irredubible components of the base locus of the pencil
pencil_base_locus_components = (CR_flattened.ideal(X, T),
                                CR_flattened.ideal(Y, T),
                                CR_flattened.ideal(Z, T),
                                CR_flattened.ideal(X, Y + Z),
                                CR_flattened.ideal(X, Z + T),
                                CR_flattened.ideal(Y, X + Z),
                                CR_flattened.ideal(Y, Z + T),
                                CR_flattened.ideal(Z, Y + X),
                                CR_flattened.ideal(T, X + Y + Z),
                                CR_flattened.ideal(Z, Y*(X + T) + X*T));

# Irreducible components of reducible members of the pencil
# (apart from the member over infinity)
pencil_reducible_members_components = \
    (CR_flattened.ideal(l + 3, Z + T),
     CR_flattened.ideal(l + 3, X + Y + Z),
     CR_flattened.ideal(l + 3, T*(X + Y + Z) + X*Y));

# Is it possible to reduce the number of
# the integral generators of the group A_S?
pencil_AS_integral_generators_are_extractable = True;

# Indexes of the selected integral generators of the group A_S
pencil_AS_integral_generators = (1, 3, 4, 6, 11);

# Singular points of a general member of the pencil
pencil_general_member_singularities = (CR_flattened.ideal(X, Y, Z),
                                       CR_flattened.ideal(X, Z, T),
                                       CR_flattened.ideal(Y, Z, T),
                                       CR_flattened.ideal(X, T, Y + Z),
                                       CR_flattened.ideal(Y, T, X + Z),
                                       CR_flattened.ideal(Z, T, Y + X));

# Types of singularities of a general member of the pencil
pencil_general_member_singularities_types = \
    (('D', 4), ('A', 2), ('A', 2), ('A', 2), ('A', 2), ('A', 1));
