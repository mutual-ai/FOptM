function V = MGramSchmidt(V)
[n,k] = size(V);

for dj = 1:k
    for di = max(1,dj-4):dj-1
        tmp = V(:,di);
        tmp(find(V(:,dj)==0)) = 0;
        
        
        if norm(tmp) > 1e-3
            norm(tmp)
            V(:,dj) = V(:,dj) - tmp * tmp'*V(:,dj)/sumsqr(tmp);
        end
    end
    norm(V(:,dj))
    V(:,dj) = V(:,dj)/norm(V(:,dj));
end

end
