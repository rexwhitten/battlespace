/'************************************************************************
 *                                                                       *
 * Open Dynamics Engine, Copyright (C) 2001-2003 Russell L. Smith.       *
 * All rights reserved.  Email: russ@q12.org   Web: www.q12.org          *
 *                                                                       *
 * Ported to FreeBASIC by D.J.Peters (Joshy)                             *
 *                                                                       *
 * This library is free software; you can redistribute it and/or         *
 * modify it under the terms of EITHER:                                  *
 *   (1) The GNU Lesser General Public License as published by the Free  *
 *       Software Foundation; either version 2.1 of the License, or (at  *
 *       your option) any later version. The text of the GNU Lesser      *
 *       General Public License is included with this library in the     *
 *       file LICENSE.TXT.                                               *
 *   (2) The BSD-style license that is included with this library in     *
 *       the file LICENSE-BSD.TXT.                                       *
 *                                                                       *
 * This library is distributed in the hope that it will be useful,       *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the files    *
 * LICENSE.TXT and LICENSE-BSD.TXT for more details.                     *
 *                                                                       *
 ************************************************************************'/
#ifndef __ode_ode_bi__
#define __ode_ode_bi__



#include "ode/config.bi"
#include "ode/compatibility.bi"
#include "ode/common.bi"
#include "ode/contact.bi"
#include "ode/error.bi"
#include "ode/memory.bi"
#include "ode/odemath.bi"
#include "ode/matrix.bi"
#include "ode/timer.bi"
#include "ode/rotation.bi"
#include "ode/mass.bi"
#include "ode/misc.bi"
#include "ode/objects.bi"
#include "ode/collision_space.bi"
#include "ode/collision.bi"
#include "ode/export-dif.bi"
#include "ode/odeinit.bi"

#ifdef dSINGLE
#  inclib "libode-1"
#else
#error requied ode compiled with dReal = single
#endif



#endif ' __ode_ode_bi__
