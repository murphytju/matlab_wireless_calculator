
%������ʽ��������������ؼ������������о���ֵ�Լ�ƥ���˲���
%���ͽ��������Ľ�����ڽ��նε���
for cycle=1:10
tic;
Receive=audiorecorder(80000,8,1);
recordblocking(Receive,2);%1.6
Receive = getaudiodata(Receive);
Receive=abs(Receive);                          % �����ֵ�����Ժ�ʶ��1
fsk=Receive;
figure(1);
subplot(221);
stem(fsk);
fs=800;   %����Ƶ��
N=length(Receive)/fs;
dt=1/fs; 
t=0:dt:N-dt; 
b1=fir1(101,[10/800 20/800]); 
b2=fir1(101,[90/800 110/800]);      %���ô������ 
H1=filter(b1,1,4*fsk);       %b1Ϊ���Ӫ�1Ϊ��ĸ��snΪ�˲����������� 
H2=filter(b2,1,4*fsk);       %�����ź�ͬʱͨ�������˲��� 
sw1=H1.*H1;                        %��ɽ������ͬƵͬ����ز� 
sw2=H2.*H2;%��������� 
bn=fir1(101,[2/800 10/800]);             %������ͨ�˲��� 
st1=filter(bn,1,sw1); 
st2=filter(bn,1,sw2); 
for i=1:length(t) 
 if(st1(i)>=st2(i)) 
   st(i)=0; 
  else st(i)=st2(i); 
 end  
end 
st=st1+st2; 
st(size(st)+1)=st(size(st));
subplot(222);
stem(st);
bfsk=zeros(1,N);
for i=801:800:800*N+1
    j=fix(i/800);
    bfsk(j)=st(i);
end
for i=1:length(bfsk)
    if(bfsk(i)>=0.75)
        bfsk(i)=1;
    else bfsk(i)=0;
    end
end
% for i=1:length(t) 
%  if(st1(i)>=st2(i)) 
%    st(i)=1; 
%   else st(i)=0;
%  end  
% end 
% st(size(st)+1)=st(size(st));
% subplot(222);
% stem(st);
% bfsk=zeros(1,N);
% for i=801:800:800*N+1
%     j=fix(i/800);
%     bfsk(j)=st(i);
% end
BCD2=zeros(1,80);
for i=1:length(bfsk)-6
    if bfsk(i)==1
        if bfsk(i+1)==1
            if bfsk(i+2)==1
                if bfsk(i+3)==0
                    if bfsk(i+4)==0
                        if bfsk(i+5)==1
                            if bfsk(i+6)==0
                                break;
                            end
                        end
                    end
                end
            end
        end   
    end
end
k=1;
for j=i:i+71
    if i>length(bfsk)-72
        break;
    end
    BCD2(k)=bfsk(j);
    k=k+1;
