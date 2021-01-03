#ifndef SEND_DATA_H
#define SEND_DATA_H

#include "global.h"
#include "typedef.h"

#define SEND_BUFFER_SIZE 64

#define SEND_STORE_BUFFER_SIZE SEND_BUFFER_SIZE*32

struct SendDataStore {
  Uint32 Count ;
  Uint32 Missed;
  Uint32 write_idx ;
  Uint32 read_idx  ;
  Uint32 DATA_ARRAY[SEND_STORE_BUFFER_SIZE];
};

typedef struct SendDataStore SendDataStore ;

void init_SendDataDMA(Uint32 EventId);
Uint32 SendDataBuffer (Uint32 Header,void *ptr , Uint32 nBytes);
void SendDataDMA();
Uint32 CopyDataToSendBuffer(Uint32 Count , Uint32 Header , void * ptr);
Uint32 SendData_StoreToBuffer(Uint32 Count , Uint32 Header , void *ptr );
Uint32 SendData_CopyDataFromStoreBuffer();
Uint32 SendData_GetAvailableSpace();
#endif
