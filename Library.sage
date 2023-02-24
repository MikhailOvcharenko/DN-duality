import sys
from sage.matrix.matrix_space import is_MatrixSpace
from sage.rings.fraction_field import is_FractionField
from sage.rings.polynomial.flatten import FlatteningMorphism
from sage.rings.polynomial.laurent_polynomial_ring \
    import is_LaurentPolynomialRing
from sage.rings.polynomial.multi_polynomial_ring_base import is_MPolynomialRing


## Polynomial computations

def polynomial_chart_image(polynomial, chart_index):
    """
    Returns the image of a homogeneous polynomial in a standard affine chart.

    Arguments:
        polynomial : An element of a polynomial ring.
        chart_index : Index of a generator of the parent polynomial ring.

    Returns:
        An element of the parent polynomial ring.

    Example:
        sage : C.<a_1,a_2> = PolynomialRing(ZZ);
        sage : R.<X,Y,Z,T> = PolynomialRing(C);
        sage : polynomial_chart_image(a_1*X^3 + a_2*X*Y*Z + a_1*a_2*T^3, 0)
        sage : a_1*a_2*T^3 + a_2*Y*Z + a_1
    """
    parent_ring = polynomial.parent();

    # Sanity check
    if not is_MPolynomialRing(parent_ring):
        raise ValueError("The first argument should be a polynomial.");
    
    if not polynomial.is_homogeneous():
        raise ValueError("The polynomial is not homogeneous.");

    if not chart_index in range(parent_ring.ngens()):
        raise ValueError("Incorrect index of the generator.");

    # Arguments tuple for the affine chart
    arguments_list = list(parent_ring.gens());
    arguments_list[chart_index] = 1;

    return polynomial(tuple(arguments_list));

def polynomial_argument_shift(polynomial, shift_list):
    """
    Returns the argument shift of a polynomial.

    Arguments:
        polynomial : An element of a polynomial ring.
        shift_list : A list of elements of the parent polynomial ring
            of length (polynomial.parent()).ngens().

    Returns:
        An element of the parent polynomial ring.

    Example:
        sage : C.<a_1,a_2> = PolynomialRing(QQ);
        sage : R.<X,Y> = PolynomialRing(C);
        sage : polynomial_argument_shift(X^2, (a_1*Y, a_2))
        sage : X^2 + 2*a_1*X*Y + a_1^2*Y^2
    """
    parent_ring = polynomial.parent();
    
    # Sanity check
    if not is_MPolynomialRing(parent_ring):
        raise ValueError("The first argument should be a polynomial.");
    
    if (len(shift_list) != parent_ring.ngens()):
        raise ValueError("Incorrect length of the shift list.");
   
    for i in shift_list:
        if not (i in parent_ring):
            raise ValueError("Incorrect elements of the shift list.");
        
    # Shifted arguments tuple
    arguments_list = list(parent_ring.gens());
    arguments_list_shifted = \
        tuple([add(i) for i in zip(arguments_list, shift_list)]);

    return polynomial(tuple(arguments_list_shifted));

def polynomial_affine_image(polynomial, affine_data):
    """
    Returns the image of a homogeneous polynomial in a standard affine chart
    composed with the argument shift.

    Arguments:
        polynomial : An element of a polynomial ring.
        affine_data : A list of the form [chart_index, shift_list].
        chart_index : Index of a generator of the parent polynomial ring.
        shift_list : A list of elements of the parent polynomial ring
            of length (polynomial.parent()).ngens().

    Returns:
        An element of the parent polynomial ring.

    Example:
        sage : C.<a_1,a_2> = PolynomialRing(QQ);
        sage : R.<X,Y> = PolynomialRing(C);
        sage : polynomial_affine_image((a_1*X + Y)^2, (0, (0, -a_1)))
        sage : Y^2
    """
    parent_ring = polynomial.parent();

    try:
        affine_image = polynomial_chart_image(polynomial, affine_data[0]);
        resulting_polynomial = \
            polynomial_argument_shift(affine_image, affine_data[1]);
    except (TypeError, ValueError):
        raise ValueError("The data is incompatible with the polynomial.");

    return resulting_polynomial;

def polynomial_homogenization(polynomial, affine_data):
    """
    Returns the homogenization of a polynomial after
    the *negative* argument shift.

    Arguments:
        polynomial : An element of a polynomial ring.
        affine_data : A list of the form [chart_index, shift_list].
        chart_index : Index of a generator of the parent polynomial ring.
        shift_list : A list of elements of the parent polynomial ring
            of length (polynomial.parent()).ngens().

    Returns:
        An element of the parent polynomial ring.

    Example:
        sage : C.<a_1,a_2> = PolynomialRing(QQ);
        sage : R.<X,Y> = PolynomialRing(C);
        sage : polynomial_homogenization(Y^2, (0, (0, a_1)))
        sage : a_1^2*X^2 + 2*a_1*X*Y + Y^2
    """
    parent_ring = polynomial.parent();

    # Sanity check
    if not is_MPolynomialRing(parent_ring):
        raise ValueError("The first argument should be a polynomial.");

    if not affine_data[0] in range(parent_ring.ngens()):
        raise ValueError("Incorrect index of the generator.");

    if (len(affine_data[1]) != parent_ring.ngens()):
        raise ValueError("Incorrect length of the shift list.");
   
    for i in affine_data[1]:
        if not (i in parent_ring):
            raise ValueError("Incorrect elements of the shift list.");
    
    negative_shift = -vector(affine_data[1]);
    var = (parent_ring.gens())[affine_data[0]];
    
    try:
        polynomial_shifted = \
            polynomial_argument_shift(polynomial, negative_shift);
        resulting_polynomial = polynomial_shifted.homogenize(var);
    except (TypeError, ValueError):
        raise ValueError("The data is incompatible with the polynomial.");

    return resulting_polynomial;

def polynomial_initial_form(polynomial):
    """
    Returns the initial form of a polynomial.

    Arguments:
        polynomial : An element of a polynomial ring.

    Returns:
        An element of the parent polynomial ring.

    Example:
        sage : C.<a_1,a_2> = PolynomialRing(QQ);
        sage : R.<X,Y,Z,T> = PolynomialRing(C);
        sage : polynomial_initial_form(a_1*a_2*T^3 + a_2*Y*Z + a_1)
        sage : a_2*Y*Z
    """
    parent_ring = polynomial.parent();

    # Sanity check
    if not is_MPolynomialRing(parent_ring):
        raise ValueError("The argument should be a polynomial.");
    
    # Shift the polynomial at the free coefficient
    polynomial_shifted = polynomial - polynomial.constant_coefficient();
    
    # Exclude the trivial case
    if (polynomial_shifted == 0) : return 0;

    # Extract the homogeneous parts
    from collections import defaultdict
    dictionary = defaultdict(PolynomialRing(ZZ, parent_ring.gens()));
    for coefficient,monomial in polynomial_shifted:
        dictionary[monomial.degree()] += coefficient * monomial;

    # Pick the minimal homogeneous part
    for i in range(polynomial_shifted.degree() + 1):
        if (dictionary[i] != 0):
            polynomial_initial_form = dictionary[i];
            break;

    return polynomial_initial_form;

def ideal_affine_image(homogeneous_ideal, affine_list):
    """
    Returns the image of a homogeneous ideal in a standard affine chart
    composed with the argument shift.

    Arguments:
        homogeneous_ideal : An ideal in a polynomial ring.
        affine_list : A list of the form [chart_indexes, shift_list].
        chart_index : Index of a generator of the parent polynomial ring.
        shift_list : A list of elements of the parent polynomial ring
            of length (homogeneous_ideal.ring()).ngens().

    Returns:
        An ideal in the parent polynomial ring.

    Example:
        sage : C.<a_1,a_2> = PolynomialRing(QQ);
        sage : R.<X,Y> = PolynomialRing(C);
        sage : I = R.ideal((a_1*X + Y)^2);
        sage : ideal_affine_image(I, (0, (0, -a_1)))
        sage : Ideal (Y^2) of Multivariate Polynomial Ring in X, Y over
               Multivariate Polynomial Ring in a_1, a_2 over Rational Field
    """
    parent_ring = homogeneous_ideal.ring();

    # Construct affine images of generators of the ideal
    generators_list = [];
    try:
        for gen in homogeneous_ideal.gens():
            gen_affine_image = polynomial_affine_image(gen, affine_list);
            generators_list.append(gen_affine_image);
    except (TypeError, ValueError):
        raise ValueError("The affinization data is "
                         "incompatible with the ideal.");

    return parent_ring.ideal(generators_list);

def ideal_homogenize(affine_ideal, affine_list):
    """
    Returns the homogenization of an ideal after the negative argument shift.

    Arguments:
        affine_ideal : An ideal in a polynomial ring.
        affine_list : A list of the form [chart_indexes, shift_list].
        chart_index : Index of a generator of the parent polynomial ring.
        shift_list : A list of elements of the parent polynomial ring
            of length (affine_ideal.ring()).ngens().

    Returns:
        An ideal in the parent polynomial ring.

    Example:
        sage : C.<a_1,a_2> = PolynomialRing(QQ);
        sage : R.<X,Y> = PolynomialRing(C);
        sage : I = R.ideal(Y^2);
        sage : ideal_homogenize(I, [0, [0, -a_1]])
        sage : Ideal ((a_1*X + Y)^2) of Multivariate Polynomial Ring in X, Y
               over Multivariate Polynomial Ring in a_1, a_2 over Rational Field
    """
    parent_ring = affine_ideal.ring();

    # Sanity check
    if not (affine_list[0] in range(parent_ring.ngens())):
        raise ValueError("Index of a generator is incompatible with the "
                         "ideal."); 

    # Homogenize the generators of the ideal
    generators_list = [];
    negative_shift = -vector(affine_list[1]);
    var = (parent_ring.gens())[affine_list[0]];

    try:
        for gen in affine_ideal.gens():
            gen_shifted = polynomial_argument_shift(gen, negative_shift);
            generators_list.append(gen_shifted.homogenize(var));
    except (TypeError, ValueError):
        raise ValueError("The shift list is incompatible with the ideal.");

    return parent_ring.ideal(generators_list);

def ideal_tangent_cone(affine_ideal):
    """
    Returns the ideal of the tangent cone at the origin of an affine variety.

    Arguments:
        affine_ideal : An ideal in a polynomial ring.

    Returns:
        An ideal in the parent polynomial ring.

    Example:
        sage : C.<a_1,a_2> = PolynomialRing(QQ);
        sage : R.<X,Y,Z> = PolynomialRing(C);
        sage : I = R.ideal((a_1*X + 1)^2 + a_2*Y^3 + Z^3);
        sage : ideal_tangent_cone(I)
        sage : Ideal (2*a_1*X) of Multivariate Polynomial Ring in X, Y, Z over
               Multivariate Polynomial Ring in a_1, a_2 over Rational Field
    """
    parent_ring = affine_ideal.ring();

    return parent_ring.ideal([polynomial_initial_form(gen) \
                              for gen in affine_ideal.gens()]);

def blowup(polynomial, chart_index):
    """
    Returns the strict transform of an affine hypersurface for
    the blow-up at the origin in a standard affine chart.

    Arguments:
        polynomial : An element of a polynomial ring.
        chart_index : Index of a generator of the parent polynomial ring.

    Returns:
        An element of the parent polynomial ring.

    Example:
        sage : C.<a,b> = PolynomialRing(QQ);
        sage : R.<X,Y,Z> = PolynomialRing(C);
        sage : blowup(a*(a*X^2 + b*Y^3 + Z^3), 2)
        sage : a^2*X^2 + a*Z*(b*Y^3 + 1)
    """
    polynomial_parent = polynomial.parent();

    # Sanity check
    if not (chart_index in range(polynomial_parent.ngens())):
        raise ValueError('Incorrect index of the generator.');

    # Strict transform in the standard affine chart
    gen = polynomial_parent.gen(chart_index);    
    arguments_list = [];
    for i in range(polynomial_parent.ngens()):
        if (i != chart_index):
            arguments_list.append(gen * polynomial_parent.gen(i));
        else:
            arguments_list.append(gen);
    strict_transform_prep = polynomial(tuple(arguments_list));

    # Compute the zero order of the polynomial at (gen = 0)
    for i in range(strict_transform_prep.degree(gen)):
        if (strict_transform_prep % (gen^(i + 1)) == 0) and \
           (strict_transform_prep % (gen^(i + 2)) != 0):
            zero_order = i + 1;
            break;

    # Return the equation of the strict transform
    return strict_transform_prep // gen^zero_order;

def exceptional_divisor(polynomial, chart_index):
    """
    Returns the ideal of the exceptional divisor of the blow-up of an affine
    hypersurface at the origin in a standard affine chart.

    Arguments:
        polynomial : An element of a polynomial ring.
        chart_index : Index of a generator of the parent polynomial ring.

    Returns:
        An ideal in the parent polynomial ring.

    Example:
        sage : C.<a,b> = PolynomialRing(QQ);
        sage : R.<X,Y,Z> = PolynomialRing(C);
        sage : exceptional_divisor(a*X^2 + b*Y^3 + Z^3, 2)
        sage : Ideal (Z, a*X^2) of Multivariate Polynomial Ring in X, Y, Z
               over Multivariate Polynomial Ring in a, b over Rational Field
    """
    polynomial_parent = polynomial.parent();
    strict_transform_eq = blowup(polynomial, chart_index);
    
    # Sanity check
    if not (chart_index in range(polynomial_parent.ngens())):
        raise ValueError('Incorrect index of the generator.');

    gen = polynomial_parent.gen(chart_index);
    strict_transform_mod = strict_transform_eq % gen;

    return polynomial_parent.ideal([gen, strict_transform_mod]);

