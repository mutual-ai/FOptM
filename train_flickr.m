clear
clc
format long
rand('seed',304);
randn('seed',304);

opts.record = 10;
opts.mxitr  = 1e+7;
opts.xtol = 1e-5;
opts.gtol = 1e-5;
opts.ftol = 1e-8;
fun = @objGrad; 

DataDir = '/home/master/01/r01922165/zzzzz/Dataset/Image/Flickr/flickr/ParsedData/';
FileName = {'1_ColorLayout192','2_ColorStruct256','3_ScalColor256','4_HomoText43','5_EdgeHist150'};

%for FeaFileNum=1:size(FileName,2)
for FeaFileNum=3:5
    filename = [DataDir,FileName{FeaFileNum}];
    load(filename);
    A = data';
    clear data
    dim = size(A,1);    N = size(A,2);

    for WChoice=1:2
        switch WChoice
            case 1
                WeightName = 'origin';
            case 2
                WeightName = '2_heur';
            otherwise
                'WChoice error.'
                exit
        end

        M = 200; % Num of instances on a single machine.
        nSegList = [5000];
        for nSeg = nSegList
            %SaveModelDir = ['../trans_flickr/' int2str(FeaFileNum) '/' int2str(M) '_' int2str(nSeg) '/' WeightName '/'];
            SaveModelDir = ['../trans_flickr/' int2str(FeaFileNum) '_2/' int2str(M) '_' int2str(nSeg) '/' WeightName '/'];
            weight = GenWeight(dim,WChoice);
            if WChoice == 2
                weight = cumsum(sum(A(:,s:e).*A(:,s:e),2));
                weight = weight / max(weight);
            end
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
    end
    clear A;
end
