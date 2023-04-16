# Irreducible components of the member of the pencil over infinity
pencil_infinity_member_components = (CR_flattened.ideal(X),
                                     CR_flattened.ideal(Y),
                                     CR_flattened.ideal(Z),
                                     CR_flattened.ideal(T));

# Irredubible components of the base locus of the pencil
pencil_base_locus_components = (CR_flattened.ideal(X, T),
                                CR_flattened.ideal(Y, T),
                                CR_flattened.ideal(X, Y + Z),
                                CR_flattened.ideal(Y, X + Z),
                                CR_flattened.ideal(T, X + Z),
                                CR_flattened.ideal(T, Y + Z),
                                CR_flattened.ideal(Z, X*Y + T*(X + Y)));

# Irreducible components of reducible members of the pencil
# (apart from the member over infinity)
pencil_reducible_members_components = ();

# Is it possible to reduce the number of
# the integral generators of the group A_S?
pencil_AS_integral_generators_are_extractable = False;

# Indexes of the selected integral generators of the group A_S
pencil_AS_integral_generators = (1, 2, 3, 4, 5, 7);

# Is it possible to reduce the number of
# the rational generators of the group A_S?
pencil_AS_rational_generators_are_extractable = True;

# Indexes of the selected rational generators of the group A_S
pencil_AS_rational_generators = (1, 2, 3, 5);

# Auxiliary ramified covering of the projective line (l = ...)
pencil_generic_member_base_field_extension = - 2 + 1/(m*(m - 1));

# Singular points of a general member of the pencil
pencil_general_member_singularities = \
    (CR_flattened.ideal(X, Y, Z),
     CR_flattened.ideal(X, Y, T),
     CR_flattened.ideal(X, Z, T),
     CR_flattened.ideal(Y, Z, T),
     CR_flattened.ideal(X, T, Y + Z),
     CR_flattened.ideal(Y, T, X + Z),
     CR_flattened.ideal(m*X - (1 - m)*Y, Z, (m - 1)*Y - T),
     CR_flattened.ideal((1 - m)*X - m*Y, Z, (m - 1)*X - T));

# Types of singularities of a general member of the pencil
pencil_general_member_singularities_types = \
    (('D', 4), ('A', 1), ('A', 1), ('A', 1), \
     ('A', 3), ('A', 3), ('A', 1), ('A', 1));