def blowup_shifted(polynomial, affine_list):
    """
    Returns the strict transform of an affine hypersurface for
    the blow-up at the origin in a standard affine chart composed
    with the arguments shift.

    Arguments:
        polynomial : An element of a polynomial ring over
            a polynomial ring over ZZ or QQ.
        affine_list : A list of the form [chart_index, shift_list].
        chart_index : Index of a generator of the parent polynomial ring.
        shift_list : A list of elements of the parent polynomial ring
            of length (poly.parent()).ngens().

    Returns:
        An element of the parent polynomial ring.

    Example:
        sage : C.<a,b> = PolynomialRing(QQ);
        sage : R.<X,Y,Z> = PolynomialRing(C);
        sage : blowup_shifted(a*(a*X^2 + b*Y^3 + Z^3), [2, [b*Y, 0, 0]])
        sage : a^2*(X + b*Y)^2 + a*Z*(b*Y^3 + 1)
    """
    polynomial_parent = polynomial.parent();
    
    try:
        strict_transform_eq = blowup(polynomial, affine_list[0]);
        output = polynomial_argument_shift(strict_transform_eq, affine_list[1]);
    except (TypeError, ValueError):
        raise ValueError('Blow-up data is incompatible with the polynomial.');

    return polynomial_parent(output);
    
def blowup_ideal(affine_ideal, affine_list):
    """
    Return the ideal of the blow-up at the origin of an affine variety
    in a standard affine chart composed with the arguments shift.

    Arguments:
        affine_ideal : An ideal in a polynomial ring over
            a polynomial ring over ZZ or QQ.
        affine_list : A list of the form [chart_index, shift_list].
        chart_index : Index of a generator of the parent polynomial ring.
        shift_list : A list of elements of the parent polynomial ring
            of length (affine_ideal.ring()).ngens().

    Returns:
        An ideal in the parent polynomial ring.

    Example:
        sage : C.<a,b> = PolynomialRing(QQ);
        sage : R.<X,Y,Z> = PolynomialRing(C);
        sage : I = R.ideal(a*(a*X^2 + b*Y^3 + Z^3));
        sage : blowup_ideal(I, [2, [b*Y, 0, 0]])
        sage : Ideal (a^2*(X + b*Y)^2 + a*Z*(b*Y^3 + 1)) of Multivariate
               Polynomial Ring in a, b, X, Y, Z over Rational Field
    """
    polynomial_parent = affine_ideal.ring();

    generators = [];
    try:
        for g in affine_ideal.gens():
            if (g.degree() != 0):
                gen_transformed = blowup_shifted(g, affine_list);
                generators.append(gen_transformed);
            else:
                generators.append(g);
    except (TypeError, ValueError):
        raise ValueError('Blow-up data is incompatible with the ideal.');

    return polynomial_parent.ideal(generators);

def singular_locus_intersection(polynomial, affine_ideal):
    """
    Returns the intersection ideal of an affine variety and the singular locus
    of an affine hypersurface.

    Arguments:
        polynomial : An element of a polynomial ring.
        affine_ideal : An ideal in the parent polynomial ring.

    Returns:
        An ideal in the parent polynomial ring.

    Example:
        sage : C.<a,b> = PolynomialRing(QQ);
        sage : R.<X,Y,Z> = PolynomialRing(C);
        sage : I = R.ideal(X);
        sage : singular_locus_intersection(a*(a*X^2 + b*Y^3 + Z^3), I)
        sage : Ideal (X, 2*a^2*X, 3*a*b*Y^2, 3*a*Z^2) of Multivariate
               Polynomial Ring in X, Y, Z over Multivariate Polynomial Ring
               in a, b over Rational Field
    """
    polynomial_parent = polynomial.parent();
    singular_locus = polynomial_parent.ideal(polynomial.gradient());
    intersection_ideal = affine_ideal + singular_locus;
       
    return intersection_ideal;

def blowup_report(polynomial):
    """
    Prints the strict transform of an affine hypersurface for
    the blow-up at the origin in all standard affine charts
    with additional information.

    Arguments:
        polynomial : An element of a polynomial ring over
            a polynomial ring over ... over ZZ or QQ.

    Example:
        sage : C.<a,b> = PolynomialRing(QQ);
        sage : R.<X,Y,Z> = PolynomialRing(C);
        sage : blowup_report(a*X^2 + b*Y^3 + Z^3)
        sage : Initial term at the origin (before the blow-up): 
               a * X^2

               Chart: 0
               Blow-up equation:
               b*X*Y^3 + X*Z^3 + a
               Exceptional divisor equations:
               [X, a]
               Singular locus equations along the exceptional divisor:
               [X, a, b*Y^3 + Z^3]

               Chart: 1
               Blow-up equation:
               a*X^2 + Y*Z^3 + b*Y
               Exceptional divisor equations:
               [Y, a*X^2]
               Singular locus equations along the exceptional divisor:
               [Y, X, Z^3 + b]
               [Y, a, Z^3 + b]

               Chart: 2
               Blow-up equation:
               a*X^2 + b*Y^3*Z + Z
               Exceptional divisor equations:
               [Z, a*X^2]
               Singular locus equations along the exceptional divisor:
               [Z, X, b*Y^3 + 1]
               [Z, a, b*Y^3 + 1]
    """
    polynomial_parent = polynomial.parent();
    flattening = FlatteningMorphism(polynomial_parent);
    flattened_ring = flattening.codomain();

    # Sanity check
    if not (flattened_ring.base_ring() in [ZZ, QQ]):
        raise ValueError('Incorrect parent polynomial ring.');
    
    # Extract the missing variables
    missing_vars = [];
    for i in range(polynomial_parent.ngens()):
        if (polynomial.degree(polynomial_parent.gen(i)) == 0):
             missing_vars.append(i);

    # Print the initial term at the origin
    print('Initial term at the origin (before the blow-up): ');
    initial = polynomial_initial_form(polynomial);
    if (initial != 0):
        print(flattening(initial).factor());
    else:
        raise ValueError('The initial term is equal to zero.');

    # Print the blow-up information in all charts
    for i in range(polynomial_parent.ngens()):
        if i in missing_vars : continue;

        print('\nChart: ' + str(i));
        strict_transform_eq = blowup(polynomial, i);
        except_divisor = exceptional_divisor(polynomial, i);
        singular_intersection = \
            singular_locus_intersection(strict_transform_eq, except_divisor);
        singular_intersection_flattened = \
            flattened_ring.ideal(singular_intersection.gens());

        print('Blow-up equation:\n' + str(strict_transform_eq));
        print('Exceptional divisor equations:\n' + str(except_divisor.gens()));
        print("Singular locus equations along the exceptional divisor "
              "(without multiplicities):");
        for j in singular_intersection_flattened.primary_decomposition():
            print((j.radical()).gens());


## Pencil computations
            
def pencil_infinity_member_components_set():
    """
    Returns the set of irreducible components of the member over infinity
    of the pencil given by LG_model_pencil_equation.

    Returns:
        A frozenset of ideals in the ring CR_flattened.

    Example:
        sage : pencil_infinity_member_components_set()
        sage : frozenset({Ideal (T) of Multivariate Polynomial Ring
                          in l, m, X, Y, Z, T over Rational Field,
                          Ideal (Z) of Multivariate Polynomial Ring
                          in l, m, X, Y, Z, T over Rational Field,
                          Ideal (Y) of Multivariate Polynomial Ring
                          in l, m, X, Y, Z, T over Rational Field,
                          Ideal (X) of Multivariate Polynomial Ring
                          in l, m, X, Y, Z, T over Rational Field})
    """
    # Define the ambient projective variety over
    # the fraction field of the coefficient ring
    frac_field = FractionField(parameter_ring);
    if ([fano_threefold_rank, fano_threefold_family_no] in [[2, 1], [10, 1]]):
        ambient_space_1 = ProjectiveSpace(1, frac_field, names = ('X', 'Y'));
        ambient_space_2 = \
            ProjectiveSpace(2, frac_field, names = ('A', 'B', 'C'));
        ambient_space = \
            ProductProjectiveSpaces([ambient_space_1, ambient_space_2]);
    else:
        ambient_space = \
            ProjectiveSpace(3, frac_field, names = coordinate_ring.gens());
    
    # Construct the equation of the member over infinity
    eq_transformed = CR_flattening(LG_model_pencil_equation)(l = 1/l);
    infty_equation = CR_flattening(eq_transformed.numerator()).mod(l);
    infty_ideal = CR_flattened.ideal(infty_equation);

    # Output set
    output = set();

    # The components should be defined for a general choice of the parameters
    for component in infty_ideal.primary_decomposition():
        subscheme = ambient_space.subscheme(component);
        if (subscheme.codimension() != 1):
            print("WARNING! The following component has non-standard "
                  "dimension (over the fraction field): " +
                  str(component.gens()));
            continue;
        output.add(component);

    return frozenset(output);

def pencil_base_locus_decomposition(matrix_form):
    """
    Returns the list of divisors of the form [..., D * S_l, ...],
    where S_l is a general member of the pencil, and D runs over
    irreducible components of the member over infinity.

    Args:
        matrix_form : A boolean.

    Returns:
        If matrix_form == False, returns the tuple of the form (..., L, ...),
        where L is a tuple of the form (..., (I, m), ...) for an integer m
        and an ideal I in the ring CR_flattened.

        If matrix_form == True, returns the matrix form of the constructed list
        w.r.t. pencil_base_locus_components.

    Example:
        sage : pencil_base_locus_decomposition(matrix_form = False)[0]
        sage : ((Ideal (Y + Z, X) of Multivariate Polynomial Ring
                 in l, m, X, Y, Z, T over Rational Field, 2),
                (Ideal (T, X) of Multivariate Polynomial Ring
                 in l, m, X, Y, Z, T over Rational Field, 2))
        sage : pencil_base_locus_decomposition(matrix_form = True)
        sage : [2 0 2 0 0 0 0]
               [0 2 0 2 0 0 0]
               [0 0 0 0 0 0 2]
               [1 1 0 0 1 1 0]
    """
    # Define the ambient projective variety over
    # the fraction field of the coefficient ring
    frac_field = FractionField(parameter_ring);
    if ([fano_threefold_rank, fano_threefold_family_no] in [[2, 1], [10, 1]]):
        ambient_space_1 = ProjectiveSpace(1, frac_field, names = ('X', 'Y'));
        ambient_space_2 = \
            ProjectiveSpace(2, frac_field, names = ('A', 'B', 'C'));
        ambient_space = \
            ProductProjectiveSpaces([ambient_space_1, ambient_space_2]);
    else:
        ambient_space = \
            ProjectiveSpace(3, frac_field, names = coordinate_ring.gens());

    # Output list
    output = [];

    # Run over irreducible components of the member over infinity of the pencil
    for infinity_member_component in pencil_infinity_member_components:
        # Intersection ideal of the irreducible component of
        # the member over infinity with a general member
        intersection_ideal = \
            CR_flattened.ideal(LG_model_pencil_equation) + \
            infinity_member_component;

        # Generate the corresponding divisor
        divisor_list = [];

        # Run over the primary decomposition of the obtained ideal        
        for component in intersection_ideal.primary_decomposition():
            # Define the corresponding subschemes
            component_radical = component.radical();
            subscheme = ambient_space.subscheme(component);
            subscheme_reduced = ambient_space.subscheme(component_radical);

            # Print a warning if a specialization is required
            if (subscheme.codimension() != 2):
                print("WARNING! The following component has non-standard "
                      "dimension (over the fraction field): " + \
                      str(component_radical.gens()));
                continue;

            # Compute the multiplicity
            multiplicity = subscheme.degree() / subscheme_reduced.degree();
            
            # Append the decomposition
            divisor_list.append((component_radical, multiplicity));

        # If matrix_form == True, decompose the obtained divisor
        # w.r.t. pencil_base_locus_components
        if (matrix_form):
            decomposition_vector = \
                vector(ZZ, len(pencil_base_locus_components));
        
            # Decompose the divisor w.r.t. the order
            for (component, multiplicity) in divisor_list:
                if (pencil_base_locus_components.count(component) > 0):
                    component_index = \
                        pencil_base_locus_components.index(component);
                    decomposition_vector[component_index] = multiplicity;
                        
            # Append the obtained vector
            output.append(decomposition_vector);
        else:
            # Append the obtained divisor
            output.append(tuple(divisor_list));

    # Return the obtained data
    if (matrix_form):
        return matrix(ZZ, output);
    else:
        return tuple(output);

def pencil_base_locus_components_set():
    """
    Returns the set of irreducible components of the base locus
    of the pencil given by LG_model_pencil_equation.

    Returns:
        A frozenset of ideals in the ring CR_flattened.

    Example:
        sage : pencil_base_locus_components_set()
        sage : frozenset({Ideal (Y + Z, X) of Multivariate Polynomial Ring
                          in l, m, X, Y, Z, T over Rational Field,
                          Ideal (T, X) of Multivariate Polynomial Ring
                          in l, m, X, Y, Z, T over Rational Field,
                          Ideal (Z, X*Y + X*T + Y*T) of
                          Multivariate Polynomial Ring
                          in l, m, X, Y, Z, T over Rational Field,
                          Ideal (Y, X + Z) of Multivariate Polynomial Ring
                          in l, m, X, Y, Z, T over Rational Field,
                          Ideal (T, Y) of Multivariate Polynomial Ring
                          in l, m, X, Y, Z, T over Rational Field,
                          Ideal (T, Y + Z) of Multivariate Polynomial Ring
                          in l, m, X, Y, Z, T over Rational Field,
                          Ideal (T, X + Z) of Multivariate Polynomial Ring
                          in l, m, X, Y, Z, T over Rational Field})
    """
    output = set();

    for divisor in pencil_base_locus_decomposition(matrix_form = False):
        for component in divisor: output.add(component[0]);

    return frozenset(output);

