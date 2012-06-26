/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2011
 * http://flintparticles.org/
 * 
 * Licence Agreement
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package org.flintparticles.threeD.geom 
{
	import flash.geom.Vector3D;		

	/**
	 * Utility methods for working with the Vector3D class.
	 */
	public class Vector3DUtils 
	{
		public static function cloneVector( v:Vector3D ):Vector3D
		{
			return new Vector3D( v.x, v.y, v.z, 0 );
		}
		
		public static function clonePoint( v:Vector3D ):Vector3D
		{
			return new Vector3D( v.x, v.y, v.z, 1 );
		}

		public static function cloneUnit( v:Vector3D ):Vector3D
		{
			var temp:Vector3D = new Vector3D( v.x, v.y, v.z, 0 );
			temp.normalize();
			return temp;
		}

		public static function distanceSquared( v:Vector3D, u:Vector3D ):Number
		{
			var dx:Number = v.x - u.x;
			var dy:Number = v.y - u.y;
			var dz:Number = v.z - u.z;
			return Math.sqrt( dx * dx + dy * dy + dz * dz );
		}
		
		public static function getPerpendiculars( normal:Vector3D ):Array
		{
			var p1:Vector3D = getPerpendicular( normal );
			var p2:Vector3D = normal.crossProduct( p1 );
			p2.normalize();
			return [ p1, p2 ];
		}
		
		public static function getPerpendicular( v:Vector3D ):Vector3D
		{
			if( v.x == 0 )
			{
				return new Vector3D( 1, 0, 0 );
			}
			else
			{
				var temp:Vector3D = new Vector3D( v.y, -v.x, 0 );
				temp.normalize();
				return temp;
			}
		}
	}
}