end
subplot(223);
stem(bfsk);
BCD3=BCD2;
subplot(224);
stem(BCD3);
NumberA=0;
NumberB=0;  
BCD2=BCD2(8:70);
BCD2=reshape(BCD2,7,9);
BCD2=BCD2';
BCD2=decode1(BCD2);
BCD2=BCD2';
BCD2=reshape(BCD2,1,36);
Begin=0;
    for j=1:4                                       % ��BCD����Ϊʮ������ �������������
        i=(j-1)*4+1;
        if BCD2(Begin+i)==0
            if BCD2(Begin+i+1)==0
                if BCD2(Begin+i+2)==0
                    if BCD2(Begin+i+3)==0
                        NumberA=NumberA+0;
                    elseif BCD2(Begin+i+3)==1
                        NumberA=NumberA+1*10^(4-j);
                    end
                elseif BCD2(Begin+i+2)==1
                    if BCD2(Begin+i+3)==0
                        NumberA=NumberA+2*10^(4-j);
                    elseif BCD2(Begin+i+3)==1
                        NumberA=NumberA+3*10^(4-j);
                    end
                end
            elseif BCD2(Begin+i+1)==1
                if BCD2(Begin+i+2)==0
                    if BCD2(Begin+i+3)==0
                        NumberA=NumberA+4*10^(4-j);
                    elseif BCD2(Begin+i+3)==1
                        NumberA=NumberA+5*10^(4-j);
                    end
                elseif BCD2(Begin+i+2)==1
                    if BCD2(Begin+i+3)==0
                        NumberA=NumberA+6*10^(4-j);
                    elseif BCD2(Begin+i+3)==1
                        NumberA=NumberA+7*10^(4-j);
                    end
                end
            end
        elseif BCD2(Begin+i)==1
            if BCD2(Begin+i+1)==0
                if BCD2(Begin+i+2)==0
                    if BCD2(Begin+i+3)==0
                        NumberA=NumberA+8*10^(4-j);
                    elseif BCD2(Begin+i+3)==1
                        NumberA=NumberA+9*10^(4-j);
                    end
                end
            end
        end
    end
    for j=6:9
        i=(j-1)*4+1;
        if BCD2(Begin+i)==0
            if BCD2(Begin+i+1)==0
                if BCD2(Begin+i+2)==0
                    if BCD2(Begin+i+3)==0
                        NumberB=NumberB+0;
                    elseif BCD2(Begin+i+3)==1
                        NumberB=NumberB+1*10^(9-j);
                    end
                elseif BCD2(Begin+i+2)==1
                    if BCD2(Begin+i+3)==0
                        NumberB=NumberB+2*10^(9-j);
                    elseif BCD2(Begin+i+3)==1
                        NumberB=NumberB+3*10^(9-j);
                    end
                end
            elseif BCD2(Begin+i+1)==1
                if BCD2(Begin+i+2)==0
                    if BCD2(Begin+i+3)==0
                        NumberB=NumberB+4*10^(9-j);
                    elseif BCD2(Begin+i+3)==1
                        NumberB=NumberB+5*10^(9-j);
                    end
                elseif BCD2(Begin+i+2)==1
                    if BCD2(Begin+i+3)==0
                        NumberB=NumberB+6*10^(9-j);
                    elseif BCD2(Begin+i+3)==1
                        NumberB=NumberB+7*10^(9-j);
                    end
                end
            end
        elseif BCD2(Begin+i)==1
            if BCD2(Begin+i+1)==0
                if BCD2(Begin+i+2)==0
                    if BCD2(Begin+i+3)==0
                        NumberB=NumberB+8*10^(9-j);
                    elseif BCD2(Begin+i+3)==1
                        NumberB=NumberB+9*10^(9-j);
                    end
                end
            end
        end
    end
    disp(NumberA);
    Result=0;
    if BCD2(Begin+17)==1 && BCD2(Begin+18)==0 && BCD2(Begin+19)==1 && BCD2(Begin+20)==0                 % ���ݷ���λ����ж���������
        Result=NumberA+NumberB;
        disp('+');
    elseif BCD2(Begin+17)==1 && BCD2(Begin+18)==0 && BCD2(Begin+19)==1 && BCD2(Begin+20)==1
        Result=NumberA-NumberB;
        disp('-');
    elseif BCD2(Begin+17)==1 && BCD2(Begin+18)==1 && BCD2(Begin+19)==0 && BCD2(Begin+20)==0
        Result=NumberA*NumberB;
        disp('*');
    elseif BCD2(Begin+17)==1 && BCD2(Begin+18)==1 && BCD2(Begin+19)==0 && BCD2(Begin+20)==1
        Result=fix(NumberA/NumberB);
        disp('/');
    else
        Result=NumberA+NumberB;
        disp('+');
    end
    disp(NumberB);
    disp('=');
    disp(Result);
toc;
t=toc;
pause(2.8-t);
%�����������������������������������ܼ��㹤������ʼΪ��һ̨��������ͽ��������������������������������������������������������������������������
tic;
disp('��ʼ����');
Ex=zeros(1,8);
    for i=1:8                                         % ��ʮ��������ÿһλȡ�� �Ա�֮��תΪBCD��
        Ex(9-i)=mod(Result,10);
        Result=fix(Result/10);
    end
    BCD=zeros(1,32);                                  % BCD�ǽ���λ�ַ���ת��32λ��ÿ���ַ�4λ����������ľ���
  
    for i=1:8
        j=4*(i-1)+1;
        if Ex(i)==0
        elseif Ex(i)==1                               % תBCD�� 0~9�ֱ��Ӧ������0000~1001
            BCD(j+3)=1;
        elseif Ex(i)==2
            BCD(j+2)=1;
        elseif Ex(i)==3
            BCD(j+2)=1;
            BCD(j+3)=1;
        elseif Ex(i)==4
            BCD(j+1)=1;
        elseif Ex(i)==5
            BCD(j+1)=1;
            BCD(j+3)=1;
        elseif Ex(i)==6
            BCD(j+1)=1;
            BCD(j+2)=1;
        elseif Ex(i)==7
            BCD(j+1)=1;
            BCD(j+2)=1;
            BCD(j+3)=1;
        elseif Ex(i)==8
            BCD(j)=1;
        elseif Ex(i)==9
            BCD(j)=1;
            BCD(j+3)=1;
        end
    end
    BCD=hanming(BCD);
    BCD=BCD';
    BCD=reshape(BCD,1,56);
    BCD=[BCD zeros(1,7)];
    Bak=[1 1 1 0 0 1 0];                              % �ӰͿ���
    BCD=[Bak BCD];
    BCD=[BCD 1 1];
    BCD=~BCD;
fs=800;   %����Ƶ�� 
dt=1/fs; 
f1=20;     %���������ز���Ƶ�� 
f2=100; 
a=BCD;
g1=a; 
g2=~a; 
g11=(ones(1,800))'*g1;  %���������ź� 
g1a=g11(:)';  
g21=(ones(1,800))'*g2; 
g2a=g21(:)'; 
t=0:dt:72-dt; 
t1=length(t); 
tuf1=cos(2*pi*f1.*t);
tuf2=cos(2*pi*f2.*t); 
fsk1=g1a.*tuf1; 
fsk2=g2a.*tuf2; 
fsk=fsk1+fsk2; 
sound(fsk,80000);                           % ��20kHz�����ѵ��� ������20kb/s ������20k/(100*4)B/s
% out=[fsk];
% plot(out);
pause(1.5);
toc;
t=toc;
pause(2.2-t);
clear pause;
end