def pencil_hyperplane_sections():
    """
    Returns the matrix form of the list of hyperplane section divisors of
    the form D * S_lambda, where D runs over irreducible components
    of degree one of reducible members of the pencil.

    Returns:
        A matrix over ZZ.

    Example:
        sage : pencil_hyperplane_sections()
        sage : [2 0 2 0 0 0 0]
               [0 2 0 2 0 0 0]
               [0 0 0 0 0 0 2]
               [1 1 0 0 1 1 0]
    """
    # Output list
    hyperplane_sections = [];
    
    # Add the hyperplane sections of the form D * S_lambda,
    # where D runs over irreducible components of the member over infinity
    base_locus_decomposition_matrix = \
        pencil_base_locus_decomposition(matrix_form = True);
    
    for component in pencil_infinity_member_components:
        component_equation = component.gen(0);
        if (coordinate_ring(component_equation).degree() == 1):
            component_index = \
                pencil_infinity_member_components.index(component);
            hyperplane_section_decomposition = \
                (base_locus_decomposition_matrix.rows())[component_index];
            hyperplane_sections.append(hyperplane_section_decomposition);

    # Define the ambient projective variety over
    # the fraction field of the coefficient ring
    frac_field = FractionField(parameter_ring);
    if ([fano_threefold_rank, fano_threefold_family_no] in [[2, 1], [10, 1]]):
        ambient_space_1 = ProjectiveSpace(1, frac_field, names = ('X', 'Y'));
        ambient_space_2 = \
            ProjectiveSpace(2, frac_field, names = ('A', 'B', 'C'));
        ambient_space = \
            ProductProjectiveSpaces([ambient_space_1, ambient_space_2]);
    else:
        ambient_space = \
            ProjectiveSpace(3, frac_field, names = coordinate_ring.gens());

    # Construct a list of additional hyperplanes
    additional_hyperplanes = [];
    for component in pencil_reducible_members_components:
        generators = [];
        for gen in component.gens():
            if (coordinate_ring(gen).degree() != 1): continue;
            generators.append(gen);
        if (generators != []):
            additional_hyperplanes.append(CR_flattened.ideal(generators));

    # Run over additional hyperplane sections
    for hyperplane_ideal in additional_hyperplanes:
        intersection_ideal = \
            CR_flattened.ideal(LG_model_pencil_equation) + hyperplane_ideal;

        # Generate the corresponding divisor
        divisor_list = [];

        # Run over the primary decomposition of the obtained ideal        
        for component in intersection_ideal.primary_decomposition():
            # Define the corresponding subschemes           
            component_radical = component.radical();
            subscheme = ambient_space.subscheme(component);
            subscheme_reduced = ambient_space.subscheme(component_radical);
            
            # Print a warning if a specialization is required
            if (subscheme.codimension() != 2):
                print("WARNING! The following component has non-expected "
                      "dimension (over the fraction field): " + \
                      str(component_radical.gens()));
                continue;

            # Compute the multiplicity
            multiplicity = subscheme.degree() / subscheme_reduced.degree();
            
            # Append the decomposition
            divisor_list.append((component_radical, multiplicity));

        # If matrix_form == True, decompose the obtained divisor
        # w.r.t. pencil_base_locus_components
        decomposition_vector = vector(ZZ, len(pencil_base_locus_components));
        
        # Decompose the divisor w.r.t. the order
        for (component, multiplicity) in divisor_list:
            if (pencil_base_locus_components.count(component) > 0):
                component_index = pencil_base_locus_components.index(component);
                decomposition_vector[component_index] = multiplicity;

        # Append the obtained vector
        hyperplane_sections.append(decomposition_vector);

    # Return the obtained list
    return matrix(ZZ, hyperplane_sections);

def pencil_equivalence_matrix():
    """
    Returns the matrix of linear equivalence for the group A_S.

    Returns:
        A matrix over ZZ.

    Example:
        sage : pencil_equivalence_matrix()
        sage : [ 2  0  2  0  0  0  0 -1]
               [ 0  2  0  2  0  0  0 -1]
               [ 0  0  0  0  0  0  2 -1]
               [ 1  1  0  0  1  1  0 -1]
    """
    # Dummy routine for the case of the ambient space P^1 x P^2
    if ([fano_threefold_rank, fano_threefold_family_no] in [[2, 1], [10, 1]]):
        raise NotImplementedError("Not implemented for the ambient space "
                                  "P^1 x P^2.");

    HS_matrix = pencil_hyperplane_sections();
    HS_shifted = [];

    # Run over the selected hyperplane sections
    for i in HS_matrix.rows():
        i_extended = vector(list(i) + [0]);
        HS_shifted.append(i_extended - \
                          vector(len(pencil_base_locus_components)*[0] + [1]));

    return matrix(ZZ, HS_shifted);

def matrix_reduce(matrix):
    """
    Returns the row echelon form of a matrix over ZZ with omitted zero rows.

    Arguments:
         matrix : A matrix over ZZ.

    Returns:
         A matrix over ZZ.

    Example:
        sage : M = matrix(ZZ, [[2, 0, 0],
                               [2, 1, 1],
                               [0, 1, 1]]);
        sage : matrix_reduce(M)
        sage : [2 0 0]
               [0 1 1]
    """
    # Sanity check
    if not is_MatrixSpace(matrix.parent()):
        raise TypeError("The argument should be a matrix.");
    
    matrix_space = MatrixSpace(ZZ, matrix.nrows(), matrix.ncols());
    if not (matrix in matrix_space):
        raise ValueError("Matrix should be defined over ZZ.");

    return matrix.echelon_form()[:matrix.rank()];

def matrix_splitting(matrix, decomposition_list):
    """
    Given a linear system A*X = 0, construct the equivalent linear system
    of the form L*Y = R*Z, where
    Y = [X_i for i not in decomposition_list]
    Z = [X_i for i in decomposition_list].

    Arguments:
        matrix : A matrix over ZZ.
        decomposition_list :
            A list of integers in range(1, matrix.ncols() + 1)
            of length matrix.ncols() - matrix.rank().

    Returns:
        A list [I, L, R], where
        - I is the complement to the decomposition list;
        - L is the left-hand side matrix;
        - R is the right-hand side matrix.

    Example:
        sage : M = matrix(ZZ, ((2, 0, 2, 0, 0, 0, 0, -1),
                               (0, 2, 0, 2, 0, 0, 0, -1),
                               (0, 0, 0, 0, 0, 0, 2, -1),
                               (1, 1, 0, 0, 1, 1, 0, -1)));
        sage : L = (1, 2, 3, 5);
        sage : matrix_splitting(M, L)[0]
        sage : [4, 6, 7, 8]
        sage : matrix_splitting(M, L)[1]
        sage : [2 0 0 0]
               [0 1 0 0]
               [0 0 2 0]
               [0 0 0 1]
        sage : matrix_splitting(M, L)[2]
        sage : [ 2 -2  2  0]
               [ 1 -1  2 -1]
               [ 2  0  2  0]
               [ 2  0  2  0]
    """
    # Sanity check
    if not is_MatrixSpace(matrix.parent()):
        raise TypeError("The argument should be a matrix.");
    
    matrix_space = MatrixSpace(ZZ, matrix.nrows(), matrix.ncols());
    if not (matrix in matrix_space):
        raise ValueError("Matrix should be defined over ZZ.");
       
    for i in decomposition_list:
        if not ((i - 1) in range(matrix.ncols())):
            raise ValueError("Incorrect list of indexes.");

    if not (len(decomposition_list) == matrix.ncols() - matrix.rank()):
        raise ValueError("Incorrect list of indexes.");
    
    # Construct the permutation
    total_list = list(range(1, matrix.ncols() + 1));
    complement_list = [x for x in total_list if x not in decomposition_list];
    permutation = Permutation(complement_list + \
                              list(decomposition_list)).to_matrix();

    # Compute the reduced row echelon form of the permuted matrix
    permuted_matrix = matrix*permutation;
    permuted_matrix_echelon = matrix_reduce(permuted_matrix);
    
    # Output
    return [complement_list, \
            permuted_matrix_echelon[:, :matrix.rank()], \
            (-1)*permuted_matrix_echelon[:, matrix.rank():]];

def relations_matrix_bases(matrix, frac_field):
    """
    Returns the list of possible integral or rational bases
    w.r.t. a given relations matrix.

    Arguments:
        matrix : A matrix over ZZ.
        frac_field : A boolean.

    Returns:
        If frac_field == False, returns the list of integral bases.
        If frac_field == True, returns the list of rational bases.

    Example:
        sage : M = matrix(ZZ, ((2, 0, 2, 0, 0, 0, 0, -1),
                               (0, 2, 0, 2, 0, 0, 0, -1),
                               (0, 0, 0, 0, 0, 0, 2, -1),
                               (1, 1, 0, 0, 1, 1, 0, -1)));
        sage : relations_matrix_bases(M, frac_field = False)
        sage : []
    """
    # Sanity check
    if not is_MatrixSpace(matrix.parent()):
        raise TypeError("The argument should be a matrix.");
    
    matrix_space = MatrixSpace(ZZ, matrix.nrows(), matrix.ncols());
    if not (matrix in matrix_space):
        raise ValueError("Matrix should be defined over ZZ.");

    if not (type(frac_field) == bool):
        raise TypeError("The second argument should be a Boolean.");

    # Basis matrix of ker(M)
    kernel = matrix.right_kernel();
    kernel_matrix = kernel.matrix();
    kernel_nrows = kernel_matrix.nrows();
    kernel_ncols = kernel_matrix.ncols();
    kernel_rank = kernel_matrix.rank();

    # List of basic minors of the kernel matrix
    basic_minors = [[kernel_matrix[rows, cols], cols] \
                    for cols in Combinations(kernel_ncols, kernel_rank) \
                    for rows in Combinations(kernel_nrows, kernel_rank)];

    # Run over Z-invertible (or Q-invertible) basic minors of the kernel matrix
    output = [];
    for [minor_matrix, minor_indexes] in basic_minors:
        if (frac_field):
            if (det(minor_matrix) == 0): continue;
        else:
            if not (det(minor_matrix) in [1, -1]): continue;
        basis = vector(minor_indexes) + vector([1]*kernel_rank);

        # Sanity check
        LHS_matrix = matrix_splitting(matrix, basis)[1];
        if (frac_field):
            if (LHS_matrix.det() == 0): continue;
        else:
            if (LHS_matrix != \
                identity_matrix(ZZ, kernel_ncols - kernel_rank)): continue;
        
        output.append(basis);

    return output;

def pencil_general_member_singularities_report():
    """
    Prints the equations of the intersection of the singular locus of
    a member of the pencil with irreducible components of the base locus.

    Example:
        sage : pencil_general_member_singularities_report()
        sage : Curve: [X, T]
               Points: [[T, Y, X], [T, Y + Z, X], [T, Z, X]]

               Curve: [Y, T]
               Points: [[T, Y, X], [T, Y, X + Z], [T, Z, Y]]

               Curve: [X, Y + Z]
               WARNING! The following component has non-expected dimension
               (over the fraction field): [Y + Z, X, l + 2]
               Points: [[Z, Y, X], [T, Y + Z, X]]

               Curve: [Y, X + Z]
               WARNING! The following component has non-expected dimension
               (over the fraction field): [Y, X + Z, l + 2]
               Points: [[Z, Y, X], [T, Y, X + Z]]

               Curve: [T, X + Z]
               WARNING! The following component has non-expected dimension
               (over the fraction field): [T, Y + Z, X + Z, l + 4]
               Points: [[T, Z, X], [T, Y, X + Z]]

               Curve: [T, Y + Z]
               WARNING! The following component has non-expected dimension
               (over the fraction field): [T, Y + Z, X + Z, l + 4]
               Points: [[T, Z, Y], [T, Y + Z, X]]

               Curve: [Z, X*Y + X*T + Y*T]
               Points: [[Z, Y, X], [T, Z, X], [T, Z, Y],
                        [Z, X + Y - (l + 2)*T, X*Y + X*T + Y*T]]

               In total:
               [T, Y, X]
               [T, Y + Z, X]
               [T, Z, Y]
               [T, Z, X]
               [T, Y, X + Z]
               [Z, Y, X]
               [Z, X + Y - (l + 2)*T, X*Y + X*T + Y*T]
    """
    output = set();

    # Define the ambient projective variety over
    # the fraction field of the coefficient ring
    frac_field = FractionField(parameter_ring);
    if ([fano_threefold_rank, fano_threefold_family_no] in [[2, 1], [10, 1]]):
        ambient_space_1 = ProjectiveSpace(1, frac_field, \
                                        names = ('X', 'Y'));
        ambient_space_2 = ProjectiveSpace(2, frac_field, \
                                        names = ('A', 'B', 'C'));
        ambient_space = ProductProjectiveSpaces([ambient_space_1, \
                                                 ambient_space_2]);
    else:
        ambient_space = ProjectiveSpace(3, frac_field, \
                                        names = coordinate_ring.gens());

    # Run over the set of ideals of curves composing the base locus
    for component_curve in pencil_base_locus_components:
        print('Curve: ' + str(component_curve.gens()));

        # Temporary list of the singular points on the curve
        singular_points_on_curve = [];

        # Intersection of the singular locus with the curve
        pencil_gradient = coordinate_ring(LG_model_pencil_equation).gradient();
        sing_locus = \
            CR_flattened.ideal(pencil_gradient + [LG_model_pencil_equation]);
        sing_locus_intersection = sing_locus + component_curve;
        intersection_radical = sing_locus_intersection.radical();

        # Run over the primary decomposition of the obtained ideal
        for component in intersection_radical.primary_decomposition():
            component_radical = component.radical();
           
            # Print a warning if a specialisation is needed
            subscheme = ambient_space.subscheme(component_radical);
            if (subscheme.dimension() != 0) :
                 print("WARNING! The following component has non-expected "
                       "dimension (over the fraction field): " + \
                       str(component_radical.gens()));
                 continue;

            # Append the radical
            singular_points_on_curve.append(component_radical.gens());
            output.add(component_radical);

        # Print the result for a given curve
        print('Points: ' + str(singular_points_on_curve) + '\n');

    # Print the whole list
    print('In total:');
    for component in output: print(component.gens());

