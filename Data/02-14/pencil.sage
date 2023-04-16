# Irreducible components of the member of the pencil over infinity
pencil_infinity_member_components = (CR_flattened.ideal(X),
                                     CR_flattened.ideal(Y),
                                     CR_flattened.ideal(Z),
                                     CR_flattened.ideal(T));

# Irredubible components of the base locus of the pencil
pencil_base_locus_components = (CR_flattened.ideal(X, T),
                                CR_flattened.ideal(Y, T),
                                CR_flattened.ideal(Y, Z + T),
                                CR_flattened.ideal(X, Y + Z + T),
                                CR_flattened.ideal(X, (Z + T)^2 + Y*T),
                                CR_flattened.ideal(Z, Y*(X + T) + T^2),
                                CR_flattened.ideal(T, X*(Y + Z) + Z^2));

# Irreducible components of reducible members of the pencil
# (apart from the member over infinity)
pencil_reducible_members_components = ();

# Is it possible to reduce the number of
# the integral generators of the group A_S?
pencil_AS_integral_generators_are_extractable = True;

# Indexes of the selected integral generators of the group A_S
pencil_AS_integral_generators = (3, 4, 6, 7);

# Singular points of a general member of the pencil
pencil_general_member_singularities = \
    (CR_flattened.ideal(X, Z, T),
     CR_flattened.ideal(Y, Z, T),
     CR_flattened.ideal(X, Y, Z + T),
     CR_flattened.ideal(X, Z, Y + T),
     CR_flattened.ideal(Y, X - (l + 3)*T, Z + T),
     CR_flattened.ideal(Z, X - (l + 3)*T, (l + 4)*Y + T));

# Types of singularities of a general member of the pencil
pencil_general_member_singularities_types = \
    (('D', 5), ('A', 3), ('A', 2), ('A', 1), ('A', 2), ('A', 1));