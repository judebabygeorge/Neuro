function play_patterns( Patterns , p )
%PLAY_PATTERN Summary of this function goes here
%   Detailed explanation goes here

h = PatternView ;
hO  = guidata(h);  



PFiring = ones(size(Patterns));
PFiring(isnan(Patterns)) = 0;
P = mean(PFiring,3) ;             
Probability  = 0.8 ;
P(P<Probability) = 0 ;
P = sum(P) ;            
[~,E] = sort(P,'descend');
             
%E = 1:1:size(Patterns,2);

t_stop = 50 ;

% %Run Iterations of all
% len  = min(32,size(Patterns,2)) ;
% count = min(p,size(Patterns,1));
% for i=1:count
%     for t=1:t_stop
%         for j=1:len
%             P = Patterns(:,E(j),i);
%             Vis = zeros(size(P));
%             Vis((P>((t-1)*50)) & (P<=(t*50)))=1;
%             
%             Act  = ones(size(Vis))*0;   
%             Mark = zeros(size(Act));
%             Mark(E(j)) = 1;
%             hO.ShowElectrodeActivity(hO,j,[Act Vis], Mark);
%         end
%         pause(0.1)
%     end    
% end

%Run a samples of a particular pattern

count = min(32,size(Patterns,3));
for t=1:t_stop
    for i=1:count
            P = Patterns(:,E(p),i);
            Vis = zeros(size(P));
            %Vis((P>((t-1)*50)) & (P<=(t*50)))=1;
            Vis((P<=(t*50)))=1;
            
            Act  = ones(size(Vis))*0;   
            Mark = zeros(size(Act));
            Mark(E(p)) = 1;
            hO.ShowElectrodeActivity(hO,i,[Act Vis], Mark);
    end
    pause(0.1)
end

end