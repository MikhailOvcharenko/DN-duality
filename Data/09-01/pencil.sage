# Irreducible components of the member of the pencil over infinity
pencil_infinity_member_components = (CR_flattened.ideal(Y),
                                     CR_flattened.ideal(Z),
                                     CR_flattened.ideal(X*Z - T*(X - T)));

# Irredubible components of the base locus of the pencil
pencil_base_locus_components = (CR_flattened.ideal(X, T),
                                CR_flattened.ideal(Y, Z),
                                CR_flattened.ideal(Y, X*Z - T*(X - T)),
                                CR_flattened.ideal(Z, X^3 + Y*T*(X - T)));

# Irreducible components of reducible members of the pencil
# (apart from the member over infinity)
pencil_reducible_members_components = ();

# Is it possible to reduce the number of
# the integral generators of the group A_S?
pencil_AS_integral_generators_are_extractable = True;

# Indexes of the selected integral generators of the group A_S
pencil_AS_integral_generators = (1, 2, 5);

# Auxiliary ramified covering of the projective line (l = ...)
pencil_generic_member_base_field_extension = 2 + 1/(m*(m - 1));

# Singular points of a general member of the pencil
pencil_general_member_singularities = \
    (CR_flattened.ideal(X, Y, Z),
     CR_flattened.ideal(X, Z, T),
     CR_flattened.ideal(X, T, (m - 1)*Y - m*Z),
     CR_flattened.ideal(X, T, m*Y - (m - 1)*Z));

# Types of singularities of a general member of the pencil
pencil_general_member_singularities_types = \
    (('A', 5), ('A', 1), ('A', 5), ('A', 5));
