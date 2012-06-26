/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2011
 * http://flintparticles.org
 * 
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

package org.flintparticles.threeD.renderers 
{
	import org.flintparticles.threeD.geom.Matrix3DUtils;
	import org.flintparticles.threeD.geom.Vector3DUtils;
	import org.flintparticles.threeD.renderers.controllers.CameraController;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/**
	 * The camera class is used by Flint's internal 3D renderers to manage the view on the 3D
	 * world that is displayed by the renderer. Each renderer has a camera property, which is
	 * its camera object.
	 */
	public class Camera 
	{
		private var _projectionDistance:Number = 400;
		private var _nearDistance:Number = 10;
		private var _farDistance:Number = 2000;

		private var _transform:Matrix3D;
		private var _spaceTransform:Matrix3D;
		
		private var _position:Vector3D;
		private var _down:Vector3D;
		private var _target:Vector3D;
		
		private var _controller:CameraController;
		
		/*
		 * These properties have private getters because they can be
		 * invalidated when other properties are set - the getter
		 * recalculates the value if it has been invalidated
		 */
		private var _pDirection:Vector3D;
		private var _pTrack:Vector3D;
		private var _pFront:Vector3D;
		
		private var _realDown:Vector3D;
		private var _projectionTransform:Matrix3D;
		
		/**
		 * The constructor creates a Camera object. Usually, users don't need to create camera
		 * objects, but will use the camera objects that are properties of Flint's renderers.
		 */
		public function Camera()
		{
			_position = new Vector3D( 0, 0, 0, 1 );
			_target = new Vector3D( 0, 0, 0, 1 );
			_down = new Vector3D( 0, 1, 0 );
			_pDirection = new Vector3D( 0, 0, 1 );
			_realDown = new Vector3D();
			_projectionTransform = new Matrix3D;
		}

		/**
		 * The point that the camera looks at. Setting this will
		 * invalidate any setting for the camera direction - the direction
		 * will be recalculated based on the position and the target.
		 * 
		 * @see #direction
		 */
		public function get target():Vector3D
		{
			return _target.clone();
		}
		public function set target( value:Vector3D ):void
		{
			_target = Vector3DUtils.clonePoint( value );
			_pDirection = null;
			_pTrack = null;
			_spaceTransform = null;
		}
		
		/**
		 * The location of the camera.
		 */
		public function get position():Vector3D
		{
			return _position.clone();
		}
		public function set position( value:Vector3D ):void
		{
			_position = Vector3DUtils.clonePoint( value );
			_spaceTransform = null;
			if( _target )
			{
				_pDirection = null;
				_pTrack = null;
			}
		}
		
		/**
		 * The direction the camera is pointing. Setting this will invalidate any
		 * setting for the target, since the camera now points in this direction
		 * rather than pointing towards the target.
		 * 
		 * @see #target
		 */
		public function get direction():Vector3D
		{
			return _direction.clone();
		}
		public function set direction( value:Vector3D ):void
		{
			_pDirection = Vector3DUtils.cloneUnit( value );
			_target = null;
			_spaceTransform = null;
			_pTrack = null;
		}
		
		/**
		 * The down direction for the camera. If this is not perpendicular to the direction the camera points, 
		 * the camera is tilted down or up from this up direction to point in the direction or at the target.
		 */
		public function get down():Vector3D
		{
			return _down.clone();
		}
		public function set down( value:Vector3D ):void
		{
			_down = Vector3DUtils.cloneUnit( value );
			_spaceTransform = null;
			_pTrack = null;
		}
		
		/**
		 * The transform matrix that converts positions in world space to positions in camera space.
		 * The projection transform is part of this transform - so vectors need only to have their
		 * project method called to get their position in 2D camera space.
		 */
		public function get transform():Matrix3D
		{
			if( !_spaceTransform || !_transform )
			{
				_transform = spaceTransform.clone();
				_projectionTransform.rawData = Vector.<Number>( [
					_projectionDistance, 0, 0, 0,
					0, _projectionDistance, 0, 0,
					0, 0, 1, 1,
					0, 0, 0, 0
				] );
				_transform.append( _projectionTransform );
			}
			return _transform;
		}

		/**
		 * The transform matrix that converts positions in world space to positions in camera space.
		 * The projection transform is not part of this transform.
		 */
		public function get spaceTransform():Matrix3D
		{
			if( !_spaceTransform )
			{
				// This is more efficient than
				//_realDown = _direction.crossProduct( _track );
				_realDown.x = _direction.y * _track.z - _direction.z * _track.y;
				_realDown.y = _direction.z * _track.x - _direction.x * _track.z;
				_realDown.z = _direction.x * _track.y - _direction.y * _track.x;
				
				_spaceTransform = Matrix3DUtils.newBasisTransform( 
					Vector3DUtils.cloneUnit( _track ),
					Vector3DUtils.cloneUnit( _realDown ), 
					Vector3DUtils.cloneUnit( _direction ) );
				_spaceTransform.prependTranslation( -_position.x, -_position.y, -_position.z );
			}
			return _spaceTransform;
		}
				
		/**
		 * Dolly or Track the camera in/out in the direction it's facing.
		 * 
		 * @param distance The distance to move the camera. Positive values track in and
		 * negative values track out.
		 */
		public function dolly( distance:Number ):void
		{
			var dollyVector:Vector3D = _direction.clone();
			dollyVector.scaleBy( distance );
			_position.incrementBy( dollyVector );
			_spaceTransform = null;
		}
		
		/**
		 * Raise or lower the camera.
		 * 
		 * @param distance The distance to lift the camera. Positive values raise the camera
		 * and negative values lower the camera.
		 */
		public function lift( distance:Number ):void
		{
			var liftVector:Vector3D = _down.clone();
			liftVector.scaleBy( -distance );
			_position.incrementBy( liftVector );
			_spaceTransform = null;
		}
		
		/**
		 * Dolly or Track the camera left/right.
		 * 
		 * @param distance The distance to move the camera. Positive values move the camera to the
		 * right, negative values move it to the left.
		 */
		public function track( distance:Number ):void
		{
			var trackVector:Vector3D = _track.clone();
			trackVector.scaleBy( distance );
			_position.incrementBy( trackVector );
			_spaceTransform = null;
		}
		
		/**
		 * Tilt the camera up or down.
		 * 
		 * @param The angle (in radians) to tilt the camera. Positive values tilt up,
		 * negative values tilt down.
		 */
		public function tilt( angle:Number ):void
		{
			var m:Matrix3D = Matrix3DUtils.newRotate( angle, _track );
			_pDirection = m.transformVector( _direction );
			_spaceTransform = null;
			_target = null;
		}
		
		/**
		 * Pan the camera left or right.
		 * 
		 * @param The angle (in radians) to pan the camera. Positive values pan right,
		 * negative values pan left.
		 */
		public function pan( angle:Number ):void
		{
			var m:Matrix3D = Matrix3DUtils.newRotate( angle, _down );
			_pDirection = m.transformVector( _direction );
			_pTrack = null;
			_spaceTransform = null;
			_target = null;
		}

		/**
		 * Roll the camera clockwise or counter-clockwise.
		 * 
		 * @param The angle (in radians) to roll the camera. Positive values roll clockwise,
		 * negative values roll counter-clockwise.
		 */
		public function roll( angle:Number ):void
		{
			var m:Matrix3D = Matrix3DUtils.newRotate( angle, _front );
			_down = m.transformVector( _down );
			_pTrack = null;
			_spaceTransform = null;
		}
		
		/**
		 * Orbit the camera around the target.
		 * 
		 * @param The angle (in radians) to orbit the camera. Positive values orbit to the right,
		 * negative values orbit to the left.
		 */
		public function orbit( angle:Number ):void
		{
			if( !_target )
			{
				throw new Error( "Attempting to orbit camera when no target is set" );
			}
			var m:Matrix3D = Matrix3DUtils.newRotate( -angle, down );
			_position = m.transformVector( _position );
			_pDirection = null;
			_pTrack = null;
			_spaceTransform = null;
		}
		 
		/**
		 * The distance to the camera's near plane
		 * - particles closer than this are not rendered.
		 * 
		 * The default value is 10.
		 */
		public function get nearPlaneDistance():Number
		{
			return _nearDistance;
		}
		public function set nearPlaneDistance( value:Number ):void
		{
			_nearDistance = value;
		}
		
		/**
		 * The distance to the camera's far plane
		 * - particles farther away than this are not rendered.
		 * 
		 * The default value is 2000.
		 */
		public function get farPlaneDistance():Number
		{
			return _farDistance;
		}
		public function set farPlaneDistance( value:Number ):void
		{
			_farDistance = value;
		}
		
		/**
		 * The distance to the camera's projection distance. Particles this
		 * distance from the camera are rendered at their normal size. Perspective
		 * will cause closer particles to appear larger than normal and more 
		 * distant particles to appear smaller than normal.
		 * 
		 * The default value is 400.
		 */
		public function get projectionDistance():Number
		{
			return _projectionDistance;
		}
		public function set projectionDistance( value:Number ):void
		{
			_projectionDistance = value;
			_transform = null;
		}
		
		/*
		 * private getters for properties that can be invaliadated.
		 */
		private function get _track():Vector3D
		{
			if( _pTrack == null )
			{
				_pTrack = _down.crossProduct( _direction );
			}
			_pFront == null;
			return _pTrack;
		}

		private function get _front():Vector3D
		{
			if( _pFront == null )
			{
				_pFront = _track.crossProduct( _down );
			}
			return _pFront;
		}
		
		private function get _direction():Vector3D
		{
			if( _pDirection == null && _target )
			{
				_pDirection = _target.subtract( _position );
				_pDirection.normalize();
			}
			return _pDirection;
		}
		
		public function get controller():CameraController
		{
			return _controller;
		}
		public function set controller( value:CameraController ):void
		{
			if( _controller )
			{
				_controller.camera = null;
			}
			_controller = value;
			_controller.camera = this;
		}
	}
}
