
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


#include <stdlib.h>
#include <xstring.h>
#
#include <osbind.h>
#include <ostream.h>
#include <cdstatus.h>
#include <cddrive.h>

#define LINESIZE 80
#define NBARGMAX 20

char saisie[LINESIZE+1];
String words[NBARGMAX];
int nbarg;

void anykey( void )
{
	cout << "Press anykey..." << endl;
	Bconin( 2 );
	cout << endl;
}

inline int commande( char *v, int n )
{
	return ( ( fcompare( words[0], v ) == 0 ) && ( nbarg == n ) );
}

inline int argument( int n )
{
	return atoi( words[n] );
}

void about( void )
{
	cout << "CD audio control software 0.1 - Olivier AZEAU - January 1996" << endl;
}

void error( void )
{
	cout << "CD access error" << endl;
}

int main( void )
{
	CdDrive cd;
	int continuer = 1;

	cout << endl;
	about();

	if( !cd.detected() )
	{
		// si on n'a pas de driver, pas la peine de continuer...
		cout << endl << "Fatal error : no CD driver found !" << endl << endl;
		anykey();
		exit(1);
	}

	while( continuer )
	{
		cout << endl << ">> " << flush;
		cin.getline( saisie, LINESIZE, '\n' );
		cout << endl;

		String s( saisie );
		nbarg = split( s, words, NBARGMAX, RXwhite ) - 1;

		CdStatus status( cd );

		if( nbarg == -1 )
		{
			// si on n'ecrit rien, on ne fait rien...
		}
		else if( commande( "quit", 0 ) )
		{
			continuer = 0;
		}
		else if( commande( "exit", 0 ) )
		{
			continuer = 0;
		}
		else if( commande( "about", 0 ) )
		{
			about();
		}
		else if( commande( "help", 0 ) )
		{
			cout << "Commands available :" << endl;
			cout << "quit, exit, about, help, infos, status, list, stop" << endl;
			cout << "track <number>, play <number> [<number>], pause, resume" << endl;
		}
		else if( commande( "infos", 0 ) )
		{
			cout << "CD Rom Software : " << cd.software << endl;
			cout << "Drive : " << (char)cd.drive << endl;
			cout << "Driver on drive " << (char)cd.drive << " : " << cd.driver << endl;

			CdStatus status( cd );

			if( !status.error() )
			{
				cout << "First track : " << cd.start_track() << endl;
				cout << "Last track : " << cd.end_track() << endl;
				cout << "Total length : " << ~cd.leadout() << endl;
			}
			else
				error();
		}
		else if( commande( "list", 0 ) )
		{
			CdStatus status( cd );

			if( !status.error() )
			{
				int nmax = cd.end_track();
				for( int n = cd.start_track(); n <= nmax; n++ )
				{
					if( n <= 9 )
						cout << "Track  ";
					else
						cout << "Track ";
					cout << n << "\t" << ~cd.track_length( n ) << endl;
				}
				cout << "Total\t\t" << ~cd.leadout() << endl;
			}
			else
				error();
		}
		else if( commande( "track", 1 ) )
		{
			CdStatus status( cd );
			int n = argument( 1 );

			if( !status.error() )
			{
				cout << "Track " << n << " position : " << ~cd.track_position( n ) << endl;
				cout << "Track " << n << " length   : " << ~cd.track_length( n ) << endl;
			}
			else
				error();
		}
		else if( commande( "status", 0 ) )
		{
			CdStatus status( cd );

			if( !status.error() )
			{
				cout << status << endl;
				cout << "Current position : " << cd.current_location() << endl;
				cout << "Absolute current position : " << ~cd.current_absolute_location() << endl;
			}
			else
				error();
		}
		else if( commande( "eject", 0 ) )
		{
			if( cd.eject() )
				cout << "CD ejected" << endl;
			else
				error();
		}
		else if( commande( "play", 1 ) )
		{
			int	n = argument( 1 );
			if( cd.play( n, 1, n, 1 ) )
				cout << "Playing track " << n << "..." << endl;
			else
				error();
		}
		else if( commande( "play", 2 ) )
		{
			int	n1 = argument( 1 ),
				n2 = argument( 2 );
			if( cd.play( n1, 1, n2, 1 ) )
				cout << "Playing tracks " << n1 << " to " << n2 << "..." << endl;
			else
				error();
		}
		else if( commande( "pause", 0 ) )
		{
			if( cd.pause() )
				cout << "CD paused" << endl;
			else
				error();
		}
		else if( commande( "resume", 0 ) )
		{
			if( cd.resume() )
				cout << "CD resumed" << endl;
			else
				error();
		}
		else if( commande( "stop", 0 ) )
		{
			if( cd.stop() )
				cout << "CD stopped" << endl;
			else
				error();
		}
		else
		{
			cout << "Unknown command" << endl;
		}

	}

	cout << "Bye..." << endl;

	exit(0);
}
