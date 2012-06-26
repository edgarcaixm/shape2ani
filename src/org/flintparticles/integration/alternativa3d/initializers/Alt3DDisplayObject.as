/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord & Michael Ivanov
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

package org.flintparticles.integration.alternativa3d.initializers
{
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Sprite3D;
	import alternativa.engine3d.resources.BitmapTextureResource;

	import org.flintparticles.common.initializers.ImageInitializerBase;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * The A3D4DisplayObject initializer sets the DisplayObject to use to 
	 * draw the particle in a 3D scene. It is used with the Alternativa3D renderer when
	 * particles should be represented by a display object.
	 * 
	 * <p>The initializer creates an Alternativa3D Sprite3D and a TextureMaterial, with the display object
	 * as the image source for the material, for rendering the display 
	 * object in an Alternativa3D scene.</p>
	 * 
	 * <p>This class includes an object pool for reusing objects when particles die.</p>
	 */
	public class Alt3DDisplayObject extends ImageInitializerBase
	{
		private var _displayObject:DisplayObject;
		private var _textureMaterial : TextureMaterial;
		
		/**
		 * The constructor creates an A3D4DisplayObject initializer for use by 
		 * an emitter. To add an A3D4DisplayObject to all particles created by an emitter, use the
		 * emitter's addInitializer method.
		 * 
		 * @param displayObject The DisplayObject to use when rendering the particles.
		 * @param usePool Indicates whether particles should be reused when a particle dies.
		 * @param fillPool Indicates how many particles to create immediately in the pool, to
		 * avoid creating them when the particle effect is running.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function Alt3DDisplayObject( displayObject:DisplayObject, usePool:Boolean = false, fillPool:uint = 0 )
		{
			super( usePool );
			_displayObject = displayObject;
			if( fillPool > 0 )
			{
				this.fillPool( fillPool );
			}
		}
		
		/**
		 * The DisplayObject to use when rendering the particles.
		 */
		public function get displayObject():DisplayObject
		{
			return _displayObject;
		}
		public function set displayObject( value:DisplayObject ):void
		{
			_displayObject = value;
			_textureMaterial = null;
			if( _usePool )
			{
				clearPool();
			}
		}
		
		/**
		 * Used internally, this method creates an image object for displaying the particle 
		 * by creating a Sprite3D and using the given DisplayObject as its material.
		 */
		override public function createImage():Object
		{
			if( ! _textureMaterial )
			{
				var bounds:Rectangle = _displayObject.getBounds( _displayObject );
				var width:int = textureSize( bounds.width );
				var height:int = textureSize( bounds.height );
				var bitmapData:BitmapData = new BitmapData( width, height, true, 0x00FFFFFF );
				var matrix:Matrix = _displayObject.transform.matrix.clone();
				matrix.translate( -bounds.left, -bounds.top );
				matrix.scale( width / bounds.width, height / bounds.height );
				bitmapData.draw( _displayObject, matrix, _displayObject.transform.colorTransform, null, null, true );
				var resource : BitmapTextureResource = new BitmapTextureResource( bitmapData );
				_textureMaterial = new TextureMaterial( resource, resource );
			}
			return new Sprite3D( _displayObject.width, _displayObject.height, _textureMaterial );
		}
		
		private function textureSize( value:Number ):int
		{
			var val:int = Math.ceil( value );
			var count:int = 0;
			while( val )
			{
				count++;
				val = val >>> 1;
			}
			return 1 << count + 1;
		}
	}
}
