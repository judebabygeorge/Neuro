function file = create_datastream(filename)
%CREATE_DATSTREAM Summary of this function goes here
%   Detailed explanation goes here

file.filename = filename ;
file.fid      = fopen(filename,'r');
file.valid    = 1 ;
file.type     = 256;
%Read Header

if(file.fid == -1)
    file.valid = 0 ;
    display(['Cannot Open ' filename]);
    return  ;
end
h = fread(file.fid,[1 1],'uint32');
if((h<0 )||(h > 4))
    file.valid = 0 ;
    display('Not a valid file')
    return ;
end
file.type = h ;

file.date = fread(file.fid,[1 6],'uint32');
display(['File date : ' num2str(file.date(3),'%02d') '/' num2str(file.date(2),'%02d') '/' num2str(rem(file.date(1),2000),'%02d') ' @ ' num2str(file.date(4),'%02d') ':' num2str(file.date(5),'%02d') ':' num2str(file.date(6),'%02d')]);

switch(file.type)
    case 0
        [Frames valid] = read_mode0(file,(50000*(60+4+2)*4));
        file.Frames =Frames ;
        file.valid = valid ;
    case 1
        file.Frames = fread(file.fid,[1 1],'uint32');
        file.valid = 1 ;
    case 2
        file.Frames = fread(file.fid,[1 1],'uint32');
        file.valid = 1       ;
    case 3
        [Frames valid] = read_mode0(file,(50000*(60+4+2+10)*4));
        file.Frames =Frames ;
        file.valid = valid ;
    case 4
        [Frames valid] = read_mode0(file,(50000*(30+4+2+10)*4));
        file.Frames =Frames ;
        file.valid = valid ;
end

%n = 4*(1+6);
fclose(file.fid);  %go to start of 1st block
file.fid = -1   ;
end

function [Frames valid] = read_mode0(file,block_size)

%Scan File for the number of frames
FrameId = 0 ;

valid = 1;

while(1)
    h = fread(file.fid,[1 1],'uint32');
    
    switch(h)
        case 1  % Data frame
            Fid = fread(file.fid,[1 1],'uint32');
            if(Fid == (FrameId + 1))
                FrameId = Fid ;
                s = fseek(file.fid,block_size,'cof');
                if(s==-1)
                    display('Seek Error !')
                    valid = 0 ;
                    break ;
                end
            else
                valid = 0 ;
                display('Error in file')
                break;
            end
        case 2  % End Marker
            display('File Scanned')
            break ;
        otherwise
            display('Invalid Header')
            valid = 0 ;
            break;
    end
end

Frames = FrameId ;
display(['Total Frames in File : ' num2str(FrameId)]) ; 
end