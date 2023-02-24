# Irreducible components of the member of the pencil over infinity
pencil_infinity_member_components = (CR_flattened.ideal(X),
                                     CR_flattened.ideal(Y),
                                     CR_flattened.ideal(Z),
                                     CR_flattened.ideal(T));

# Irredubible components of the base locus of the pencil
pencil_base_locus_components = \
    (CR_flattened.ideal(X, Y),
     CR_flattened.ideal(X, Z),
     CR_flattened.ideal(Y, Z),
     CR_flattened.ideal(Z, T),
     CR_flattened.ideal(X, Y + a_4*T),
     CR_flattened.ideal(X, a_1*a_2*a_5*Y + T),
     CR_flattened.ideal(Y, a_1*a_3*X + T),
     CR_flattened.ideal(Y, a_1*a_6*X + T),
     CR_flattened.ideal(T, a_1*(X + a_2*Y)*(X + a_5*Y)*(a_1*a_3*a_6*X + Y) + \
                        X*Y*Z));

# Arithmetic genus of strict transforms of components of the base locus
pencil_base_locus_components_strict_transforms_arithmetic_genus = \
    len(pencil_base_locus_components)*(0,);

# Irreducible components of reducible members of the pencil
# (apart from the member over infinity)
pencil_reducible_members_components = ();

# Is it possible to reduce the number of
# the integral generators of the group A_S?
pencil_AS_integral_generators_are_extractable = True;

# Indexes of the selected integral generators of the group A_S
pencil_AS_integral_generators = (1, 3, 4, 5, 7, 10);

# Singular points of a general member of the pencil
pencil_general_member_singularities = \
    (CR_flattened.ideal(X, Y, Z),
     CR_flattened.ideal(X, Y, T),
     CR_flattened.ideal(Z, T, X + a_2*Y),
     CR_flattened.ideal(Z, T, X + a_5*Y),
     CR_flattened.ideal(Z, T, a_1*a_3*a_6*X + Y));

# Types of singularities of a general member of the pencil
pencil_general_member_singularities_types = \
    (('A', 1), ('A', 3), ('A', 1), ('A', 1), ('A', 1));
