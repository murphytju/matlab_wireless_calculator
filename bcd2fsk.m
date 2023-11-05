%已知BCD码进行调制，并用音频发送出去
%目标输入算式输出BCD码
%BCD码再进行信道编码，加上用于同步的码头
%回收信号,解码得到结果
mistake=0;
for cycle=1:10
tic;
sign=0;
swt_sign=1;
no1=randi([1,9999],1,1);
no2=randi([1,3],1,1);
no3=randi([1,9999],1,1);
if no2==1
    EnterNumbers=[num2str(no1),'+',num2str(no3)];
    no2=no1+no3;
elseif no2==2
    if no1<no3
        no4=no1;no1=no3;no3=no4;
    end
    EnterNumbers=[num2str(no1),'-',num2str(no3)];
    no2=no1-no3;
elseif no2==3
    EnterNumbers=[num2str(no1),'*',num2str(no3)];
    no2=no1*no3;
end
%EnterNumbers=input('请输入算式: \n','s');          % 输入算式
len=length(EnterNumbers);                         % 求字符串长度
% if len>9                                          % 如果字长超过9（ 四位数 运算符 四位数 ） 说明错了 
%     disp('输入算式过长! 请重新输入!');
%     continue;
% end
for i = 1:len                                     % 找运算符 
    if EnterNumbers(i)=='+' || EnterNumbers(i)=='-' || EnterNumbers(i)=='*' || EnterNumbers(i)=='/'
        if swt_sign==1                            % 第一次找到 用sign记下运算符位置
            sign=i;
            swt_sign=0;
        else                                                % 若找到两个以上运算符 报错
            sign=0;
            break;
        end
    elseif EnterNumbers(i)<'0' || EnterNumbers(i)>'9'       % 找到除0~9 运算符以外的符号 报错
        sign=0;
        break;
    end
end
% if sign<=1 || sign==len                                     % 运算符前后没有操作数 报错
%     disp('符号输入错误! 请重新输入!');
%     continue;
% end
% if sign>5 || len-sign>4                                     % 操作数超过四位 报错
%     disp('操作数过大! 请重新输入!');
%     continue;
% end
Ex='000000000';                         % Ex是将不足四位的操作数前补零 凑成九位的扩充字符串 使发送的字符串长度固定
Ex(5)=EnterNumbers(sign);
if sign==2
    Ex(4)=EnterNumbers(1);
elseif sign==3
    Ex(4)=EnterNumbers(2);
    Ex(3)=EnterNumbers(1);
elseif sign==4
    Ex(4)=EnterNumbers(3);
    Ex(3)=EnterNumbers(2);
    Ex(2)=EnterNumbers(1);
elseif sign==5
    for i=1:4
        Ex(i)=EnterNumbers(i);
    end
end
for i=1:len-sign
    Ex(10-i)=EnterNumbers(len+1-i);
end
% if Ex(5)=='/' && Ex(6)=='0' && Ex(7)=='0' && Ex(8)=='0' && Ex(9)=='0'  % 除数为0 报错
%     disp('除数为0! 请重新输入!');
%     continue;
% end
disp(Ex);
%break;
%end
BCD=zeros(1,36);                     % BCD是将9位字符串转成36位（每个字符4位）BCD码的向量
Bak=[1 1 1 0 0 1 0];                 % 加7位巴克码
for i=1:9
j=4*(i-1)+1;
if Ex(i)=='0'
elseif Ex(i)=='1'                % 编码 转为BCD码 0~9分别对应二进制0000~1001 +-*/分别对应二进制1010~1011
    BCD(j+3)=1;
elseif Ex(i)=='2'
    BCD(j+2)=1;
elseif Ex(i)=='3'
    BCD(j+2)=1;
    BCD(j+3)=1;
elseif Ex(i)=='4'
    BCD(j+1)=1;
elseif Ex(i)=='5'
    BCD(j+1)=1;
    BCD(j+3)=1;
elseif Ex(i)=='6'
    BCD(j+1)=1;
    BCD(j+2)=1;
elseif Ex(i)=='7'
    BCD(j+1)=1;
    BCD(j+2)=1;
    BCD(j+3)=1;
elseif Ex(i)=='8'
    BCD(j)=1;
elseif Ex(i)=='9'
    BCD(j)=1;
    BCD(j+3)=1;
elseif Ex(i)=='+'
    BCD(j)=1;
    BCD(j+2)=1;
elseif Ex(i)=='-'
    BCD(j)=1;
    BCD(j+2)=1;
    BCD(j+3)=1;
elseif Ex(i)=='*'
    BCD(j)=1;
    BCD(j+1)=1;
