function C = hanming(M)
G = [1 0 0 0 1 1 0;
     0 1 0 0 1 0 1;
     0 0 1 0 0 1 1;
     0 0 0 1 1 1 1];
[k,n] = size(G);
N = size(M,2);  % �����������Ԫ�ظ���
r = mod(-rem(N,k),k);   % �����Ҫ���������н��в�λ�ĸ���
M_add0 = [M,zeros(1,r)];% ��λ
groups = ceil(length(M_add0)/k);    % ��÷������
M_dis = reshape(M_add0,[k,groups]).';
C = mod(M_dis*G,2);% ���ɽ�������˶�2ȡ��
end
