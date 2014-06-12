function weight = GenWeight(Len, WChoice)
    weight = zeros(1,Len);
    switch WChoice
        case 0
            base = 1.0;
            for i = 1:Len
                weight(i) = base;
                base = base/0.9;
            end
            return
        case 1
            weight = [1:Len]; % origin
            return
        case 2
            weight = [Len:-1:1]; % 2_heur
            return
        case 3
    % 3_SimpleDiv
            ratio = [10 20 30 40 50 60 70 80 90];
        case 4
        % 4_Double
            ratio = [20 40 60 80] ;
        case 5
        % 5_Quad 
            ratio = [25 50 75];
        case 6
    % 6_Half10 
            ratio = [50 60 70 80 90];
        case 7
    % 7_HalfQuad 
            ratio = [50 75];
        case 8
            % Dec
            ratio = 10:10:90;
        case 9
            % Five
            ratio = 5:5:95;

        otherwise
            'WChoice error'
            exit
    end

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