def pencil_all_members_singularities_report(subvariety_ideal):
    """
    Prints the information on the intersection of irreducible components
    of the singular locus of members of the pencil given by
    LG_model_pencil_equation with the given subvariety.

    Arguments:
        subvariety_ideal: An ideal in the ring CR_flattened.

    Example:
        sage : pencil_all_members_singularities_report(0)
        sage : Singularities of a general fiber:

               Generators: [T, Y, X + Z]
               Expected dimension after specialisation: 0
               Specialisation: []

               Generators: [T, Z, Y]
               Expected dimension after specialisation: 0
               Specialisation: []

               Generators: [Z, X + Y - (l + 2)*T, X*Y + X*T + Y*T]
               Expected dimension after specialisation: 0
               Specialisation: []

               Generators: [T, Y, X]
               Expected dimension after specialisation: 0
               Specialisation: []

               Generators: [T, Y + Z, X]
               Expected dimension after specialisation: 0
               Specialisation: []

               Generators: [T, Z, X]
               Expected dimension after specialisation: 0
               Specialisation: []

               Generators: [Z, Y, X]
               Expected dimension after specialisation: 0
               Specialisation: []

               Isolated singularities of special fibers:

               Generators: [3*Z - 8*T, 3*Y - 4*T, 3*X - 4*T]
               Expected dimension after specialisation: 0
               Specialisation: [l - 14]

               Generators: [T, Y + Z, X + Z]
               Expected dimension after specialisation: 0
               Specialisation: [l + 4]

               Non-isolated singularities of special fibers:

               Generators: [Y, X + Z]
               Expected dimension after specialisation: 1
               Specialisation: [l + 2]

               Generators: [Y + Z, X]
               Expected dimension after specialisation: 1
               Specialisation: [l + 2]

               Other:
    """
    # Define the ambient projective variety over
    # the fraction field of the coefficient ring
    frac_field = FractionField(parameter_ring);
    if ([fano_threefold_rank, fano_threefold_family_no] in [[2, 1], [10, 1]]):
        ambient_space_1 = ProjectiveSpace(1, frac_field, names = ('X', 'Y'));
        ambient_space_2 = \
            ProjectiveSpace(2, frac_field, names = ('A', 'B', 'C'));
        ambient_space = \
            ProductProjectiveSpaces([ambient_space_1, ambient_space_2]);
    else:
        ambient_space = \
            ProjectiveSpace(3, frac_field, names = coordinate_ring.gens());
        
    # Intersection of the singular locus with the given subvariety
    pencil_gradient = coordinate_ring(LG_model_pencil_equation).gradient();
    sing_locus = \
        CR_flattened.ideal(pencil_gradient + [LG_model_pencil_equation]);
    sing_locus_intersection = sing_locus + subvariety_ideal;
    intersection_radical = sing_locus_intersection.radical();

    output_general = [];
    output_special_isolated = [];
    output_special_nonisolated = [];
    output_other = [];

    # Run over the irreducible components of the intersection
    for component in intersection_radical.primary_decomposition():       
        # Separate the coefficients from the actual generators of the ideal
        coefficient_list = [];
        for gen in component.radical().gens():
            if (coordinate_ring(gen).degree() == 0):
                coefficient_list.append(gen);

        # Constuct the expected subscheme
        expected_gens = [gen for gen in component.radical().gens() \
                         if not gen in coefficient_list];
        expected_subscheme = \
            ambient_space.subscheme(CR_flattened.ideal(expected_gens));

        if (coefficient_list == []) and \
           (expected_subscheme.dimension() == 0):
            output_general.append([coefficient_list, expected_gens, \
                                   expected_subscheme.dimension()]);
        elif (expected_subscheme.dimension() == 0):
            output_special_isolated.append([coefficient_list, expected_gens, \
                                            expected_subscheme.dimension()]);
        elif (expected_subscheme.dimension() > 0):
            output_special_nonisolated.append([coefficient_list, \
                                               expected_gens, \
                                               expected_subscheme.dimension()]);
        else:
            output_other.append([coefficient_list, expected_gens, \
                                 expected_subscheme.dimension()]);

    # Prints the information on the singular locus
    output_list = [output_general, output_special_isolated, \
                   output_special_nonisolated, output_other];
    for i in range(4):
        if (i == 0):
            print("Singularities of a general fiber:\n");
        elif (i == 1):
            print("Isolated singularities of special fibers:\n");
        elif (i == 2):
            print("Non-isolated singularities of special fibers:\n");
        else:
            print("Other:\n");
        source = output_list[i];

        for [coefficient_list, expected_gens, expected_dimension] in source:
            print('Generators: ' + str(expected_gens));
            print('Expected dimension after specialisation: ' + \
                  str(expected_dimension));
            print('Specialisation: ' + str(coefficient_list) + '\n');


## Integral lattice computations
            
def is_general_HS():
    """
    Checks if the selected set of generators of the group A_S
    contains the class of a general hyperplane section.

    Returns:
        A boolean.

    Example:
        sage : is_general_HS()
        sage : False
    """
    # Numerical order of a general hyperplane section
    l = len(pencil_base_locus_components) + 1;

    if (pencil_AS_integral_generators.count(l) > 0):
        return True;
    else:
        return False;
    
def pencil_AS_generating_curves():
    """
    Returns the sublist of pencil_base_locus_components w.r.t.
    pencil_AS_integral_generators.

    Returns:
        A list of ideals in the ring CR_flattened.

    Example:
        sage : pencil_AS_generating_curves()
        sage : [Ideal (X, T) of Multivariate Polynomial Ring
                in l, m, X, Y, Z, T over Rational Field,
                Ideal (Y, T) of Multivariate Polynomial Ring
                in l, m, X, Y, Z, T over Rational Field,
                Ideal (X, Y + Z) of Multivariate Polynomial Ring
                in l, m, X, Y, Z, T over Rational Field,
                Ideal (Y, X + Z) of Multivariate Polynomial Ring
                in l, m, X, Y, Z, T over Rational Field,
                Ideal (T, X + Z) of Multivariate Polynomial Ring
                in l, m, X, Y, Z, T over Rational Field,
                Ideal (Z, X*Y + X*T + Y*T) of Multivariate Polynomial Ring
                in l, m, X, Y, Z, T over Rational Field]
    """
    output = [];
    
    for i in pencil_AS_integral_generators:
        # We cannot append a general hyperplane section
        if (is_general_HS()):
            if(i == len(pencil_base_locus_components) + 1) : continue;
        output.append(pencil_base_locus_components[i - 1]);

    return output;

# Intersection matrix on the lattices L_lambda and L_S

def pencil_AS_strict_transforms_intersection_number(i, j):
    """
    Returns the intersection number (C~_i, C~_j) of strict transforms of
    the corresponding selected basic curves of the group A_S.

    Args:
        i : An integer.
        j : An integer.

    Returns:
        An integer.

    Example:
        sage: pencil_AS_strict_transforms_intersection_number(0, 1)
        sage: 0
    """
    # Dummy routine for the case of the ambient space P^1 x P^2
    if ([fano_threefold_rank, fano_threefold_family_no] in [[2, 1], [10, 1]]):
        raise NotImplementedError("Not implemented for the ambient space "
                                  "P^1 x P^2.");

    generating_curves_list = pencil_AS_generating_curves();
    
    if (i == j):
        # If the degree of a curve is larger that two,
        # return the manually defined self-intersection
        frac_field = FractionField(parameter_ring);
        ambient_space = ProjectiveSpace(3, frac_field, \
                                        names = coordinate_ring.gens());
        subscheme = ambient_space.subscheme(generating_curves_list[i]);
        if (subscheme.degree() < 3):
            return -2;
        else:
            genus_list = \
                pencil_base_locus_components_strict_transforms_arithmetic_genus;
            return 2*(genus_list[i] - 1);

    intersection_ideal = generating_curves_list[i] + generating_curves_list[j];

    output = 0;

    # Run over the primary decomposition
    for component in intersection_ideal.primary_decomposition():
        # Pass to the radical
        component_radical = component.radical();
        frac_field = FractionField(parameter_ring);
        ambient_space = ProjectiveSpace(3, frac_field, \
                                        names = coordinate_ring.gens());
        subscheme = ambient_space.subscheme(component);
        if (subscheme.dimension() < 0): continue;
    
        # If a point of intersection was singular, return 0,
        # and add the intersection multiplicity otherwise
        outer_intersection = 1;
        for sing_point in pencil_general_member_singularities:
            if (sing_point == component_radical): outer_intersection = 0;
        if (outer_intersection): output += subscheme.degree();

    # Return the obtained value
    return output;

def pencil_AS_strict_transforms_intersection_matrix():
    """
    Returns the intersection matrix of strict transform
    of the corresponding selected basic curves of the group A_S.

    Returns:
        A matrix over ZZ.

    Example:
        sage: pencil_AS_strict_transforms_intersection_matrix()
        sage: [-2  0  0  0  0  0]
              [ 0 -2  0  0  0  0]
              [ 0  0 -2  0  0  0]
              [ 0  0  0 -2  0  0]
              [ 0  0  0  0 -2  0]
              [ 0  0  0  0  0 -2]
    """
    # Dummy routine for the case of the ambient space P^1 x P^2
    if ([fano_threefold_rank, fano_threefold_family_no] in [[2, 1], [10, 1]]):
       return pencil_LG_lattice_strict_transforms_block;

    indexes_list = pencil_AS_integral_generators;
    gens_len = len(indexes_list);
    
    intersection_number = \
        pencil_AS_strict_transforms_intersection_number;

    if is_general_HS():
        main_block = \
            matrix(ZZ, gens_len - 1, gens_len - 1, \
                   lambda x, y : intersection_number(x, y));
    
        secondary_block_list = [];
        for i in indexes_list:
            if (i - 1 == len(pencil_base_locus_components)): continue;
            deg = 1;
            for j in pencil_base_locus_components[i - 1].gens():
                deg *= coordinate_ring(j).degree();
            secondary_block_list.append(deg);
        secondary_block = matrix(ZZ, secondary_block_list);
        
        scalar_block = matrix([4]);
        
        return block_matrix([[main_block, secondary_block.transpose()], \
                             [secondary_block, scalar_block]]);
    else:
        return matrix(ZZ, gens_len, gens_len, \
                      lambda x, y : intersection_number(x, y));
    
def quadratic_term(i):
    """
    Returns the quadratic term of the i-th singular point of a general member of
    the pencil in the base locus w.r.t. to pencil_general_member_singularities.

    Args:
        i : Index of an element in pencil_general_member_singularities.

    Returns:
        A factorization of an element in the ring CR_flattened.

    Example:
        sage : quadratic_term(0)
        sage : (X + Y + Z)^2
    """
    # Dummy routine for the case of the ambient space P^1 x P^2
    if ([fano_threefold_rank, fano_threefold_family_no] in [[2, 1], [10, 1]]):
        raise NotImplementedError("Not implemented for the ambient space "
                                  "P^1 x P^2.");
    
    # Sanity check
    if not (i in range(len(pencil_general_member_singularities))):
        raise ValueError('Incorrect index of a singularity.');
   
    # Extend the coefficients of the coordinate ring to the fraction field
    frac_field = parameter_ring.fraction_field();
    CR_extended = PolynomialRing(frac_field, coordinate_ring.gens());

    if not pencil_LG_lattice_galois_action_trivial:
        eq_transformed = CR_flattening(LG_model_pencil_equation)\
            (l = pencil_generic_member_base_field_extension);
        pencil_eq= coordinate_ring(eq_transformed.numerator());
    else:
        pencil_eq = LG_model_pencil_equation; 
    
    pencil_eq_extended = CR_extended(pencil_eq);

    # Extract the affine presentation of a singular point
    affine_data = pencil_general_member_singularities_resolution[i].label();
    
    # Pass to the the affine version of the pencil equation
    pencil_eq_affinized = \
        polynomial_affine_image(pencil_eq_extended, affine_data);
    
    # Compute the initial form of the obtained polynomial
    pencil_eq_affinized_initial_form = \
        polynomial_initial_form(pencil_eq_affinized);
    
    # Return to the original coordinates
    initial_form_shifted = \
        polynomial_argument_shift(pencil_eq_affinized_initial_form, \
                                  -vector(affine_data[1]));
    
    gen = CR_extended.gens()[affine_data[0]];
    
    output = initial_form_shifted.homogenize(gen);
    
    return factor(CR_flattening(output.numerator()));
    
def pencil_general_member_singularities_tangent_cone_report():
    """
    Prints the list of selected generators of the group A_S
    containing a fixed singularitity with
    additional information on the tangent cones.

    Example:
        sage : pencil_general_member_singularities_tangent_cone_report()
        sage : Quadratic term at the point [X, Y, Z] of type ('D', 4):
               (X + Y + Z)^2
               List of the basic curves containing a given singularity.
               - absolute numeration: 
               [3, 4, 7]
               - basis numeration: 
               [3, 4, 6]
               - tangent cone: 
               [[X, Y + Z], [Y, X + Z], [Z, X + Y]]

               Quadratic term at the point [X, Y, T] of type ('A', 1):
               X*Y + T^2
               List of the basic curves containing a given singularity.
               - absolute numeration: 
               [1, 2]
               - basis numeration: 
               [1, 2]
               - tangent cone: 
               [[X, T], [Y, T]]
               ...
    """
    # Dummy routine for the case of the ambient space P^1 x P^2
    if ([fano_threefold_rank, fano_threefold_family_no] in [[2, 1], [10, 1]]):
        raise NotImplementedError("Not implemented for the ambient space "
                                  "P^1 x P^2.");
    
    frac_field = FractionField(parameter_ring);
    temp_ring = PolynomialRing(frac_field, coordinate_ring.gens());
    generating_curves_list = \
        pencil_AS_generating_curves();
    
    # Run over the list of singular points
    for j in pencil_general_member_singularities:
        ind = pencil_general_member_singularities.index(j);
        data = pencil_general_member_singularities_resolution[ind].label();

        # Print the information on the singularity
        print('Quadratic term at the point ' + \
              str(j.gens()) + ' of type ' + \
              str(pencil_general_member_singularities_types[ind]) + ':\n' + \
              str(quadratic_term(ind)));

        # Output
        abs_numeration = [];
        basis_numeration = [];
        tangent_spaces = [];
        
        # Run over the list of curves composing the base locus Bs(S)
        for i in generating_curves_list:
            # Check if the point lies on the curve
            fail = 0;
            for k in i.gens():
                if k.mod(j) != 0: fail = 1;

            # Append the result
            if (fail == 0) :
                abs_numeration.append\
                    (pencil_base_locus_components.index(i) + 1);
                basis_numeration.append(generating_curves_list.index(i) + 1);
                ideal_affinized = \
                    ideal_affine_image(temp_ring.ideal(i.gens()), data);
                ideal_homogenized = \
                    ideal_homogenize(ideal_tangent_cone(ideal_affinized), data);
                tangent_spaces.append(ideal_homogenized.gens());

        # Output
        print('List of the basic curves containing a given singularity.');
        print('- absolute numeration: '); print(abs_numeration);
        print('- basis numeration: '); print(basis_numeration);
        print('- tangent cone: '); print(str(tangent_spaces) + '\n');

