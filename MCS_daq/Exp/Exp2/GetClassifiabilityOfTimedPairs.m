function O = GetClassifiabilityOfTimedPairs(PatternData)

    Patterns = PatternData.Pattern ;            
    %Blank Stimulated Electrodes,these spikes would not be counted
    %The Corresponding weights would not adapt and will be 0 hence
    %takes care although this blanking is not done in dsp
    E = PatternData.StimConfig.Electrodes(1,1:8) ;
    E = reshape(E,[1 numel(E)]);
    E = E(E~=0);
    Patterns(E,:,:)=nan;
    DecodeCheckWindow = 100;
    Patterns(Patterns<5*50) = nan;
    Patterns(Patterns>DecodeCheckWindow*50) = nan;
    
    Patterns = Patterns(:,1:112,:);
    
    O = zeros(28,1);
    for i=1:28
        [PatternId W e] = get_best_patterns(Patterns(:,(i-1)*4+1:i*4,:));
        O(i) = max(e);
    end
end