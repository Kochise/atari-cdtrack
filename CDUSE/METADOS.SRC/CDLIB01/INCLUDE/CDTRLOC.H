
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



#ifndef __CDTRLOC_H__
#define __CDTRLOC_H__


#include <cdromio.h>
#include <cdlocat.h>


class CdTrackLocation
{
	friend ostream& operator<<( ostream& s, CdTrackLocation& cdtl );

public:
	BYTE track_id;
	BYTE index;
	CdLocation location;

	CdTrackLocation( void ) {}
	
};


#endif 
