path = 'C:\Users\45c\Documents\MATLAB\MCS_daq\Exp\Exp2\Data\G28122015A\';
DIV  = [31];

if(0) %Check

display('Classification');

a = load(sprintf('%s//DIV%d//data_PatternCheck_2_250_two_time_seq4_1.mat',path,DIV(1)));
PatternData = a.PatternData;
[Patterns , PatternConfig ]= EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns)) = 0;

SelectedPatterns = 1:1:112;

C = ones(121,numel(SelectedPatterns));

[emin, Wm] = CheckClassifiability(PatternData,SelectedPatterns,C);
end

if(0)
display('Pattern Match');

a = load(sprintf('%s//DIV%d//data_PatternCheck_2_250_PatternMatch_1.mat',path,DIV(1)));
PatternData = a.PatternData;
[Patterns , PatternConfig ]= EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns)) = 0;


remove = [ 0 8 9] ;
%remove = [remove 1 2 4 5 6];
remove = remove + 1;

SelectedPatterns = 1:2:20;

SelectedPatterns(remove)=[];

C = ones(121,numel(SelectedPatterns));

[emin, Wm] = CheckClassifiability(PatternData,SelectedPatterns,C);


SelectedPatterns = 2:2:20;
SelectedPatterns(remove)=[];

W=Wm;
%W(:,remove)=[];

Y = P(:,SelectedPatterns,:);
x  = ones([size(Y,1)+1 size(Y,2)*size(Y,3)]);
x(1:size(Y,1),:,:)  = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);
O = W'*x ;

err =zeros(size(O,2),1);
for k=1:size(O,2)
    [~,I]=max(O(:,k));
    err(k)=I;
end

err = reshape(err,[size(Y,2) size(Y,3)]);
e=zeros(size(err,1),1);
for i=1:size(err,1)
    e(i)=sum((err(i,:) ~= i));
end

e=e/size(err,2);
sprintf('Sequence Match : %d/%d',sum(e<0.2),size(err,1))
e

end

if(1)

display('Word Sequence');

a = load(sprintf('%s//DIV%d//data_PatternCheck_2_250_WordSequence_1.mat',path,DIV(1)));
PatternData = a.PatternData;
[Patterns , PatternConfig ]= EditPatterns(PatternData);
P = ones(size(Patterns));
P(isnan(Patterns)) = 0;


SelectedWords = [1 2 3];

SelectedPatterns = 1:2:6;
SelectedPatterns = SelectedPatterns(SelectedWords);

C = ones(121,numel(SelectedPatterns));

[emin, Wm] = CheckClassifiability(PatternData,SelectedPatterns,C);


SelectedPatterns = 1:1:6;


remove = 1:2:6;
SelectedPatterns(remove)=[];
SelectedPatterns = SelectedPatterns(SelectedWords);
W = Wm;



Y = P(:,SelectedPatterns,:);
x  = ones([size(Y,1)+1 size(Y,2)*size(Y,3)]);
x(1:size(Y,1),:,:)  = reshape(Y,[size(Y,1) size(Y,2)*size(Y,3)]);
O = W'*x ;

err =zeros(size(O,2),1);
for k=1:size(O,2)
    [~,I]=max(O(:,k));
    err(k)=I;
end

err = reshape(err,[size(Y,2) size(Y,3)]);
e=zeros(size(err,1),1);
% for i=1:size(err,1)
%     e(i)=sum((err(i,:) ~= i));
% end
for i=1:numel(SelectedWords)
    for j=1:1
        e((i-1)*1+j)=sum((err((i-1)*1+j,:) ~= i));
    end
end
e=e/size(err,2);
sprintf('Word Compare : %d/%d',sum(e<0.2),size(err,1))
end
