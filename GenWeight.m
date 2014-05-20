function weight = GenWeight(Len)
    weight = zeros(1,Len);
    weight = [1:Len]; % origin
    return
    %weight = [Len:-1:1]; % 2_DecByOne
    % 3_SimpleDiv
    %ratio = [10 20 30 40 50 60 70 80 90];
    % 4_Double
    %ratio = [20 40 60 80] ;
    % 5_Quad 
    %ratio = [25 50 75];
    % 6_Half10 
    ratio = [50 60 70 80 90];
    % 7_HalfQuad 
    ratio = [50 75];

    pivots = floor(ratio*Len/100);
    rank = size(ratio,2);
    r = 0;
    start = 1; endp = pivots(r+1);
    while endp <= Len
        weight(start:endp) = 2^r;
        r = r + 1;
        if endp == Len
            break
        end
        start = pivots(r);
        if r+1 <= rank
            endp = pivots( r+1 );
        else
            endp = Len;
        end
    end
end 
