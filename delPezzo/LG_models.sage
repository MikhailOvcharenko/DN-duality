parameters_list = [];
for i in range(9) : parameters_list.append('a_' + str(i + 1));
parameters_ring = PolynomialRing(QQ, names = parameters_list);
parameters_ring.inject_variables();
laurent_ring.<x,y> = LaurentPolynomialRing(parameters_ring);

dP_quadric_LG_model = x + a_1*x^-1 + y + a_2*y^-1;

dP_09_LG_model = x + y + a_1*x^-1*y^-1;

dP_08_LG_model = x + y + a_1*x^-1*y^-1 + a_1*a_2*x^-1;

dP_07_LG_model = x + y + a_1*x^-1*y^-1 + a_1*a_2*x^-1 + a_1*a_3*y^-1;

dP_06_LG_model = x + y + a_1*x^-1*y^-1 + a_1*a_2*x^-1 + a_1*a_3*y^-1 + a_4*x*y;

dP_05_LG_model = x + (a_1*a_2*a_4*a_5 + 1)*y + a_1*x^-1*y^-1 + \
    a_1*(a_2 + a_5)*x^-1 + a_1*a_3*y^-1 + a_4*x*y + a_1*a_2*a_5*x^-1*y;

dP_04_LG_model = x + (a_1*a_2*a_4*a_5 + 1)*y + \
    a_1*(a_1*a_3*a_6*(a_2 + a_5) + 1)*x^-1*y^-1 + \
    a_1*(a_1*a_2*a_3*a_5*a_6 + a_2 + a_5)*x^-1 + a_1*(a_3 + a_6)*y^-1 + \
    a_4*x*y + a_1*a_2*a_5*x^-1*y + a_1^2*a_3*a_6*x^-1*y^-2;

dP_03_LG_model = (a_1*a_4*a_7*(a_3 + a_6) + 1)*x + \
    (a_1*a_2*a_5*(a_4 + a_7) + 1)*y + \
    a_1*(a_1*a_3*a_6*(a_2 + a_5) + 1)*x^-1*y^-1 + \
    a_1*(a_1*a_2*a_3*a_5*a_6 + a_2 + a_5)*x^-1 + \
    a_1*(a_1*a_3*a_4*a_6*a_7 + a_3 + a_6)*y^-1 + \
    (a_1*a_2*a_4*a_5*a_7 + a_4 + a_7)*x*y + \
    a_1*a_2*a_5*x^-1*y + a_1^2*a_3*a_6*x^-1*y^-2 + a_4*a_7*x^2*y;
