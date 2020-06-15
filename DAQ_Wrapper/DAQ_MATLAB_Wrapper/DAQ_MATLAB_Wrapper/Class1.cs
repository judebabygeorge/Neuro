using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Mcs.Usb;
using System.IO;

namespace DAQ_MATLAB_Wrapper
{
    public class DAQ
    {
        public const uint DSP_Channels = 80 ;
        public const uint Raw_Channels = 120; 
        public uint Channels = DSP_Channels + Raw_Channels;
        
        public const uint Checksum = 0;

        int TotalChannels;

        public int Samplerate = 50000;

        public CMcsUsbListNet devices = new CMcsUsbListNet();

        public CMeaUSBDeviceNet Port_1 = new CMeaUSBDeviceNet();
        public CMeaUSBDeviceNet Port_2 = new CMeaUSBDeviceNet();


        CMcsUsbListEntryNet RawPort;
        CMcsUsbListEntryNet DspPort;

        public bool Connected;
        public bool DevicesReady;

        public UInt32 FrameCount;

        public int[] data;
        //public Int16[] data;
        public int frames_read;

        public delegate void DataEventHandler(object sender, EventArgs e);
        
        public event DataEventHandler Port_1_Data_Event;
        public event DataEventHandler DeviceStateChange;

        public bool ConnectToDevice()
        {
            Console.WriteLine("Connecting to Devices");

            SearchDevice();
            if (DevicesReady)
            {
                Port_1.Connect(RawPort);
                Port_2.Connect(DspPort);
                Connected = true;
            }
            return Connected ;

        }
        public bool DisConnect()
        {
            if (Connected)
            {
                Port_1.Disconnect();
                Port_2.Disconnect();
                Connected = false;
            }
            return true;
        }

        public DAQ()
        {

            Console.WriteLine("DAQ DLL Loaded !");
              
            devices.DeviceArrival += new OnDeviceArrivalRemoval(devices_DeviceArrival);
            devices.DeviceRemoval += new OnDeviceArrivalRemoval(devices_DeviceRemoval);

            Port_1.ChannelDataEvent += new OnChannelData(Port_1_ChannelDataEvent);
            Port_2.ChannelDataEvent += new OnChannelData(Port_2_ChannelDataEvent);

            Connected = false;
            DevicesReady = false;

            SearchDevice();            
        }
        void devices_DeviceRemoval(CMcsUsbListEntryNet entry)
        {
            SearchDevice();
        }

        void devices_DeviceArrival(CMcsUsbListEntryNet entry)
        {
            SearchDevice();
        }

        public void SearchDevice()
        {

            devices.Initialize(DeviceEnumNet.MCS_MEAUSB_DEVICE); // Get list of MEA devices connect by USB

            RawPort = null;
            DspPort = null;

            DevicesReady = false;
            if (devices.Count == 2)
            {
                for (uint i = 0; i < devices.Count; i++) // loop through number of devices found
                {
                    if (devices.GetUsbListEntry(i).SerialNumber.EndsWith("A")) // check for each device if serial number ends with "A" (USB 1) This USB interface will be used by MC_Rack
                    {
                        RawPort = devices.GetUsbListEntry(i);                        
                    }
                    if (devices.GetUsbListEntry(i).SerialNumber.EndsWith("B"))// check for each device if serial number ends with "B" (USB 2) This USB interface will be used to control DSP
                    {
                        DspPort = devices.GetUsbListEntry(i);
                       
                    }
                }
                Console.WriteLine("Both ports available");
                DevicesReady = true;
            }

            if (DeviceStateChange != null)
                DeviceStateChange(this, EventArgs.Empty);
        }

        public bool Download_Code(string FirmwareFile)
        {

            if (DevicesReady)
            {
                CMcsUsbFactoryNet factorydev = new CMcsUsbFactoryNet();
                factorydev.LoadUserFirmware(FirmwareFile, DspPort);           // Code for uploading compiled binary
                factorydev.Disconnect();
                Console.WriteLine("Firmware Loaded : " + FirmwareFile);
                return true ;
            }
            else
            {
                return false;
            }

        }

