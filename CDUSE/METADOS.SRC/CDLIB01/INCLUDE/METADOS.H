

#ifndef _METADOS_H
#define _METADOS_H

#ifndef _OSBIND_H
#include <osbind.h>
#endif

#ifndef _MTSTRUCT_H
#include <mtstruct.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif


#ifdef __TURBOC__

#else /* !__TURBOC__ */

#ifdef __LATTICE__

#else /* !__LATTICE__ */

#ifdef __GNUC_INLINE__

#if __GNUC__ > 1
#define trap_14_wwlwl(n, a, b, c, d)					\
__extension__								\
({									\
	register long retvalue __asm__("d0");				\
	short _a = (short)(a);			\
	long  _b = (long) (b);			\
	short  _c = (short) (c);			\
	long  _d = (long) (d);			\
	    								\
	__asm__ volatile						\
	("\
		movl    %5,sp@-; \
		movw    %4,sp@-; \
		movl    %3,sp@-; \
		movw    %2,sp@-; \
		movw    %1,sp@-; \
		trap    #14;	\
		lea	sp@(14),sp "					\
	: "=r"(retvalue)			/* outputs */		\
	: "g"(n), "r"(_a), "r"(_b), "r"(_c), "r"(_d) /* inputs  */	\
	: "d0", "d1", "d2", "a0", "a1", "a2", "memory"			\
	);								\
	retvalue;							\
})

#else

#define trap_14_wwlwl(n, a, b, c, d)					\
({									\
	register long retvalue __asm__("d0");				\
	short _a = (short)(a);			\
	long  _b = (long) (b);			\
	short  _c = (short) (c);			\
	long  _d = (long) (d);			\
	    								\
	__asm__ volatile						\
	("\
		movl    %4,sp@-; \
		movw    %3,sp@-; \
		movl    %2,sp@-; \
		movw    %1,sp@-; \
		movw    %0,sp@- "					\
	:					     /* outputs */	\
	: "g"(n), "r"(_a), "r"(_b), "r"(_c), "r"(_d) /* inputs  */	\
        );								\
  /* no more than 5 operand allowed in asm() -- therefore the split */  \
									\
	__asm__ volatile						\
	("\
		trap    #14;	\
		lea	sp@(14),sp "					\
	: "=r"(retvalue)			/* outputs */		\
	:					/* inputs  */		\
	: "d0", "d1", "d2", "a0", "a1", "a2"    /* clobbered regs */	\
	);								\
	retvalue;							\
})

#endif

#else /* __GNUC_INLINE__ */

# ifdef _TRAP_X_

__EXTERN long trap_14_wwlwl __PROTO((short n, short a, long b, short c, long d));

# else /* __TRAP_X__ */

#define trap_14_wwlwl	xbios

# endif /* _TRAP_X_ */

#endif /* __GNUC_INLINE__ */

#define	       Metainit(info1)					       \
       (void)trap_14_wl((short)(0x30),(long)(info1))

#define	       Metaopen(drive,buffer)				     \
       (long)trap_14_wwl((short)(0x31),(short)(drive),(long)(buffer))

#define	       Metaclose(drive)					       \
       (long)trap_14_ww((short)(0x32),(short)(drive))

#define	       Metaioctl(drive,magic,opcode,buffer)		       \
       (long)trap_14_wwlwl((short)(0x37),(short)(drive),(long)(magic),(short)(opcode),(long)(buffer))

#endif /* __LATTICE__ */

#endif /* __TURBOC__ */

#ifdef __cplusplus
}
#endif

#endif /* _METADOS_H */

