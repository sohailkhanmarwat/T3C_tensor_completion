% SVD with manually determined tt-ranks to inital G and update tt-ranks

function [Z_init,r_init]=TR_Z_init(X,W,r_ori)
S=size(X);
X=X.*W;
X(W==0)=mean(X(:)); % fill missing entries with mean value
N=ndims(X);
Z=cell(N,1);
r=r_ori;
X=tensor(X);
X1=double(tenmat(X,1));
% fprintf('manually determined tt-ranks are: ');disp(r);fprintf('\n');
% SVD method has limitations: r(1) need to be no bigger than S(1), and when
% 1<n<N, r(n) is no bigger than r(n-1)xS(n)
[u,s,v]=svd(X1,'econ');
ss=size(s);
r(1)=min(ss(1),ss(2));
Z{1}=reshape(u,[r(N),S(1),r(1)]);
M=s*v';
for i=2:N-1
    M=reshape(M,[r(i-1)*S(i),numel(M)/(r(i-1)*S(i))]);
    [u,s,v]=svd(M,'econ');
    ss=size(s);
    if r(i)>min(ss(1),ss(2))
    r(i)=min(ss(1),ss(2));
    end
     s=diag(s);
     u=u(:,1:r(i));
     s=s(1:r(i));
     v=v(:,1:r(i));
    Z{i}=reshape(u,[r(i-1),S(i),r(i)]);
    M=diag(s)*v';
end
Z{N}=reshape(M,[r(N-1),S(N),r(N)]);

% r_new=[]; % in case of the manually determined r is too big, r_new is detected from G
% for i=1:N-1
%     sG=size(G{i});
%     r_new=[r_new sG(3)];
% end

% fprintf('new tt-ranks cut by SVD are: ');disp(r_new);fprintf('\n');

Z_init=Z;
r_init=zeros(N,1);
for i=1:N
    r_init(i)=size(Z{i},3);
end

end