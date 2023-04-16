# Irreducible components of the member of the pencil over infinity
pencil_infinity_member_components = (CR_flattened.ideal(X),
                                     CR_flattened.ideal(Y),
                                     CR_flattened.ideal(A^3 - B*C*(A - B)));

# Irredubible components of the base locus of the pencil
pencil_base_locus_components = (CR_flattened.ideal(A, C),
                                CR_flattened.ideal(X, A^3 - B*C*(A - B)),
                                CR_flattened.ideal(Y, A^3 - B*C*(A - B)));

# Irreducible components of reducible members of the pencil
# (apart from the member over infinity)
pencil_reducible_members_components = ();

# Is it possible to reduce the number of
# the integral generators of the group A_S?
pencil_AS_integral_generators_are_extractable = True;

# Indexes of the selected integral generators of the group A_S
pencil_AS_integral_generators = (1, 2, 5);

# Auxiliary ramified covering of the projective line (l = ...)
pencil_generic_member_base_field_extension = - 4 + 1/(m*(m - 1));

# Singular points of a general member of the pencil
pencil_general_member_singularities = \
    (CR_flattened.ideal(A, C, m*X - (m - 1)*Y),
     CR_flattened.ideal(A, C, (m - 1)*X - m*Y));

# Types of singularities of a general member of the pencil
pencil_general_member_singularities_types = (('A', 8), ('A', 8));