elseif Ex(i)=='/'
    BCD(j)=1;
    BCD(j+1)=1;
    BCD(j+3)=1;
end
end
%disp(BCD);
BCD=hanming(BCD);
BCD=BCD';
BCD = reshape(BCD,1,63);
BCD=[Bak BCD];
BCD=[BCD 1 1];
%disp(BCD);
%2FSK调制
fs=800;   %抽样频率 
dt=1/fs; 
f1=20;     %定义两列载波的频率 
f2=100; 
a=BCD;
g1=a; 
g2=~a; 
g11=(ones(1,800))'*g1;  %产生方波信号 
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
pause(0.3);%0.2
sound(fsk,80000);                           % 以200kHz发送已调波 传信率200kb/s 传码率200k/(100*4)B/s
out=[fsk];
% figure(1);
% plot(out);
pause(1.5);%1.4
 toc;
 t=toc;
pause(2.2-t);%2
tic;
disp('开始接收');
% pause(0.2);
Receive=audiorecorder(80000,8,1);
if(cycle==1)
    recordblocking(Receive,2.3);
else
    recordblocking(Receive,2);
end
Receive = getaudiodata(Receive);
Receive=abs(Receive);                          % 求绝对值方便以后识别1
fsk1=Receive;
subplot(221);
stem(fsk1);
fs=800;   %抽样频率
N=length(Receive)/fs;
dt=1/fs; 
t=0:dt:N-dt; 
b1=fir1(101,[10/800 20/800]); 
b2=fir1(101,[90/800 110/800]);      %设置带宽参数 
H1=filter(b1,1,4*fsk1);       %b1为分子1为分母sn为滤波器输入序列 
H2=filter(b2,1,4*fsk1);       %噪声信号同时通过两个滤波器 
sw1=H1.*H1;                        %相干解调乘以同频同相的载波 
sw2=H2.*H2;%经过相乘器 
bn=fir1(101,[2/800 10/800]);             %经过低通滤波器 
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
    if(bfsk(i)>=0.5)
        bfsk(i)=1;
    else bfsk(i)=0;
    end
end
BCD2=zeros(1,80);
for i=1:length(bfsk)-6
    if bfsk(i)==0
        if bfsk(i+1)==0
            if bfsk(i+2)==0
                if bfsk(i+3)==1
                    if bfsk(i+4)==1
                        if bfsk(i+5)==0
                            if bfsk(i+6)==1
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
    BCD2(k)=1-bfsk(j);
    k=k+1;
end
subplot(223);
stem(bfsk);
subplot(224);
stem(BCD2);

NumberA=0;
NumberB=0;  
BCD2=BCD2(8:70);
BCD2=reshape(BCD2,7,9);
BCD2=BCD2';
BCD2=decode1(BCD2);
BCD2=BCD2';
BCD2=reshape(BCD2,1,36);
BCD2=BCD2(1:32);
Begin=0;
for j=1:8
    i=(j-1)*4+1;
    if BCD2(Begin+i)==0
        if BCD2(Begin+i+1)==0
            if BCD2(Begin+i+2)==0
                if BCD2(Begin+i+3)==0
                    NumberA=NumberA+0;
                elseif BCD2(Begin+i+3)==1
                    NumberA=NumberA+1*10^(8-j);
                end
            elseif BCD2(Begin+i+2)==1
                if BCD2(Begin+i+3)==0
                    NumberA=NumberA+2*10^(8-j);
                elseif BCD2(Begin+i+3)==1
                    NumberA=NumberA+3*10^(8-j);
                end
            end
        elseif BCD2(Begin+i+1)==1
            if BCD2(Begin+i+2)==0
                if BCD2(Begin+i+3)==0
                    NumberA=NumberA+4*10^(8-j);
                elseif BCD2(Begin+i+3)==1
                    NumberA=NumberA+5*10^(8-j);
                end
            elseif BCD2(Begin+i+2)==1
                if BCD2(Begin+i+3)==0
                    NumberA=NumberA+6*10^(8-j);
                elseif BCD2(Begin+i+3)==1
                    NumberA=NumberA+7*10^(8-j);
                end
            end
        end
    elseif BCD2(Begin+i)==1
        if BCD2(Begin+i+1)==0
            if BCD2(Begin+i+2)==0
                if BCD2(Begin+i+3)==0
                    NumberA=NumberA+8*10^(8-j);
                elseif BCD2(Begin+i+3)==1
                    NumberA=NumberA+9*10^(8-j);
                end
            end
        end
    end
end
if no2~=NumberA
    mistake=mistake+1;
end
disp('结果为:');
disp(NumberA);
toc;
t=toc;
pause(2.8-t);
clear pause;
end
disp(['错误率为：',num2str(mistake/10)]);

