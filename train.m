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

WeightName = '3_SimpDiv'; % linux1
WeightName = '4_Half';    % linux14
WeightName = '5_Quad';    % linux7
WeightName = '6_Half10';   % linux14
WeightName = '7_HalfQuad';   % linux7
WeightName = 'origin';

M = 10000;
nSegList = [10];
%nSegList = [300 400 500 600 700 800 900 1000 2000];
for nSeg = nSegList
    SaveModelDir = ['../trans_ANN/Weights/' int2str(M) '_' int2str(nSeg) '/' WeightName '/'];
    weight = GenWeight(dim);
    for i=1:nSeg
        s = (i-1)*M+1;
        e = s + M-1;

        X0 = orth(rand(dim,dim));
        tic; [X, out]= OptStiefelGBB(X0, fun, opts, A(:,s:e),weight); tsolve = toc;

        fprintf('\nOptM: obj: %7.6e, itr: %d, nfe: %d, cpu: %f, norm(XT*X-I): %3.2e \n', ...
                 out.fval, out.itr, out.nfe, tsolve, norm(X'*X - eye(dim), 'fro') );

        save([ SaveModelDir 'X_'  int2str(M) '_' int2str(i)], 'X');
    end
end
