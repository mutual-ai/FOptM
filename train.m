clear
clc
format long
%load '';
A = fvecs_read('/home/master/01/r01922165/zzzzz/Dataset/Image/ANN_SIFT1M/sift/sift_base.fvecs');
%A = data';


dim = size(A,1);
N = size(A,2);

rand('seed',304);
randn('seed',304);

opts.record = 10;
opts.mxitr  = 1e+7;
opts.xtol = 1e-5;
opts.gtol = 1e-5;
opts.ftol = 1e-8;
fun = @objGrad; 
M = 500;
nSeg = 200;

WeightName = '3_SimpDiv';
WeightName = '4_Half';
SaveModelDir = ['../trans_ANN/Weights/' int2str(M) '_' int2str(nSeg) '/' WeightName '/'];
weight = GenWeight(dim);
for i=1:nSeg
    s = (i-1)*M+1;
    e = s + M;

    X0 = orth(rand(dim,dim));
    tic; [X, out]= OptStiefelGBB(X0, fun, opts, A(:,s:e),weight); tsolve = toc;

    fprintf('\nOptM: obj: %7.6e, itr: %d, nfe: %d, cpu: %f, norm(XT*X-I): %3.2e \n', ...
             out.fval, out.itr, out.nfe, tsolve, norm(X'*X - eye(dim), 'fro') );

    save([ SaveModelDir 'X_'  int2str(M) '_' int2str(i)], 'X');
end

%{
ratio = zeros(1,dim);
B = X*A;
for i = 1:size(A,2) % for all instances
    tmpr = [];
    for h = 1:dim   % for all dimensions
        tmpr = [tmpr  (B(h,i)/A(h,i))^2];
    end
    ratio = ratio + tmpr/size(A,2);
end
%}