def pencil_LG_lattice_intersection_matrix():
    """
    Returns the intersection matrix on the lattice L_lambda.

    Example:
        sage : pencil_LG_lattice_intersection_matrix()
        sage : [-2  1  0  0  0  0  0  0  0  0  0  0  0  0  0| 0  0  1  0  0  0]
               [ 1 -2  1  1  0  0  0  0  0  0  0  0  0  0  0| 0  0  0  0  0  0]
               [ 0  1 -2  0  0  0  0  0  0  0  0  0  0  0  0| 0  0  0  1  0  0]
               [ 0  1  0 -2  0  0  0  0  0  0  0  0  0  0  0| 0  0  0  0  0  1]
               [ 0  0  0  0 -2  0  0  0  0  0  0  0  0  0  0| 1  1  0  0  0  0]
               [ 0  0  0  0  0 -2  0  0  0  0  0  0  0  0  0| 1  0  0  0  1  1]
               [ 0  0  0  0  0  0 -2  0  0  0  0  0  0  0  0| 0  1  0  0  0  1]
               [ 0  0  0  0  0  0  0 -2  1  0  0  0  0  0  0| 1  0  1  0  0  0]
               [ 0  0  0  0  0  0  0  1 -2  1  0  0  0  0  0| 0  0  0  0  0  0]
               [ 0  0  0  0  0  0  0  0  1 -2  0  0  0  0  0| 0  0  0  0  0  0]
               [ 0  0  0  0  0  0  0  0  0  0 -2  1  0  0  0| 0  1  0  1  0  0]
               [ 0  0  0  0  0  0  0  0  0  0  1 -2  1  0  0| 0  0  0  0  0  0]
               [ 0  0  0  0  0  0  0  0  0  0  0  1 -2  0  0| 0  0  0  0  1  0]
               [ 0  0  0  0  0  0  0  0  0  0  0  0  0 -2  0| 0  0  0  0  0  1]
               [ 0  0  0  0  0  0  0  0  0  0  0  0  0  0 -2| 0  0  0  0  0  1]
               [--------------------------------------------+-----------------]
               [ 0  0  0  0  1  1  0  1  0  0  0  0  0  0  0|-2  0  0  0  0  0]
               [ 0  0  0  0  1  0  1  0  0  0  1  0  0  0  0| 0 -2  0  0  0  0]
               [ 1  0  0  0  0  0  0  1  0  0  0  0  0  0  0| 0  0 -2  0  0  0]
               [ 0  0  1  0  0  0  0  0  0  0  1  0  0  0  0| 0  0  0 -2  0  0]
               [ 0  0  0  0  0  1  0  0  0  0  0  0  1  0  0| 0  0  0  0 -2  0]
               [ 0  0  0  1  0  1  1  0  0  0  0  0  0  1  1| 0  0  0  0  0 -2]
    """
    # Intersection matrix of exceptional curves
    cartan_matrices = [];
    for i in pencil_general_member_singularities_types:
        diagram = DynkinDiagram(i);
        cartan_matrices.append(-diagram.cartan_matrix());
    exceptional_block = block_diagonal_matrix(cartan_matrices);

    # Intersection matrix of strict transforms of the basic curves
    strict_block = \
        pencil_AS_strict_transforms_intersection_matrix();

    # Mixed blocks blocks of the intersection matrix
    mixed_matrices = [];
    for i in pencil_LG_lattice_mixed_blocks: \
        mixed_matrices.append([i]);
    mixed_block = block_matrix(mixed_matrices);

    # Return the intersection matrix
    return block_matrix([[exceptional_block, mixed_block], \
                         [mixed_block.transpose(), strict_block]]);

def pencil_LS_lattice_intersection_matrix():
    """
    Returns the intersection matrix on the lattice L_S.

    Example:
        sage : pencil_LS_lattice_intersection_matrix()
        sage : [-2  1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0]
               [ 1 -2  1  1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0]
               [ 0  1 -2  0  0  0  0  0  0  0  0  0  0  0  0  0  0  1  0  0]
               [ 0  1  0 -2  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  1]
               [ 0  0  0  0 -2  0  0  0  0  0  0  0  0  0  1  1  0  0  0  0]
               [ 0  0  0  0  0 -2  0  0  0  0  0  0  0  0  1  0  0  0  1  1]
               [ 0  0  0  0  0  0 -2  0  0  0  0  0  0  0  0  1  0  0  0  1]
               [ 0  0  0  0  0  0  0 -2  1  0  0  0  0  0  1  0  1  0  0  0]
               [ 0  0  0  0  0  0  0  1 -2  1  0  0  0  0  0  0  0  0  0  0]
               [ 0  0  0  0  0  0  0  0  1 -2  0  0  0  0  0  0  0  0  0  0]
               [ 0  0  0  0  0  0  0  0  0  0 -2  1  0  0  0  1  0  1  0  0]
               [ 0  0  0  0  0  0  0  0  0  0  1 -2  1  0  0  0  0  0  0  0]
               [ 0  0  0  0  0  0  0  0  0  0  0  1 -2  0  0  0  0  0  1  0]
               [ 0  0  0  0  0  0  0  0  0  0  0  0  0 -4  0  0  0  0  0  2]
               [ 0  0  0  0  1  1  0  1  0  0  0  0  0  0 -2  0  0  0  0  0]
               [ 0  0  0  0  1  0  1  0  0  0  1  0  0  0  0 -2  0  0  0  0]
               [ 1  0  0  0  0  0  0  1  0  0  0  0  0  0  0  0 -2  0  0  0]
               [ 0  0  1  0  0  0  0  0  0  0  1  0  0  0  0  0  0 -2  0  0]
               [ 0  0  0  0  0  1  0  0  0  0  0  0  1  0  0  0  0  0 -2  0]
               [ 0  0  0  1  0  1  1  0  0  0  0  0  0  2  0  0  0  0  0 -2]
    """
    intersection_matrix = pencil_LG_lattice_intersection_matrix();

    if pencil_LG_lattice_galois_action_trivial:
        return intersection_matrix;
    
    l = intersection_matrix.ncols();
    output = [];
    for orbit in pencil_LG_lattice_galois_orbits:
        v = vector(ZZ, l);
        for i in orbit: v[i - 1] = 1;
        output.append(v);
    transition_matrix = matrix(ZZ, output);
    return transition_matrix*intersection_matrix*transition_matrix.transpose();

def pencil_LS_lattice_integral_bases(member_type):
    """
    Prints the list of integral bases of the lattices L_lambda or L_S
    and the determinants of the corresponding minors.

    Example:
        sage: pencil_LS_lattice_integral_bases('general')
        sage: List of possible integral bases of the lattice:
              (1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
               11, 12, 14, 16, 17, 18, 19, 20, 21)
              Determinant: 20
              (1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
               11, 12, 15, 16, 17, 18, 19, 20, 21)
              Determinant: 20
              (1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12,
               13, 14, 16, 17, 18, 19, 20, 21)
              Determinant: 20
              ...
    """
    if (member_type == 'generic'):
        intersection_matrix = pencil_LS_lattice_intersection_matrix();
    elif (member_type == 'general'):
        intersection_matrix = pencil_LG_lattice_intersection_matrix();
    else:
        raise ValueError('Incorrect type of a member of the pencil.');
    
    kernel = intersection_matrix.right_kernel();
    bases_list = relations_matrix_bases(kernel.matrix(), frac_field = False);
   
    print('List of possible integral bases of the lattice:');
    for indexes in bases_list:
        print(indexes);
        indexes_shifted = vector(indexes) - vector([1] * len(indexes));
        minor_matrix = (intersection_matrix[list(indexes_shifted), \
                                            list(indexes_shifted)]).det();
        print ('Determinant: ' + str(minor_matrix));

def pencil_LS_lattice_intersection_matrix_reduced(member_type):
    """
    Returns the submatrix of the intersection matrix on the lattice
    L_lambda or L_S with respect to the chosen integral basis.

    Example:
        sage : pencil_LS_lattice_intersection_matrix_reduced('generic')
        sage : [-2  1  0  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0]
               [ 1 -2  1  1  0  0  0  0  0  0  0  0  0  0  0  0  0  0]
               [ 0  1 -2  0  0  0  0  0  0  0  0  0  0  0  0  1  0  0]
               [ 0  1  0 -2  0  0  0  0  0  0  0  0  0  0  0  0  0  1]
               [ 0  0  0  0 -2  0  0  0  0  0  0  0  0  1  0  0  0  1]
               [ 0  0  0  0  0 -2  1  0  0  0  0  0  1  0  1  0  0  0]
               [ 0  0  0  0  0  1 -2  1  0  0  0  0  0  0  0  0  0  0]
               [ 0  0  0  0  0  0  1 -2  0  0  0  0  0  0  0  0  0  0]
               [ 0  0  0  0  0  0  0  0 -2  1  0  0  0  1  0  1  0  0]
               [ 0  0  0  0  0  0  0  0  1 -2  1  0  0  0  0  0  0  0]
               [ 0  0  0  0  0  0  0  0  0  1 -2  0  0  0  0  0  1  0]
               [ 0  0  0  0  0  0  0  0  0  0  0 -4  0  0  0  0  0  2]
               [ 0  0  0  0  0  1  0  0  0  0  0  0 -2  0  0  0  0  0]
               [ 0  0  0  0  1  0  0  0  1  0  0  0  0 -2  0  0  0  0]
               [ 1  0  0  0  0  1  0  0  0  0  0  0  0  0 -2  0  0  0]
               [ 0  0  1  0  0  0  0  0  1  0  0  0  0  0  0 -2  0  0]
               [ 0  0  0  0  0  0  0  0  0  0  1  0  0  0  0  0 -2  0]
               [ 0  0  0  1  1  0  0  0  0  0  0  2  0  0  0  0  0 -2]
    """
    if pencil_LG_lattice_nondegenerate:
        if (member_type == 'general'):
            return pencil_LG_lattice_intersection_matrix();
        elif (member_type == 'generic'):
            return pencil_LS_lattice_intersection_matrix();
        else:
            raise ValueError('Incorrect type of a member of the pencil.');
    else:
        if (member_type == 'general'):
            intersection_matrix = pencil_LG_lattice_intersection_matrix();
            integral_basis = pencil_LG_lattice_integral_basis;
        elif (member_type == 'generic'):
            intersection_matrix = pencil_LS_lattice_intersection_matrix();
            if pencil_LG_lattice_galois_action_trivial: 
                integral_basis = pencil_LG_lattice_integral_basis;
            else:
                integral_basis = pencil_LS_lattice_integral_basis;
        else:
            raise ValueError('Incorrect type of a member of the pencil.');
        indexes_shifted = \
            vector(integral_basis) - vector([1]*len(integral_basis));
        return intersection_matrix\
            [list(indexes_shifted), list(indexes_shifted)];

def pencil_LS_lattice_orthogonal_complement():
    """
    Returns the conjectural orthogonal complement to the lattice L_S.

    Example:
        sage : pencil_LS_lattice_orthogonal_complement()
        sage : [0 1|0 0]
               [1 0|0 0]
               [---+---]
               [0 0|4 6]
               [0 0|6 4]
    """
    hyperbolic_plane = matrix(ZZ, [[0, 1], [1, 0]]);

    return block_diagonal_matrix([hyperbolic_plane, \
                                  fano_threefold_picard_lattice]);

def rational_modulo_integer(a, k):
    """
    Returns a rational number modulo an integer.

    Arguments:
        a : A rational number.
        k : A positive integer.

    Returns:
        A rational number.

    Example:
        sage : rational_modulo_integer(3/2, 1)
        sage : 1/2
    """
    # Sanity check
    if not (a in QQ):
        raise TypeError('The first argument should be a rational number.');

    if not ((k in ZZ) and (k > 0)):
        raise TypeError('The second argument should be a positive integer.');
    
    return (a.numerator() % (k * a.denominator()) / a.denominator());

def disc_quad_form_list_subroutine(basis_subset):
    """
    An auxiliary function for disc_quad_form_list.
    """ 
    basis = tuple(basis_subset);
    order_list = [g.order() for g in basis];
    if (order_list.sort() != invariant_factors.sort()) : return;

    disc_subgroup = disc_group.submodule(basis);
    if (disc_subgroup != disc_group) : return;

    output = [];
    output.append(basis);

    lifting_list = [];
    for gen in basis:
        gen_lift = gen.lift();
        gen_lift_reduced = vector([rational_modulo_integer(gen_lift[i], 1) \
                                   for i in range(len(gen_lift))]);
        lifting_list.append(gen_lift_reduced);
    output.append(lifting_list);

    disc_quad_form_matrix = \
        matrix(QQ, len(basis), lambda x, y : basis[x] * basis[y]);
    for i in range(len(basis)): disc_quad_form_matrix[i, i] = basis[i].q();
    output.append(disc_quad_form_matrix);
        
    disc_quad_form_matrix_dual = \
        matrix(QQ, len(basis), lambda x, y : rational_modulo_integer\
               (-disc_quad_form_matrix[x, y], 1));
    for i in range(len(basis)): disc_quad_form_matrix_dual[i, i] = \
        rational_modulo_integer(-disc_quad_form_matrix[i, i], 2);
    output.append(disc_quad_form_matrix_dual);        

    return output;

