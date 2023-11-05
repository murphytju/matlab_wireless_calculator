function C = hanming(M)
G = [1 0 0 0 1 1 0;
     0 1 0 0 1 0 1;
     0 0 1 0 0 1 1;
     0 0 0 1 1 1 1];
[k,n] = size(G);
N = size(M,2);  % 获得输入序列元素个数
r = mod(-rem(N,k),k);   % 获得需要对输入序列进行补位的个数
M_add0 = [M,zeros(1,r)];% 补位
groups = ceil(length(M_add0)/k);    % 获得分组个数
M_dis = reshape(M_add0,[k,groups]).';
C = mod(M_dis*G,2);% 生成结果别忘了对2取余
end
