%% Power law and Neuronal Avalanche size

%%
M = zeros(13); % Electrode Grid HAS TO BE ODD
x= linspace(-3,3,13);

G = exp(-((meshgrid(x).^2+meshgrid(x).^2')/0.16));% Gaussian

G(7,7)=0; 
Des= sum(sum(G)) % lin(-3,3,13); sigma = 0.16 ~ 1 
imagesc(G);
W = zeros(13,13,[13*13]);
%%
i = 1;
for c =1:length(M);
    for r=1:length(M);
        M = zeros(13);
        
        M(c,r)=1;
        i=find(M);
        W(:,:,i) =conv2(M,G,'same');
        
       % while sum(sum(W(:,:,i))) < 1;
        %    W(:,:,i)=W(:,:,i).*(8/3);
        % end
    end
end



%% Initial conditions; 
avalanche = 1;
M = zeros(13);
D = zeros(300000,1);
pic = imagesc(M);colormap('gray');% plot
pause(0.4);
for i =1:300;
    
    v=find(M);
    M = sum(W(:,:,v),3) > rand(13,13);%
    M(v) =0;
   D(avalanche) = D(avalanche) + length(find(M)); % Avalanche Size
   
    if isempty(find(M))
        M(randi(13),randi(13))=1; % seed
        avalanche  = avalanche+1;
        D(avalanche)=1;
    end
   set(pic, 'CData',M); title(i)
   pause(0.2);
   drawnow;
end


%% Fast line
DI = D(1:avalanche);
size =log(unique(DI))
count = histcounts(DI,length(size));
loglog(count',unique(DI),'ro'); ylabel('Avalanche Frequency (LOG)');
xlabel('Avalanche Size (LOG)');

%% Mutilplot - additional plot of the each weight matrix
for i=1:169
    subplot(10,17,i);
    imagesc(W(:,:,i));
end
