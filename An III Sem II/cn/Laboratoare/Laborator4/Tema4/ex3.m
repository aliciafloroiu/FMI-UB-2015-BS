A = [10, 7, 8, 7; 7, 5, 6, 5; 8, 6 10, 9; 7, 5, 9, 10];
b = [32; 23; 33; 31];
x = [1; 1; 1; 1];

% a
x_a = inv(A) * b

% b
A_pert = [10, 7, 8.1, 7.2; 7.08, 5.04, 6, 5; 8, 5.98, 9.89, 9; 6.99, 4.99, 9, 9.98];
b_pert = [32.1; 22.9; 33.1; 30.9];
x_pert = inv(A_pert) * b_pert

% c
k1 = cond(A, 1)
k2 = cond(A, 2)
kinf = cond(A, inf)