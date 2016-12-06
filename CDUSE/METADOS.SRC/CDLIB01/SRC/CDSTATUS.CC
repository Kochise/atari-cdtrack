
/* Copyright (C) 1996 Olivier Azeau, France.
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation.

   This program is distributed WITHOUT ANY WARRANTY, without even the
   implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
   See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  */



#include <cdstatus.h>
#include <cddrive.h>


CdStatus::CdStatus( CdDrive &cd )
{
	update( cd );
}


void CdStatus::update( CdDrive &cd )
{
	val = cd.audiostatus_value();
}


int CdStatus::operator==( CdStatus& cds )
{
	return ( val == cds.val );
}


char *CdStatus::message( void )
{
	switch( val )
	{
		case -1:
			return "CD access error";
		case CDROM_AUDIO_INVALID:
			return "audio status not supported";
		case CDROM_AUDIO_PLAY:
			return "audio play operation in progress";
		case CDROM_AUDIO_PAUSED:
			return "audio play operation paused";
		case CDROM_AUDIO_COMPLETED:
			return "audio play successfully completed";
		case CDROM_AUDIO_ERROR:
			return "audio play stopped due to error";
		case CDROM_AUDIO_NO_STATUS:
			return "no current audio status to return";
		default:
			return "unknown status";
	}
}


int CdStatus::error( void )
{
	switch( val )
	{
		case -1:
			return 1;
		case CDROM_AUDIO_INVALID:
			return 0;
		case CDROM_AUDIO_PLAY:
			return 0;
		case CDROM_AUDIO_PAUSED:
			return 0;
		case CDROM_AUDIO_COMPLETED:
			return 0;
		case CDROM_AUDIO_ERROR:
			return 1;
		case CDROM_AUDIO_NO_STATUS:
			return 0;
		default:
			return 0;
	}
}


ostream& operator<<( ostream& s, CdStatus &cds )
{
	s << cds.message();

	return s;
}



