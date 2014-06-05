clear
clc
format long
%load '';
%A = fvecs_read('/home/master/01/r01922165/zzzzz/Dataset/Image/ANN_SIFT1M/sift/sift_base.fvecs');
%A = data';
DataDir = '/home/master/01/r01922165/zzzzz/Dataset/Image/Flickr/flickr/ParsedData/';
FileName = {'1_ColorLayout192','2_ColorStruct256'};
for i=1:size(FileName,2)
    filename = [DataDir,FileName{i}]
    load(filename)

end
return


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

WChoice = 2;
switch WChoice
    case 1
        WeightName = 'origin';
    case 2
        WeightName = '2_heur';
    case 3
        WeightName = '3_SimpDiv'; % linux1
    case 4
        WeightName = '4_Half';    % linux14
    case 5
        WeightName = '5_Quad';    % linux7
    case 6
        WeightName = '6_Half10';   % linux14
    case 7
        WeightName = '7_HalfQuad';   % linux7
    case 8
        WeightName = '8_Dec';   % linux7
    case 9
        WeightName = '9_Five';   % linux7
    otherwise
        'WChoice error.'
        exit
end

M = 200; % Num of instances on a single machine.
nSegList = [5000];
%nSegList = [300 400 500 600 700 800 900 1000 2000];
for nSeg = nSegList
    SaveModelDir = ['../trans_ANN/Weights/' int2str(M) '_' int2str(nSeg) '/' WeightName '/'];
    weight = GenWeight(dim,WChoice);
    for i=1:nSeg
        s = (i-1)*M+1;
        e = s + M-1;

        X0 = orth(rand(dim,dim));
        if WChoice == 2
            weight = cumsum(sum(A(:,s:e).*A(:,s:e),2));
            weight = weight / max(weight);
        end
        tic; [X, out]= OptStiefelGBB(X0, fun, opts, A(:,s:e),weight); tsolve = toc;

        fprintf('\nOptM: obj: %7.6e, itr: %d, nfe: %d, cpu: %f, norm(XT*X-I): %3.2e \n', ...
                 out.fval, out.itr, out.nfe, tsolve, norm(X'*X - eye(dim), 'fro') );

        save([ SaveModelDir 'X_'  int2str(M) '_' int2str(i)], 'X');
    end
end
