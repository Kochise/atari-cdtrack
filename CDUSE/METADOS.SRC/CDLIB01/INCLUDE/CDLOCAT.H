
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



#ifndef __CDLOCAT_H__
#define __CDLOCAT_H__


#include <xstring.h>
#include <stream.h>
#include <cdromio.h>


// Classe representant une position sur un CD
class CdLocation
{
	BYTE montype;	// CDROM_MSF ou CDROM_LBA
	cd_ad data;

protected:
	long total_frames( void );
	void set_total_frames( long f );

public:
	friend CdLocation operator-( CdLocation &cdl1, CdLocation &cdl2 );

	CdLocation( void );
	CdLocation( cd_ad d, BYTE t );
	CdLocation( BYTE m, BYTE s, BYTE f );
	CdLocation( long lba );

	void set( cd_ad d, BYTE t );
	void set( BYTE m, BYTE s, BYTE f );
	void set( long lba );

	BYTE type( void );
	BYTE minute( void );
	BYTE second( void );
	BYTE frame( void );
	long lba( void );	// logical block address

	String operator~( void ); // affichage avec format
	
};




#endif 
