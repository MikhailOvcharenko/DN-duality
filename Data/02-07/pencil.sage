# Irreducible components of the member of the pencil over infinity
pencil_infinity_member_components = (CR_flattened.ideal(X),
                                     CR_flattened.ideal(Y),
                                     CR_flattened.ideal(Z),
                                     CR_flattened.ideal(T));

# Irredubible components of the base locus of the pencil
pencil_base_locus_components = (CR_flattened.ideal(Y, T),
                                CR_flattened.ideal(Y, X + Z),
                                CR_flattened.ideal(T, X + Z),
                                CR_flattened.ideal(X, Z*(Y + T) + Y*T),
                                CR_flattened.ideal(Y, T*(X + Z) + X*Z),
                                CR_flattened.ideal(Z, X*(Y + T) + Y*T),
                                CR_flattened.ideal(T, Y*(X + Z) + X*Z));

# Irreducible components of reducible members of the pencil
# (apart from the member over infinity)
pencil_reducible_members_components = \
    (CR_flattened.ideal(l + 5, (X + Z)*(Y + T) + Y*T),
     CR_flattened.ideal(l + 5, (X + T)*(Y + Z) + X*T + Y*Z));

# Is it possible to reduce the number of
# the integral generators of the group A_S?
pencil_AS_integral_generators_are_extractable = False;

# Indexes of the selected integral generators of the group A_S
pencil_AS_integral_generators = (1, 2, 3, 4, 6);

# Is it possible to reduce the number of
# the rational generators of the group A_S?
pencil_AS_rational_generators_are_extractable = True;

# Indexes of the selected rational generators of the group A_S
pencil_AS_rational_generators = (1, 2, 3, 4);

# Singular points of a general member of the pencil
pencil_general_member_singularities = (CR_flattened.ideal(X, Y, Z),
                                       CR_flattened.ideal(X, Y, T),
                                       CR_flattened.ideal(X, Z, T),
                                       CR_flattened.ideal(Y, Z, T),
                                       CR_flattened.ideal(Y, T, X + Z));

# Types of singularities of a general member of the pencil
pencil_general_member_singularities_types = \
    (('D', 4), ('A', 3), ('D', 4), ('A', 3), ('A', 1));