        public bool StartDAQ_Port_1(UInt32 mode)
        {
            int ChannelsInBlock;

            if (Port_1.Connect(RawPort) == 0)
            {

                Connected = true;
                FrameCount = 0;

                Port_1.SetSampleRate(Samplerate);
                
                switch(mode){
                  case 0 : //Read from raw port
                    Port_1.SetNumberOfAnalogChannels(Raw_Channels, 0, 0, 0, 0);
                    Channels = Raw_Channels;
                    break;
                  case 1 :
                    Port_1.SetNumberOfAnalogChannels(0, 0, DSP_Channels, 0, 0);
                    Channels = DSP_Channels ;
                    break;
                  case 2 : //Read from DSP port + Raw
                    Port_1.SetNumberOfAnalogChannels(Raw_Channels, 0, DSP_Channels, 0, 0);
                    Channels = DSP_Channels + Raw_Channels;
                    break;
                }

                if (Checksum == 2)
                    Port_1.EnableChecksum(true);
                else
                    Port_1.EnableChecksum(false);

                Port_1.SetDataMode(DataModeEnumNet.dmSigned32bit, 0);
                //Port_1.SetDataMode(DataModeEnumNet.dmSigned16bit, 0);
                Port_1.GetChannelsInBlock(out ChannelsInBlock);

                Console.WriteLine("ChannelsInBlock " + ChannelsInBlock);

                TotalChannels = (int)((int)Channels + (int)Checksum);
                Port_1.SetSelectedData((int)TotalChannels, Samplerate * 10, Samplerate, CMcsUsbDacqNet.SampleSize.Size32, ChannelsInBlock);
                //Port_1.SetSelectedData((int)TotalChannels, Samplerate * 10, Samplerate, CMcsUsbDacqNet.SampleSize.Size16, ChannelsInBlock);
                Port_1.StartDacq();
                return true;
            }
            else
            {
                return false;
            }
            
        }
        public bool StopDAQ_Port_1()
        {
            Port_1.StopDacq();
            Port_1.Disconnect();
            Connected = false;
            return true;
        }
        public bool WriteRegister(UInt32 Address , UInt32 Data)
        {
            if (DevicesReady)
            {
                CMcsUsbFactoryNet factorydev = new CMcsUsbFactoryNet();
                if (factorydev.Connect(DspPort) == 0)
                {
                    factorydev.Mea21WriteRegister(Address, Data);
                    factorydev.Disconnect();
                    return true;
                }
            }
            return false;

        }

        public UInt32 ReadRegister(UInt32 Address)
        {
            UInt32 Value = 0;
            if (DevicesReady)
            {
                CMcsUsbFactoryNet factorydev = new CMcsUsbFactoryNet();
                if (factorydev.Connect(DspPort) == 0)
                {
                    Value = factorydev.Mea21ReadRegister(Address);
                    factorydev.Disconnect();
                }
            }
            return Value;
        }
        void Port_1_ChannelDataEvent(CMcsUsbDacqNet dacq, int CbHandle, int numFrames)
        {
            FrameCount++;

            Console.WriteLine("data available " + numFrames)   ;
            if (numFrames > Samplerate) numFrames = Samplerate ;
            data = Port_1.ChannelBlock_ReadFramesI32(0, numFrames, out frames_read);
            //data = Port_1.ChannelBlock_ReadFramesI16 (0, numFrames, out frames_read);
            if (Port_1_Data_Event != null)
                Port_1_Data_Event(this, EventArgs.Empty);

        }
        void Port_2_ChannelDataEvent(CMcsUsbDacqNet dacq, int CbHandle, int numFrames)
        {
        }

  }
    
}
