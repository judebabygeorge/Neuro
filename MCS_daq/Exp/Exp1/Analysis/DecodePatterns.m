function [Class Match] =  DecodePatterns(Features,Patterns,mode)
 
  a = size(Patterns) ;
  Patterns = reshape(Patterns,[a(1) a(2)*a(3)]);
  
 
  nPatternsIn  = size(Patterns,2) ;
  nClasses     = Features.Classes ;
  
  Match        =  zeros(nClasses,nPatternsIn);
  
  tau_D = (-1/(5e-3*50000));
  
      Ps = zeros(size(Patterns));
      Ps(~isnan(Patterns)) = 1  ;      
    
      
  for i=1:nPatternsIn   
          C = zeros(size(Features.FeatureSet(:,:,1)));
      switch(mode)
          case 'distance'
              P = Ps(:,i);
              C = bsxfun(@minus,Features.FeatureSet(:,:,1),P);
              C = C.^2;
          case 'distance_delay'
              P = Patterns(:,i) ;
              C = bsxfun(@minus,Features.FeatureSet(:,:,2),P);%Delay
              C(isnan(C)) = 0;
              C = C.^2       ;
          case 'weight'
              P = Ps(:,i);
              C = bsxfun(@times,Features.FeatureSet(:,:,1),P);
          case 'weight_delay_add'
              P = Patterns(:,i) ;
              D = bsxfun(@minus,Features.FeatureSet(:,:,2),P);%Delay
              D = abs(D) ; %Closeness to the actual patterm
              C = exp(D.*tau_D); %Possile Charge Injection at Synapse
              
              P = Ps(:,i);
              C1 = bsxfun(@times,Features.FeatureSet(:,:,1),P);
              
              C = C1.*(1+C);%Actual: Multipled y synaptic weight        
          case 'weight_delay_mul'
              P = Patterns(:,i) ;
              D = bsxfun(@minus,Features.FeatureSet(:,:,2),P);%Delay
              D = abs(D) ;       %Closeness to the actual patterm
              C = exp(D.*tau_D); %Possile Charge Injection at Synapse
              
              P = Ps(:,i);
              C1 = bsxfun(@times,Features.FeatureSet(:,:,1),P);              
              C = C1.*C;         %Actual: Multipled y synaptic weight 
          case 'weight_inh'
              P = Ps(:,i);
              W = Features.FeatureSet(:,:,1); 
              P(P==0) = -1*0.7 ;              
              C  = bsxfun(@times,W,P);
          case 'weight_del_inh'
              P = Ps(:,i);
              W = Features.FeatureSet(:,:,1); 
              P(P==0) = -1*0.7 ;              
              C  = bsxfun(@times,W,P);
              
              P  = Ps(:,i);
              D  = Features.FeatureSet(:,:,2);
              V  = double(isnan(D))         ;
              V(P==0,:) = V(P==0,:) + 1     ;
              
              Diff = abs(bsxfun(@minus,D,Patterns(:,i)));
              C1 = exp(Diff.*tau_D);
              C1(V~=0) = 0;
              
              C = C + C1.*W ; 
              
          otherwise
              error('Decoder:Mode','Unknown Classification Method');
      end
      Match(:,i) = sum(C)';
  end
  
  [~,Class]    = max(Match);
  
  
  Match        = reshape(Match,[nClasses a(2) a(3)]);
  Class        = reshape(Class,[a(2) a(3) 1]);
  Class        = Class';
end