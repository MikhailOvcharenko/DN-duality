# Irreducible components of the member of the pencil over infinity
pencil_infinity_member_components = (CR_flattened.ideal(X),
                                     CR_flattened.ideal(Y),
                                     CR_flattened.ideal(Z),
                                     CR_flattened.ideal(T));

# Irredubible components of the base locus of the pencil
pencil_base_locus_components = \
    (CR_flattened.ideal(X, Y),
     CR_flattened.ideal(X, Z),
     CR_flattened.ideal(X, T),
     CR_flattened.ideal(Y, a_2*Z + T),
     CR_flattened.ideal(Y, a_5*Z + T),
     CR_flattened.ideal(Y, Z + a_1*a_3*a_6*T),
     CR_flattened.ideal(Z, Y + a_1*a_3*T),
     CR_flattened.ideal(Z, Y + a_1*a_6*T),
     CR_flattened.ideal(Z, a_4*a_7*Y + T),
     CR_flattened.ideal(T, \
                        (a_4*Y + Z)*(a_7*Y + Z)*(Y + a_1*a_2*a_5*Z) + X*Y*Z));

# Irreducible components of reducible members of the pencil
# (apart from the member over infinity)
pencil_reducible_members_components = ();

# Is it possible to reduce the number of
# the integral generators of the group A_S?
pencil_AS_integral_generators_are_extractable = True;

# Indexes of the selected integral generators of the group A_S
pencil_AS_integral_generators = (1, 3, 4, 5, 7, 8, 11);

# Singular points of a general member of the pencil
pencil_general_member_singularities = \
    (CR_flattened.ideal(Y, Z, T),
     CR_flattened.ideal(X, T, a_4*Y + Z),
     CR_flattened.ideal(X, T, a_7*Y + Z),
     CR_flattened.ideal(X, T, Y + a_1*a_2*a_5*Z));

# Types of singularities of a general member of the pencil
pencil_general_member_singularities_types = \
    (('A', 2), ('A', 1), ('A', 1), ('A', 1));