def disc_quad_form_list(gram_matrix):
    """
    Given a Gram matrix of an integral lattice, write to a file the matrix of
    the corresponding discriminant quadratic form for all possible bases.
    Here "the discriminant quadratic form matrix" has (Q/2Z)-values on
    the diagonal, and (Q/Z)-values outside the diagonal.

    WARNING! Could be CPU and memory consuming.

    REMARK. Loads tqdm module for the progress bar.

    Arguments:
        gram_matrix : A square matrix over ZZ.

    Example:
        sage : M = IntegralLattice("A2").gram_matrix();
        sage : disc_quad_form_list(M)
        sage : Basis of the discrimant group: 
               [(1)]
               Lifting to the dual lattice: 
               [(2/3, 1/3)]
               Discriminant quadratic form: 
               [2/3]
               Dual quadratic form: 
               [4/3]
               ...
    """
    # Sanity check
    if not is_MatrixSpace(gram_matrix.parent()):
        raise TypeError("The argument should be a matrix.");
    
    matrix_space = MatrixSpace(ZZ, gram_matrix.nrows());
    if not (gram_matrix in matrix_space):
        raise ValueError("Matrix should be defined over ZZ.");    
   
    # Define the integral lattice and its discriminant group
    lattice = IntegralLattice(gram_matrix);
    global disc_group;
    disc_group = lattice.discriminant_group();
    
    # Compute the size of minimal generating subsets
    invariant_factors_prep = gram_matrix.elementary_divisors();
    global invariant_factors;
    invariant_factors = list(filter((1).__ne__, invariant_factors_prep));
    
    # Write to a file the matrix of the quadratic form
    # for all minimal generating subsets
    from multiprocessing import Pool
    import gc
    from tqdm import tqdm
    pool = Pool()
    gc.enable()

    with open('results.txt', 'w') as f:
        args = tqdm(Subsets(disc_group, len(invariant_factors)));
        for result in pool.imap(disc_quad_form_list_subroutine, args):
            if (result == None) : continue;
            for P in Permutations(len(result[0])):
                basis_permuted = \
                    [result[0][P[i] - 1] for i in range(len(result[0]))];
                lifting_permuted = \
                    [result[1][P[i] - 1] for i in range(len(result[0]))];
                matrix_permuted = \
                    (P.to_matrix().transpose()) * result[2] * P.to_matrix();
                matrix_permuted_dual = \
                    (P.to_matrix().transpose()) * result[3] * P.to_matrix();

                f.write('Basis of the discrimant group: \n' + \
                        str(basis_permuted) + '\n');
                f.write('Lifting to the dual lattice: \n' + \
                        str(lifting_permuted) + '\n');
                f.write('Discriminant quadratic form: \n' + \
                        str(matrix_permuted) + '\n');
                f.write('Dual quadratic form: \n' + \
                        str(matrix_permuted_dual) + '\n\n');
 
def DN_duality_report():
    """
    Checks if the constructed lattices are actually orthogonal to each other.

    Example:
        sage : DN_duality_report()
        sage : Bilinear (Q/Z)-valued discriminant form on the lattice L_S:
               [  0 1/2]
               [1/2 4/5]
               Bilinear (Q/Z)-valued discriminant form on
               its orthogonal complement:
               [  0 1/2]
               [1/2 1/5]
               Quadratic (Q/2Z)-valued discriminant form on the lattice L_S:
               (1, 9/5)
               Quadratic (Q/2Z)-valued discriminant form on
               its orthogonal complement:
               (1, 1/5)
               Are they consistent: True
    """
    # Setup
    L1 = IntegralLattice(pencil_LS_lattice_intersection_matrix_reduced\
                         ('generic'));
    D1 = L1.discriminant_group();
    L2 = IntegralLattice(pencil_LS_lattice_orthogonal_complement());
    D2 = L2.discriminant_group();

    # Generators of discriminant groups
    D1_gens = [];
    for i in pencil_LS_lattice_disc_group_generators: \
        D1_gens.append(D1(i));
    D2_gens = [];
    for i in pencil_LS_lattice_orthogonal_complement_disc_group_generators: \
        D2_gens.append(D2(i));
    
    # Compute the quadratic form matrices
    D1_disc_bilinear_form_matrix = \
        matrix(QQ, len(D1_gens), lambda x, y : D1_gens[x] * D1_gens[y]);
    D1_disc_bilinear_form_matrix_dual = \
        matrix(QQ, len(D1_gens), lambda x, y : \
               rational_modulo_integer(-D1_disc_bilinear_form_matrix[x, y], 1));
    D1_disc_quadratic_form_vector = vector(QQ, len(D1_gens));
    D1_disc_quadratic_form_vector_dual = vector(QQ, len(D1_gens));
    for i in range(len(D1_gens)):
        D1_disc_quadratic_form_vector[i] = D1_gens[i].q();
        D1_disc_quadratic_form_vector_dual[i] = \
            rational_modulo_integer(-D1_disc_quadratic_form_vector[i], 2);

    D2_disc_bilinear_form_matrix = \
        matrix(QQ, len(D2_gens), lambda x, y : D2_gens[x] * D2_gens[y]);
    D2_disc_bilinear_form_matrix_dual = \
        matrix(QQ, len(D2_gens), lambda x, y : \
               rational_modulo_integer(-D2_disc_bilinear_form_matrix[x, y], 1));
    D2_disc_quadratic_form_vector = vector(QQ, len(D2_gens));
    D2_disc_quadratic_form_vector_dual = vector(QQ, len(D2_gens));
    for i in range(len(D2_gens)):
        D2_disc_quadratic_form_vector[i] = D2_gens[i].q();
        D2_disc_quadratic_form_vector_dual[i] = \
            rational_modulo_integer(-D2_disc_quadratic_form_vector[i], 2);

    # Compute the dual quadratic form matrices    
    b = ((D2_disc_bilinear_form_matrix_dual == \
          D1_disc_bilinear_form_matrix) and \
         (D1_disc_bilinear_form_matrix_dual == \
          D2_disc_bilinear_form_matrix) and \
         (D2_disc_quadratic_form_vector_dual == \
          D1_disc_quadratic_form_vector) and \
         (D1_disc_quadratic_form_vector_dual == \
          D2_disc_quadratic_form_vector));

    print("Bilinear (Q/Z)-valued discriminant form on the lattice L_S:");
    print(D1_disc_bilinear_form_matrix);
    print("Bilinear (Q/Z)-valued discriminant form on " + \
          "its orthogonal complement:");
    print(D2_disc_bilinear_form_matrix);
    print("Quadratic (Q/2Z)-valued discriminant form on the lattice L_S:");
    print(D1_disc_quadratic_form_vector);
    print("Quadratic (Q/2Z)-valued discriminant form on " + \
          "its orthogonal complement:");
    print(D2_disc_quadratic_form_vector);
    print("Are they consistent: " + str(b));


## Rational lattice computations
    
def pencil_exceptional_curve_order(singularity_no, basic_curve_no):
    """
    Returns the numerical order of an exceptional curve of a singularity
    tnat intersects the strict transform of a basic curve of the group A_S.

    Args:
        singularity_no : An integer.
        basic_curve_no : An integer.

    Example:
        sage : pencil_exceptional_curve_order(1, 0)
        sage : [0]
    """
    # Extract the list of intersections of the given
    # basic curve with the exceptional curves
    # of the given singularity
    mixed_submatrix = pencil_LG_lattice_mixed_blocks\
        [singularity_no][:, basic_curve_no].list();
    indexes = [i for i, x in enumerate(mixed_submatrix) if x == 1];

    if not (1 in mixed_submatrix):
        print("WARNING! The basic curve does not intersect any exceptional "
              "curve of the singularity.");

    return indexes;

def pencil_AS_rational_intersection_number(i, j):
    """
    Returns the rational intersection number of
    the selected basic curves of the group A_S.

    Args:
        i : An integer.
        j : An integer.

    Example:
        sage: pencil_AS_rational_intersection_number(0, 1)
        sage: 1/2
    """
    # Define the ambient projective variety over
    # the fraction field of the coefficient ring
    frac_field = FractionField(parameter_ring);
    if ([fano_threefold_rank, fano_threefold_family_no] in [[2, 1], [10, 1]]):
        ambient_space_1 = ProjectiveSpace(1, frac_field, names = ('X', 'Y'));
        ambient_space_2 = \
            ProjectiveSpace(2, frac_field, names = ('A', 'B', 'C'));
        ambient_space = \
            ProductProjectiveSpaces([ambient_space_1, ambient_space_2]);
    else:
        ambient_space = \
            ProjectiveSpace(3, frac_field, names = coordinate_ring.gens());
    
    # List of selected generators
    curves = pencil_AS_generating_curves();

    # The case of self-intersection
    if (i == j) :
        # Extract the indexes of singular points
        # containing in the curve C_{i+1}.
        index_list = [];

        # Run over the list of singular points
        for u in pencil_general_member_singularities:
            # Position of the point in the list
            ind = pencil_general_member_singularities.index(u);

            # Exclude the generically smooth points
            if (pencil_general_member_singularities_types[ind][1] == 0):\
               continue;

            # Check if the point lies on the curve
            fail = 0;
            for gen in curves[i].gens():
                if (gen.mod(u) != 0) : fail = 1;
            if (fail == 0): index_list.append(ind);

        # Form the auxiliary list
        auxiliary_list = [];
        for a in index_list:
            # Find the corresponding exceptional curve
            position = pencil_exceptional_curve_order(a, i);

            if (len(position) != 1):
                print('WARNING! Singular points are presented for ' + \
                      str([i + 1, j + 1]) + ': returning a dummy value ' + \
                      '-1234567890.');
                return -1234567890;
                
            # Determine the type of the singularity
            sing_type = pencil_general_member_singularities_types[a];

            auxiliary_list.append([sing_type, position[0] + 1]);

        # Proceed to the computations
        intersection_number = -2;
    
        for [singularity_type, n], k in auxiliary_list:
            if (singularity_type == 'A'):
                intersection_number += k*(n + 1 - k)/(n + 1);
            elif (singularity_type == 'D'):
                if (n < 4) :
                    intersection_number += k*(n + 1 - k)/(n + 1);
                else :
                    if (k == 1):
                        intersection_number += 1;
                    else:
                        intersection_number += n/4;
            elif (singularity_type == 'E') :
                if (n == 6) :
                    intersection_number += 4/3;
                elif (n == 7) :
                    intersection_number += 3/2;
                else:
                    raise ValueError("Not defined.");
            else:
                raise ValueError("Wrong ADE type.");

        return intersection_number;
    else:              
        # Sum of the corresponding ideals
        intersection_ideal = curves[i] + curves[j];

        # Run over the primary decomposition
        output = 0;

        for component in intersection_ideal.primary_decomposition():            
            # Pass to the radical of an ideal
            component_radical = component.radical();
            subscheme = ambient_space.subscheme(component_radical);

            # Compute the multiplicity
            multiplicity = 1;
            for gen in component.gens():
                multiplicity *= coordinate_ring(gen).degree();

            if (subscheme.dimension() != 0):
                continue;

            # Assume by default that the intersection point lies outside Bs(S)
            outer_intersection = 1;

            # If a point of intersection was singular, return 0,
            # and add the intersection multiplicity otherwise
            for sing_point in pencil_general_member_singularities:     
                # Is the intersection point singular?
                if (sing_point == component_radical):
                    outer_intersection = 0;

                    ind = pencil_general_member_singularities.index(sing_point);
                    
                    # Determine the corresponding exceptional curves
                    pos_k = pencil_exceptional_curve_order(ind, i);
                    pos_r = pencil_exceptional_curve_order(ind, j);
                    
                    if (len(pos_k) != 1) or (len(pos_r) != 1):
                        print('WARNING! Singular points are presented for ' + \
                              str([i + 1, j + 1]) + ': ' + \
                              'returning a dummy value -1234567890.');
                        return -1234567890;

                    k = pos_k[0] + 1; r = pos_r[0] + 1;

                    # Determine the size of the corresponding Dynkin diagram
                    n = pencil_LG_lattice_mixed_blocks[ind].nrows();
                            
                    # Proceed to the computations
                    singularity_type = \
                        pencil_general_member_singularities_types[ind][0];
                    if (singularity_type == 'A'):
                        if (k >= r):
                            output += r*(n + 1 - k)/(n + 1);
                        else:                                
                            output += k*(n + 1 - r)/(n + 1);
                    elif (singularity_type == 'D'):
                        output += multiplicity*1/2;
                    elif (singularity_type == 'E'):
                        raise NotImplementedError\
                            ("Not implemented for the exceptional types.");
                    else:
                        raise ValueError('Wrong ADE type.');

            # If the intersection point lies outside Bs(S),
            # add the intersection multiplicity
            if (outer_intersection): output += multiplicity;

        # Return the obtained value
        return output;

def pencil_AS_rational_intersection_matrix():
    """
    Returns the rational intersection matrix on the group A_S.

    Example:
        sage : pencil_AS_rational_intersection_matrix()
        sage : [-1/4  1/2  3/4    0  1/2  1/2]
               [ 1/2 -1/4    0  3/4  1/4  1/2]
               [ 3/4    0 -1/4  1/2    0  1/2]
               [   0  3/4  1/2 -1/4  1/4  1/2]
               [ 1/2  1/4    0  1/4 -3/4  1/2]
               [ 1/2  1/2  1/2  1/2  1/2    1]
    """
    if ([fano_threefold_rank, fano_threefold_family_no] in [[2, 1], [10, 1]]):
        raise NotImplementedError("Not implemented for the ambient space "
                                  "P^1 x P^2.");
    
    indexes_list = pencil_AS_integral_generators;
    gens_len = len(indexes_list);

    if(is_general_HS()):
        main_block = matrix(QQ, gens_len - 1, gens_len - 1, lambda x, y : \
                            pencil_AS_rational_intersection_number(x, y));

        secondary_block_list = [];
        for i in indexes_list:
            if (i - 1 == len(pencil_base_locus_components)): continue;
            deg = 1;
            for j in pencil_base_locus_components[i - 1].gens():
                deg *= coordinate_ring(j).degree();
            secondary_block_list.append(deg);
        secondary_block = matrix(ZZ, secondary_block_list);
        
        scalar_block = matrix([4]);
        out = block_matrix([[main_block, secondary_block.transpose()], \
                            [secondary_block, scalar_block]], \
                           subdivide = False);
    else:
        out = matrix(QQ, gens_len, gens_len, lambda x, y : \
                     pencil_AS_rational_intersection_number(x, y));

    return out; 


