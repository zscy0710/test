function R = EuDist2(A,B,~)
    % A, B : d×n
    dist = bsxfun(@plus,sum(A.^2,1)',sum(B.^2,1))-2*(A'*B); % n×n
    dist(dist<0)=0;
    dist = sqrt(dist);
    R = A * dist * B';   % d×d
end