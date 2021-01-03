function E = GetElectrodeNumber(ElectrodeName,ChannelMapping)
  E = 0;  
      for j=1:120
          if(strcmp(ElectrodeName,ChannelMapping.Map(j).label))
              E = j ;
              break;
          end
      end  
end