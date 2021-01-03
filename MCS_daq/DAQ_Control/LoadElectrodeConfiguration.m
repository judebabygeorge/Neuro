
function LoadElectrodeConfiguration(SYS,ConfigId,EConfig)
 Array  = uint32(zeros(13,1));
 Array(1)  = ConfigId ;
 Array(2:end) = Stim_GenerateElectrodeConfig(EConfig);
 SendCommand(SYS,5,Array) ;
end
