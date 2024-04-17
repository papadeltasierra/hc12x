/*!
 * File:
 *  radio_comm.h
 *
 * Description:
 *  This file contains the RADIO communication layer.
 *
 * Silicon Laboratories Confidential
 * Copyright 2011 Silicon Laboratories, Inc.
 */
#ifndef _RADIO_COMM_H_
#define _RADIO_COMM_H_


                /* ======================================= *
                 *              I N C L U D E              *
                 * ======================================= */


                /* ======================================= *
                 *          D E F I N I T I O N S          *
                 * ======================================= */

//#define RADIO_CTS_TIMEOUT 255
#define RADIO_CTS_TIMEOUT 10000

                /* ======================================= *
                 *     G L O B A L   V A R I A B L E S     *
                 * ======================================= */

#if defined(STM8S003) || defined(STM8S105)
extern uint8_t radioCmd[16u];
#else
extern SEGMENT_VARIABLE(radioCmd[16u], uint8_t, SEG_XDATA);
#endif


                /* ======================================= *
                 *  F U N C T I O N   P R O T O T Y P E S  *
                 * ======================================= */

uint8_t radio_comm_GetResp(uint8_t byteCount, uint8_t* pData);
void radio_comm_SendCmd(uint8_t byteCount, uint8_t* pData);
void radio_comm_ReadData(uint8_t cmd, BitStatus pollCts, uint8_t byteCount, uint8_t* pData);
void radio_comm_WriteData(uint8_t cmd, BitStatus pollCts, uint8_t byteCount, uint8_t* pData);

uint8_t radio_comm_PollCTS(void);
uint8_t radio_comm_SendCmdGetResp(uint8_t cmdByteCount, uint8_t* pCmdData, \
                             uint8_t respByteCount, uint8_t* pRespData);
void radio_comm_ClearCTS(void);

#endif //_RADIO_COMM_H_
