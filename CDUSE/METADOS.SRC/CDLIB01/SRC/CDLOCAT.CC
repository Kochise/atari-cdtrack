
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



#include <cdlocat.h>

CdLocation::CdLocation( void )
{
}

CdLocation::CdLocation( cd_ad d, BYTE t )
	: data( d ), montype( t )
{
}

CdLocation::CdLocation( BYTE m, BYTE s, BYTE f )
	: montype( CDROM_MSF )
{
	data.msf.reserved = 0;
	data.msf.minute = m;
	data.msf.second = s;
	data.msf.frame = f;
}

CdLocation::CdLocation( long lba )
	: montype( CDROM_LBA )
{
	data.lba = lba;
}

void CdLocation::set( cd_ad d, BYTE t )
{
	data = d;
	montype = t;
}

void CdLocation::set( BYTE m, BYTE s, BYTE f )
{
	montype = CDROM_MSF;
	data.msf.reserved = 0;
	data.msf.minute = m;
	data.msf.second = s;
	data.msf.frame = f;
}

void CdLocation::set( long lba )
{
	montype = CDROM_LBA;
	data.lba = lba;
}

BYTE CdLocation::type( void )
{
	return montype;
}

BYTE CdLocation::minute( void )
{
	return data.msf.minute;
}

BYTE CdLocation::second( void )
{
	return data.msf.second;
}

BYTE CdLocation::frame( void )
{
	return data.msf.frame;
}

long CdLocation::lba( void )	// logical block address
{
	return data.lba;
}


long CdLocation::total_frames( void )
{
	return minute()*255*60 + second()*255 + frame();
}


void CdLocation::set_total_frames( long f )
{
	long s = f / 255;

	set( s / 60, s % 60, f % 255 );
}


String CdLocation::operator~( void )
{
	char buffer[1000];

	switch( type() )
	{
		case CDROM_MSF:
		{
			sprintf( buffer, "%2d min.  %2d sec.  %3d frm.", minute(), second(), frame() );
			break;
		}
		case CDROM_LBA:
		{
			sprintf( buffer, "%d", lba() );
			break;
		}
	}

	String mystring( buffer );
	return mystring;
}


CdLocation operator-( CdLocation &cdl1, CdLocation &cdl2 )
{
	CdLocation cdl;

	cdl.set_total_frames( cdl1.total_frames() - cdl2.total_frames() );

	return cdl;
}

