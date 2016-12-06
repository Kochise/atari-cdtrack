
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


#include <cdtrloc.h>

ostream& operator<<( ostream& s, CdTrackLocation& cdtl )
{
	s << "Track: " << long( cdtl.track_id );
	s << "   Index: " << long( cdtl.index );
	s << "   Location: " << ~cdtl.location;

	return s;
}
