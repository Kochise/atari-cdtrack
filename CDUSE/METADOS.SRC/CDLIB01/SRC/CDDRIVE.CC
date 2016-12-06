
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


#include <stdio.h>
#include <cdromio.h>
#include <cdlocat.h>
#include <cdtrloc.h>
#include <cddrive.h>

/////////////////////////////////////////////////////////////////

CdDrive::CdDrive( void ) : mode( CDROM_MSF )
{
	Metainit( &(information.info1) );

	if( !information.info1.mi_drivemap || !information.info1.mi_version_string )
	{
		drive_detected = 0;
		return;
	}

	drive_detected = 1;
	BYTE mydrive = 'A';
	unsigned long map = information.info1.mi_drivemap;
	if( map )
	{
		// recherche du premier disque identifiant driver CD physique
		while( !( map & 1 ) )
		{
			mydrive++;
			map >>= 1;
		}
	}
	drive = mydrive;

	// nom du driver bas niveau
	software = information.info1.mi_version_string;

	Metaopen( drive, &(information.drvinfo) );
	driver = information.drvinfo.mdr_name;
}

/////////////////////////////////////////////////////////////////

int CdDrive::start_track( void )
{
	struct cdrom_tochdr tochdr;

	ioctl( CDROMREADTOCHDR, &tochdr );
	return tochdr.cdth_trk0;
}

int CdDrive::end_track( void )
{
	struct cdrom_tochdr tochdr;

	ioctl( CDROMREADTOCHDR, &tochdr );
	return tochdr.cdth_trk1;
}

/////////////////////////////////////////////////////////////////

int CdDrive::start( void )
{
	return !ioctl( CDROMSTART, 0 );
}

int CdDrive::stop( void )
{
	return !ioctl( CDROMSTOP, 0 );
}

int CdDrive::pause( void )
{
	return !ioctl( CDROMPAUSE, 0 );
}

int CdDrive::resume( void )
{
	return !ioctl( CDROMRESUME, 0 );
}

int CdDrive::allow_removal( void )
{
	return !ioctl( CDROMALLOWREMOVAL, 0 );
}

int CdDrive::prevent_removal( void )
{
	return !ioctl( CDROMPREVENTREMOVAL, 0 );
}

/////////////////////////////////////////////////////////////////

int CdDrive::eject( void )
{
	long l = 1;
	
	allow_removal();
    // on attend l'ejection....
	while( l )
	{
		l = ioctl( CDROMEJECT, 0 );
	}
	return 1;
}

int CdDrive::play( BYTE start_track_id, BYTE start_index, BYTE end_track_id, BYTE end_index )
{
	struct cdrom_ti ti;
	
	ti.cdti_trk0 = start_track_id;
	ti.cdti_ind0 = start_index;
	ti.cdti_trk1 = end_track_id;
	ti.cdti_ind1 = end_index;
	
	return !ioctl( CDROMPLAYTRKIND, &ti );
}

/////////////////////////////////////////////////////////////////

CdLocation CdDrive::track_position( BYTE t )
{
	struct cdrom_tocentry tocentry;

	tocentry.cdte_track = t;
	tocentry.cdte_format = mode;
	ioctl( CDROMREADTOCENTRY, &tocentry );
	CdLocation cdloc( tocentry.cdte_addr, mode );
	return cdloc;
}

CdLocation CdDrive::track_length( BYTE t )
{
	if( t == end_track() )
		return leadout() - track_position( t );
	else
		return track_position( t+1 ) - track_position( t );
}

CdLocation	CdDrive::leadout( void )
{
	return track_position( CDROM_LEADOUT );
}

/////////////////////////////////////////////////////////////////

CdTrackLocation	CdDrive::current_location( BYTE m )
{
	struct cdrom_subchnl subchnl;

	if( m == 0 )
		m = mode;

	subchnl.cdsc_format = m;
	ioctl( CDROMSUBCHNL, &subchnl );

	CdTrackLocation	cdtl;
	cdtl.track_id = subchnl.cdsc_trk;
	cdtl.index = subchnl.cdsc_ind;

	CdLocation cdl( subchnl.cdsc_reladdr, m );
	cdtl.location = cdl;

	return cdtl;
}

CdLocation CdDrive::current_absolute_location( BYTE m )
{
	struct cdrom_subchnl subchnl;

	if( m == 0 )
		m = mode;

	subchnl.cdsc_format = m;
	ioctl( CDROMSUBCHNL, &subchnl );

	CdLocation cdl( subchnl.cdsc_absaddr, m );

	return cdl;
}

int CdDrive::audiostatus_value( void )
{
	struct cdrom_subchnl subchnl;

	subchnl.cdsc_format = mode;
	if( ioctl( CDROMSUBCHNL, &subchnl ) )
		return -1;
	else
		return subchnl.cdsc_audiostatus;
}

CdStatus CdDrive::audiostatus( void )
{
	CdStatus cds( *this );

	return cds;
}