## Laurent polynomial computations

def immutable(obj):
    """
    Returns the immutable copy of a mutable object.

    Arguments:
        obj : A mutable object.
    """
    obj.set_immutable();
    return obj;

def GL_generators(n):
    """
    Returns a tuple of generators of the group GL(n, Z).

    Returns:
        A tuple of invertible matrices over ZZ.

    Example:
        sage : GL_generators(3)
        sage : (
               [1 0 0]  [0 0 1]  [0 1 0]  [1 1 0]  [-1  0  0]
               [0 1 0]  [1 0 0]  [1 0 0]  [0 1 0]  [ 0  1  0]
               [0 0 1], [0 1 0], [0 0 1], [0 0 1], [ 0  0  1]
               )
    """
    if (n == 1):
        return tuple([identity_matrix(ZZ, n), -identity_matrix(ZZ, n)]);

    s_1 = zero_matrix(ZZ, n);
    for i in range(n) : s_1[i, i - 1] = 1;

    s_2 = identity_matrix(ZZ, n);
    s_2[0, 1] = 1; s_2[1, 0] = 1;
    s_2[0, 0] = 0; s_2[1, 1] = 0;

    s_3 = identity_matrix(ZZ, n);
    s_3[0, 1] = 1;
   
    s_4 = identity_matrix(ZZ, n);
    s_4[0, 0] = -1;

    return tuple([identity_matrix(ZZ, n), s_1, s_2, s_3, s_4]);

def GL_bounded(matrix_size, matrix_bound):
    """
    Returns the frozenset of immutable invertible matrices over ZZ of
    size matrix_size with the coefficients bounded by matrix_bound.

    Arguments:
        matrix_size : An integer.
        matrix_bound : An integer.

    Returns:
        A frozenset of immutable invertible matrices over ZZ.

    Example:
        sage : GL_bounded(1, 1)
        sage : frozenset({[-1], [1]})
    """
    # Sanity check
    if not ((matrix_size in ZZ) and matrix_size > 0):
        raise ValueError("Incorrect matrix size.");

    if not ((matrix_bound in ZZ) and matrix_bound > 0):
        raise ValueError("Incorrect matrix bound.");

    # Construct the set of invertible bounded matrices
    matrix_set = set();
    for i in Tuples(range(-matrix_bound, matrix_bound + 1), matrix_size^2):
        m = matrix(ZZ, matrix_size, matrix_size, i);
        if (m.is_invertible()) : matrix_set.add(immutable(m));

    return frozenset(matrix_set);

def matrix_words(generators_tuple, words_length):
    """
    Returns a frozenset of immutable matrices obtained as a words of length
    words_len in a tuple of matrices generators_tuple and its inverses.

    Arguments:
        generators_tuple : A tuple of invertible matrices of same size.
        words_length : A positive integer.

    Returns:
        A frozenset of immutable invertible matrices.

    Example:
        sage : matrix_words(GL_generators(3), 1);
        sage : frozenset({[-1  0  0]
                          [ 0  1  0]
                          [ 0  0  1],
                          ...
                          [1 1 0]
                          [0 1 0]
                          [0 0 1]})
    """
    # Sanity check
    if not (type(generators_tuple) == tuple):
        raise TypeError("Incorrect generators tuple.");

    matrix_space = generators_tuple[0].parent();
    
    for i in generators_tuple:
        if not (is_MatrixSpace(i.parent()) and (i.parent() == matrix_space)):
            raise ValueError("Incorrect generators tuple.");

    if not ((words_length in ZZ) and (words_length > 0)):
        raise ValueError("Incorrect words length.");
    
    # Compute all words of length 1
    words_gens = set();
    for gen in generators_tuple:
        words_gens.add(immutable(gen));
        words_gens.add(immutable(gen.inverse()));

    # Compute all words of length words_length
    words_set = words_gens;
    for i in range(1, words_length):
        words_set = {immutable(m * g) for m in words_gens for g in words_set};
        
    return frozenset(words_set);

def reflexive_polytope_type(laurent_polynomial):
    """
    Returns the reflexive polytope that is combinatorially
    isomorphic to the Newton polytope of a Laurent polynomial.

    Arguments:
        laurent_polynomial : A Laurent polynomial.

    Returns:
        An element of ReflexivePolytopes(n) for
        n = (laurent_polynomial.parent()).ngens().

    Example:
        sage : C.<a_1,a_2> = PolynomialRing(ZZ);
        sage : R.<x,y,z> = LaurentPolynomialRing(C);
        sage : reflexive_polytope_type(x + y + a_1*x^-1*y^-1 + z + a_2*z^-1)
        sage : 3-d reflexive polytope #4 in 3-d lattice M
    """
    parent_ring = laurent_polynomial.parent();

    # Sanity check
    if not is_LaurentPolynomialRing(parent_ring):
        raise TypeError("The argument should be a Laurent polynomial.");

    if not (parent_ring.ngens() in (2, 3)):
        raise NotImplementedError("ReflexivePolytopes(n) is not implemented "
                                  "for n != 2, 3.");
    
    # Construct the Newton polytope
    monomials_list = [];
    for i in laurent_polynomial.monomials():
        monomials_list.append([i.degree(gen) for gen in parent_ring.gens()]);
    newton_polytope = LatticePolytope(monomials_list);

    # Build the list of combinatorially isomorphic polytopes
    polytopes_list = [];
    for i in ReflexivePolytopes(parent_ring.ngens()):
        if (newton_polytope.normal_form() == i.normal_form()):
           polytopes_list.append(i);

    if (len(polytopes_list) == 1):
        return polytopes_list[0];
    else:
        raise ValueError("The Newton polytope of the Laurent polynomial is "
                         "not reflexive.");

def period_sequence(laurent_polynomial, sequence_length):
    """
    Returns the list of the first terms of the period sequence
    of a Laurent polynomial.

    Arguments:
        laurent_polynomial : A Laurent polynomial.
        sequence_length : A positive integer.

    Returns:
        A list of non-negative integers of length sequence_len.

    Example:
        sage : C.<a_1,a_2> = PolynomialRing(ZZ);
        sage : R.<x,y,z> = LaurentPolynomialRing(C);
        sage : period_sequence(x + y + a_1*x^-1*y^-1 + z + a_2*z^-1, 6)
        sage : [1, 0, 2*a_2, 6*a_1, 6*a_2^2, 120*a_1*a_2]
    """
    parent_ring = laurent_polynomial.parent();

    # Sanity check
    if not is_LaurentPolynomialRing(parent_ring):
        raise TypeError("The first argument should be a Laurent polynomial.");

    if not ((sequence_length in ZZ) and (sequence_length > 0)):
        raise TypeError("The second argument should be a positive integer.");

    # Build the list of the first terms of the period sequence 
    period_list = [];

    for i in range(sequence_length):
        polynomial_power = power(laurent_polynomial, i);
        period_list.append(polynomial_power.constant_coefficient());

    return period_list;

def GL_action(function, monomial_matrix):
    """
    Returns the image of a Laurent polynomial or an element of a fraction field
    under a monomial change of variables.

    Arguments:
        function : A Laurent polynomial or an element of a fraction field.
        monomial_matrix : An invertible matrix over ZZ of size
            (function.parent()).ngens().

    Returns:
        An element of the parent Laurent polynomial ring or the fraction field.

    Example:
        sage : C.<a_1,a_2> = PolynomialRing(ZZ);
        sage : R.<x,y,z> = LaurentPolynomialRing(C);
        sage : M = diagonal_matrix(ZZ, (1, 1, -1));
        sage : GL_action(x + y + a_1*x^-1*y^-1 + z + a_2*z^-1, M)
        sage : x + y + a_2*z + z^-1 + a_1*x^-1*y^-1
    """
    parent_ring = function.parent();
    parent_ngens = parent_ring.ngens();

    # Sanity check
    if not (is_LaurentPolynomialRing(parent_ring) or \
            is_FractionField(parent_ring)):
        raise TypeError("The argument should be a Laurent polynomial "
                        "or an element of a fraction field.");
   
    matrix_space = MatrixSpace(ZZ, parent_ngens, parent_ngens);
    if not (monomial_matrix in matrix_space):
        raise ValueError('Incorrect base ring of the monomial matrix.');
    
    # Formally define a Laurent polynomial ring
    # to construct a monomial change of variables
    laurent_ring = \
        LaurentPolynomialRing(parent_ring.base_ring(), parent_ring.gens());
    arguments_list = [];
    for i in range(parent_ngens):
        arguments_list.append(laurent_ring.monomial(*monomial_matrix[i]));
    monomial_change = tuple(arguments_list);
  
    return function(monomial_change);

def largest_mutation_factor(laurent_polynomial):
    """
    Returns the largest mutation factor of a Laurent polynomial.

    Arguments:
        laurent_polynomial : A Laurent polynomial over ZZ, QQ, or over
            a polynomial ring over ZZ or QQ.

    Returns:
        An element of the polynomial ring of the parent Laurent polynomial ring.

    Example:
        sage : C.<a,b,c> = PolynomialRing(ZZ);
        sage : R.<x,y,z> = LaurentPolynomialRing(C);
        sage : P = x*y*z + x + b*y + c*z + a*x^-1 + c*x^-1*y^-1*z^-1
        sage : M = matrix(ZZ, ((1, -1, 1),
                               (0, 1, -1),
                               (0, 0, 1)))
        sage : Q = GL_action(P, M)
        sage : largest_mutation_factor(Q)
        sage : b*x*y + a*y + c
    """
    parent_ring = laurent_polynomial.parent();

    # Sanity check
    if not is_LaurentPolynomialRing(parent_ring):
        raise TypeError('Incorrect Laurent polynomial.');

    # Define the auxilliary rings
    frac_field = parent_ring.fraction_field();
    poly_ring = parent_ring.polynomial_ring();
    poly_ring_flattening = FlatteningMorphism(poly_ring);
    poly_ring_flattened = poly_ring_flattening.codomain();
    
    # Sanity check
    if not (poly_ring_flattened.base_ring() in (ZZ, QQ)):
        raise TypeError('Incorrect coefficient ring.')

    # Compute the minimal degree of a Laurent polynomial in the last generator
    parent_ngens = parent_ring.ngens();
    gen = parent_ring.gen(parent_ngens - 1);
    diag_matrix = diagonal_matrix(ZZ, (parent_ngens - 1)*[1] + [-1]);
    inverse_poly = GL_action(laurent_polynomial, diag_matrix);
    min_degree = -inverse_poly.degree(gen);

    # If the polynomial has non-negative degree in the last generator,
    # return the trivial mutation factor
    if (min_degree > -1) : return 1;

    # Compute the list of numerators
    numerators_list = [];
    for i in range(min_degree, 0):
        coefficient = laurent_polynomial.coefficient(gen^i);
        numerator = frac_field(coefficient).numerator();
        numerator_flattened = poly_ring_flattening(numerator);
        numerators_list.append(numerator_flattened);

    # Compute all possible mutations
    divisors_list = [];
    for divisor in divisors(gcd(numerators_list)):
        # Check that the divisor defines a mutation
        is_good = 1;
        for i in range(min_degree, 0):
            divisor_flattened = poly_ring_flattening(divisor^(-i));
            remainder = numerators_list[i].mod(divisor_flattened);
            if(remainder != 0) :
                is_good = 0;
                break;
        # If it holds, append the divisor to the list
        if is_good : divisors_list.append(divisor);

    return lcm(divisors_list);

def laurent_polynomial_mutation(laurent_polynomial, mutation_factor):
    """
    Returns the mutation of a Laurent polynomial w.r.t. to a mutation factor.

    Arguments:
        laurent_polynomial : A Laurent polynomial.
        mutation_factor : A polynomial in the parent Laurent polynomial ring.

    Returns:
        An element of the parent Laurent polynomial ring.

    Example:
        sage : C.<a,b,c> = PolynomialRing(ZZ);
        sage : R.<x,y,z> = LaurentPolynomialRing(C);
        sage : P = x*y*z + x + b*y + c*z + a*x^-1 + c*x^-1*y^-1*z^-1
        sage : M = matrix(ZZ, ((1, -1, 1),
                               (0, 1, -1),
                               (0, 0, 1)))
        sage : Q = GL_action(P, M)
        sage : F = (b*x*y + a*y + c)(R.polynomial_ring().gens());
        sage : laurent_polynomial_mutation(Q, F)
        sage : b*x^2*y*z + b*x^2*z + (b*c + a)*x*y*z + (a + c)*x*z + a*c*y*z +
               c*x*y^-1*z + c^2*z + x^-1*z^-1
    """
    parent_ring = laurent_polynomial.parent();
    
    # Sanity check
    if not is_LaurentPolynomialRing(parent_ring):
        raise TypeError('Incorrect Laurent polynomial.');

    frac_field = parent_ring.fraction_field();

    # Sanity check
    if not (mutation_factor in parent_ring.polynomial_ring()):
        raise TypeError('Incorrect mutation factor.');
    
    # Compute the maximal and minimal degrees in the last generator
    parent_ngens = parent_ring.ngens();
    gen = parent_ring.gen(parent_ngens - 1);
    max_degree = laurent_polynomial.degree(gen);
    diag_matrix = diagonal_matrix(ZZ, [1]*(parent_ngens - 1) + [-1]);
    inverse_poly = GL_action(laurent_polynomial, diag_matrix);
    min_degree = -inverse_poly.degree(gen);

    # Extract the free coefficient w.r.t. the last generator
    temp_ring = LaurentPolynomialRing(parent_ring.base_ring(), \
                                      parent_ring.gens()[:-1]);
    temp_ring_extended = LaurentPolynomialRing(temp_ring, [gen]);
    free_coeff = temp_ring_extended(laurent_polynomial).constant_coefficient();

    # Compute the mutated Laurent polynomial
    output = 0;
    for i in range(min_degree, max_degree + 1):
        if (i != 0):
            output += laurent_polynomial.coefficient(gen^i) * \
                frac_field(gen)^i * power(mutation_factor, i);
        else:
            output += free_coeff;

    # Return to the parent Laurent polynomial ring
    result = output(parent_ring.gens());

    # Sanity check
    if not (result in parent_ring):
        raise TypeError('Incorrect Laurent polynomial or a mutation factor.');

    return result;

