function Config = Stim_GenerateElectrodeConfig(Electrode_DAC)

  Config = uint32(zeros(8,1)) ;
  Enable = uint32(zeros(4,1)) ;
  
  for i=1:8
      E = Electrode_DAC((1+15*(i-1)):(15*i));
      for j=1:15
          if(E(j) ~=0)
              Config(i) = Config(i) + ((E(j))*(2^(2*(j-1))));
          end
      end
  end
  for i=1:4
      E = Electrode_DAC((1+30*(i-1)):(30*i));
      for j=1:30
          if(E(j)~=0)
              Enable(i) = Enable(i) + 2^(j-1);
          end
      end
  end
  Config = [Enable;Config];
end

