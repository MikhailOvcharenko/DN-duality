# Irreducible components of the member of the pencil over infinity
pencil_infinity_member_components = (CR_flattened.ideal(Y),
                                     CR_flattened.ideal(X + Y),
                                     CR_flattened.ideal(B*C*(A - B) - A^3));

# Irredubible components of the base locus of the pencil
pencil_base_locus_components = (CR_flattened.ideal(Y, C),
                                CR_flattened.ideal(A, C),
                                CR_flattened.ideal(X, B*C*(A - B) - A^3),
                                CR_flattened.ideal(X + Y, B*C*(A - B) - A^3));

# Irreducible components of reducible members of the pencil
# (apart from the member over infinity)
pencil_reducible_members_components = \
    (CR_flattened.ideal(l + 1, X),
     CR_flattened.ideal(l + 1, Y*(A^3 - A*B*C + B^2*C) + C^3*(X + Y)));

# Is it possible to reduce the number of
# the integral generators of the group A_S?
pencil_AS_integral_generators_are_extractable = True;

# Indexes of the selected integral generators of the group A_S
pencil_AS_integral_generators = (1, 2, 5);

# Singular points of a general member of the pencil
pencil_general_member_singularities = (CR_flattened.ideal(Y, A, C),
                                       CR_flattened.ideal(A, C, l*(X + Y) + Y));

# Types of singularities of a general member of the pencil
pencil_general_member_singularities_types = (('A', 8), ('A', 8));