def mutation_evaluation(laurent_polynomial, mutation_data):
    """
    Evaluate a mutation given by a mutation data triple on a Laurent polynomial.

    Arguments:
        laurent_polynomial : A Laurent polynomial.
        mutation_data : A tuple (A, f, B), where A and B are square invertible
            matrices over ZZ of size (laurent_polynomial.parent()).ngens(),
            and f is an element of the polynomial ring of
            the parent Laurent polynomial ring.

    Example:
        sage : R.<x,y,z> = LaurentPolynomialRing(ZZ);
        sage : F = y*z + x + y + z + x^-1 + x^-1*z^-1 + x^-1*y^-1;
        sage : M = (matrix(ZZ, ((-1, -1, 1),
                                (0, 1, 0),
                                (0, 1, -1))),
                    y + 1,
                    matrix(ZZ, ((0, -1, -1),
                                (1, -1, 0),
                                (1, -1, -1))));
        sage : mutation_evaluation(F, M)
        sage : x + y + z + x*y^-1 + x^-1 + y^-1*z^-1
    """
    parent_ring = laurent_polynomial.parent();

    # Sanity check
    if not is_LaurentPolynomialRing(parent_ring):
        raise TypeError('Incorrect Laurent polynomial.');
    
    parent_ngens = parent_ring.ngens();
    poly_ring = parent_ring.polynomial_ring();
    
    # Sanity check
    if not (len(mutation_data) == 3):
        raise TypeError('Incorrect mutation data.');

    for i in range(3):
        if (i%2 == 0):
            if not (mutation_data[i] in \
                    MatrixSpace(ZZ, parent_ngens)):
                raise TypeError('Incorrect mutation data.');
        else:
            if not (mutation_data[1] in parent_ring):
                raise TypeError('Incorrect mutation data.');

    # Evaluate the mutation
    output = laurent_polynomial;
    for i in range(3):
        if (i%2 == 0):
            output = GL_action(output, mutation_data[i]);
        else:
            mutation_factor = mutation_data[i](poly_ring.gens());
            output = laurent_polynomial_mutation(output, mutation_factor);

    return output;

def find_mutation_factors(laurent_polynomial_input, laurent_polynomial_output, \
                          matrices_list, recursion_depth):
    """
    Finds an explicit presentation of a composition of mutations transforming
    one Laurent polynomial into another in the assumption that
    the GL-equivalences are fixed.

    Arguments:
        laurent_polynomial_input : A Laurent polynomial over ZZ or QQ.
        laurent_polynomial_output : A Laurent polynomial over ZZ or QQ.
        matrices_list : A list of invertible matrices over ZZ of size
            n = (laurent_polynomial_input.parent()).ngens().
        recursion_depth : An integer in range(len(matrices_list)).
            It always should be equal to zero for the first call.

    Returns:
        A list of the form [A, f, B, g, ...], where [A,B,...] = matrices_list
        and f,g,... are elements of the flattening of the ring
        (laurent_in.parent()).polynomial_ring().

    Example:
        sage : R.<x,y,z> = LaurentPolynomialRing(ZZ);
        sage : minkowski_0070 = y*z + x + y + z + x^-1 + x^-1*z^-1 + x^-1*y^-1;
        sage : minkowski_0021 = x + y + z + x*y^-1 + x^-1 + y^-1*z^-1;
        sage : M1 = matrix(ZZ, [[0, 0, 1],
                                [1, 0, -1],
                                [0, 1, 0]]);
        sage : M2 = matrix(ZZ, [[0, 1, 1],
                                [1, -1, 0],
                                [0, 1, 0]]);
        sage : find_mutation_factors(minkowski_0070, minkowski_0021, [M1, M2],
                                     recursion_depth = 0)
        sage : [
               [ 0  0  1]         [ 0  1  1]
               [ 1  0 -1]         [ 1 -1  0]
               [ 0  1  0], y + 1, [ 0  1  0]
               ]
    """
    parent_ring = laurent_polynomial_output.parent();

    # Sanity check
    if not is_LaurentPolynomialRing(parent_ring):
        raise TypeError('Incorrect output Laurent polynomial.');
  
    if not (laurent_polynomial_input in parent_ring):
        raise TypeError('Incorrect input Laurent polynomial.');

    if not (parent_ring.base_ring() in (ZZ, QQ)):
        raise TypeError('Incorrect coefficient ring.');

    # Recursion implementation
    if (recursion_depth == len(matrices_list) - 1):
        GL_image = GL_action(laurent_polynomial_input, \
                                   matrices_list[recursion_depth]);
        if (GL_image == laurent_polynomial_output):
            return [matrices_list[recursion_depth]];
        else:
            return [];
    else:
        GL_image = GL_action(laurent_polynomial_input, \
                                   matrices_list[recursion_depth]);
        for divisor in divisors(largest_mutation_factor(GL_image)):
            for D in [-divisor, divisor]:
                input_mutated = laurent_polynomial_mutation(GL_image, D);
                output = find_mutation_factors(input_mutated, \
                                               laurent_polynomial_output, \
                                               matrices_list, \
                                               recursion_depth + 1);
                if (output != []):
                    return ([matrices_list[recursion_depth], D] + output);
    return [];

def find_mutation_call(args):
    """
    A wrapper for the function find_mutation_factors.

    Global variables:
        poly_input : A Laurent polynomial over a polynomial ring over ZZ or QQ.
        poly_output : A Laurent polynomial over a polynomial ring over ZZ or QQ.
        words_input : A tuple of invertible matrices over ZZ of size n
            for n = (laurent_in.parent()).ngens().

    Arguments:
        args : A tuple of the elements in range(len(words)).
    """
    return find_mutation_factors\
        (*tuple([poly_input, poly_out,
                 tuple([words_input[i] for i in args]), 0]))

def find_mutation(laurent_in, laurent_out, words_tuple, steps):
    """
    Finds an explicit presentation of a mutation transforming one Laurent
    polynomial into another.

    WARNING! Could be CPU and memory consuming.

    REMARK. Loads tqdm module for the progress bar.

    Arguments:
        laurent_in : A Laurent polynomial over a polynomial ring over ZZ or QQ.
        laurent_out : A Laurent polynomial over a polynomial ring over ZZ or QQ.
        words_tuple : A tuple of Z-invertible matrices of size n
            for n = (laurent_in).parent().ngens().
        steps : A non-negative integer.

    Returns:
        A list of the form [A, f, B, g, ...], where A,B,... are in words_tuple
        and f,g,... are elements of the flattening of the ring
        (laurent_in.parent()).polynomial_ring().

    Example:
        sage : R.<x,y,z> = LaurentPolynomialRing(ZZ);
        sage : W1 = matrix_words(GL_generators(3), 9);
        sage : W2 = GL_bounded(3, 1);
        sage : W = tuple(W1.intersection(W2));
        sage : minkowski_0070 = y*z + x + y + z + x^-1 + x^-1*z^-1 + x^-1*y^-1;
        sage : minkowski_0021 = x + y + z + x*y^-1 + x^-1 + y^-1*z^-1;
        sage : find_mutation(minkowski_0070, minkowski_0021, W, 1)
        sage : [
               [ 0  0  1]         [ 1 -1 -1]
               [ 0 -1 -1]         [ 0  0  1]
               [ 1  1  0], x + 1, [-1  0  0]
               ]
    """
    parent_ring = laurent_out.parent();

    # Sanity check
    if not is_LaurentPolynomialRing(parent_ring):
        raise TypeError('Incorrect output Laurent polynomial.');   
    
    # Sanity check
    if not (laurent_in in parent_ring):
        raise TypeError('The parent Laurent polynomial rings are different.');

    # Sanity check
    if not (steps in ZZ) or not (steps > -1):
        raise TypeError('Incorrect steps number.');
    
    # Define the global variables for the wrapper find_mutation_call
    global poly_input; poly_input = laurent_in;
    global poly_out; poly_out = laurent_out
    global words_input; words_input = words_tuple;

    import multiprocessing
    import gc
    from tqdm import tqdm

    # Parallel computing
    if __name__ == '__main__':
        gc.enable()
        p = multiprocessing.Pool(multiprocessing.cpu_count());

        output = [];
        indexes_tuple = Tuples(range(len(words_tuple)), steps + 1);
        for result in p.imap_unordered(find_mutation_call, \
                                       tqdm(indexes_tuple), chunksize=1):
            if (result != []):
                output.append(result);
                p.terminate();
                break;
        p.close();
        p.join();

    if len(output) > 0:
        return output[0];
    else:
        return [];

def mutation_presentation_routine(mutation_list, matrices_list):
    """
    Presents a mutation data in the explicit form assuming that
    the GL-equivalences are fixed.

    Args:
        mutation_list : A list of rational functions.
        matrices_list : A list of monomial matrices for a GL-equivalence.

    Returns:
        A list [matrices_list[0], f, matrices_list[1]], where f is
        an element of the ring PolynomialRing(base_ring, par.gens())
        for par = mutation_list[0].parent(), base_ring = par.base_ring().

    Example:
        sage : R.<x,y,z> = LaurentPolynomialRing(ZZ);
        sage : T = (x + y, x/y, (y*z)/(x + y));
        sage : M1 = matrix(ZZ, [[0, -1, 1],
                                [1, 0, 0],
                                [-1, 0, -1]]);
        sage : M2 = matrix(ZZ, [[1, -1, 0],
                                [-1, 0, -1],
                                [1, 1, 1]]);
        sage : mutation_presentation_routine(T, [M1, M2])
        sage : [
               [ 0 -1  1]               [ 1 -1  0]
               [ 1  0  0]               [-1  0 -1]
               [-1  0 -1], x*y^2 + y^2, [ 1  1  1]
               ]
    """
    if (len(matrices_list) != 2):
        raise ValueError('Incorrect matrices data.');
    parent_ring = mutation_list[0].parent();
    laurent_ring = \
        LaurentPolynomialRing(parent_ring.base_ring(), parent_ring.gens());
    frac_field = laurent_ring.fraction_field();    
    poly_ring_reduced = \
        PolynomialRing(parent_ring.base_ring(), parent_ring.gens()[:-1]);

    # Act on the coordinate functions by the product of matrices
    prod = identity_matrix(ZZ, parent_ring.ngens());
    for i in matrices_list: prod *= i;

    coord_image = [];
    for i in range(0, matrices_list[0].nrows()):
        coord_image.append(GL_action(laurent_ring.gen(i), prod));

    # Twist the original functions by the obtained monomials
    pre_converted = [];
    for i in range(0, len(mutation_list)):
        pre_converted.append(mutation_list[i] / coord_image[i]);

    # Act on the obtained functions by the inverse of the second matrix
    converted = [];
    inv = matrices_list[1].inverse();
    for i in range(0, len(mutation_list)):
        converted.append(GL_action(pre_converted[i], inv));

    # Check if we really obtain the required powers of the same polynomial
    bases = set();
    for i in range(0, len(mutation_list)):
        ind = matrices_list[0].transpose()[-1][i];
        if (ind != 0):
            temp = power(converted[i], sign(ind));
            if (frac_field(temp).denominator() != 1):
                return [];
            else:
                temp = frac_field(temp).numerator();

            if not (temp in poly_ring_reduced) : return [];
            
            c = 1;
            for [j,k] in list(poly_ring_reduced(temp).factor()):
                if (k % (ind*sign(ind)) == 0) :
                    c *= power(j, (k / (ind*sign(ind))));
                else:
                    return [];
            bases.add(c);
        else:
            if (converted[i] != 1) : return [];

    # Return the result
    if (len(bases) != 1):
        return [];
    else:
        return [matrices_list[0], \
                poly_ring_reduced(tuple(bases)[0]), matrices_list[1]];

def mutation_presentation_call(args):
    """
    A wrapper for the function mutation_presentation_routine.

    Global variables:
        mutation_input : A list of Laurent polynomial over
                         a polynomial ring over ZZ or QQ.
        words_input : A tuple of Z-invertible matrices of size n
            for n = (laurent_in).parent().ngens().

    Arguments:
        args : A tuple of the elements in range(len(words)).
    """    
    return mutation_presentation_routine\
        (*tuple([mutation_input, tuple([words_input[i] for i in args])]));
    
def mutation_presentation(mutation_data, words_tuple):
    """
    Presents a mutation data in the explicit form.

    WARNING! Could be CPU and memory consuming.

    REMARK. Loads tqdm module for the progress bar.

    Arguments:
        mutation_data : A list of rational functions.
        words_tuple : A tuple of possible monomial matrices of GL-equivalences.

    Returns:
        A list [A, f, B], where A, B are invertible matrices over ZZ,
        and f is a polynomial.

    Example:
        sage : R.<x,y,z> = LaurentPolynomialRing(ZZ);
        sage : W1 = matrix_words(GL_generators(3), 9);
        sage : W2 = GL_bounded(3, 1);
        sage : W = tuple(W1.intersection(W2));
        sage : T = tuple([x + y, x/y, (y*z)/(x + y)]);
        sage : mutation_presentation(T, W)
        sage : [
               [ 0  0  1]           [ 1 -1  0]
               [ 1  0  0]           [ 1  0  1]
               [-1  1 -1], x*y + y, [-1  1 -1]
               ]
    """
    # Define the global variables for the wrapper mutation_presentation_call
    global mutation_input; mutation_input = mutation_data;
    global words_input; words_input = words_tuple;
    
    import multiprocessing
    import gc
    from tqdm import tqdm

    # Parallel computing
    if __name__ == '__main__':
        gc.enable()
        p = multiprocessing.Pool(multiprocessing.cpu_count());
        
        output = [];
        indexes_tuple = Tuples(range(len(words_tuple)), 2);
        for result in p.imap_unordered(mutation_presentation_call, \
                                       tqdm(indexes_tuple), chunksize=1):
            if (result != []):
                output.append(result);
                p.terminate();
                break;
        p.close();
        p.join();

    if len(output) > 0:
        return output[0];
    else:
        return [];
