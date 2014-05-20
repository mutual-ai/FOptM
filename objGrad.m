function [obj G] = ObjGrad(X,A,weight)
%%  X is DXD matrix, so does G.
%   A is DXN matrix

    dim = size(A,1);
  
    W = diag(weight);

    B = X*A;
    obj = norm(sqrt(W)*B)^2;
    G = W*B*A';
 
end % func ObjGrad
