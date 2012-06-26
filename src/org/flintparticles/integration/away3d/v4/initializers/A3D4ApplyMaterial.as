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

package org.flintparticles.integration.away3d.v4.initializers
{
	import away3d.core.base.Object3D;
	import away3d.materials.MaterialBase;

	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;

	/**
	 * The A3D4ApplyMaterial initializer sets a material to apply to the Away3D 4
	 * object that is used when rendering the particle. To use this initializer,
	 * the particle's image object must be an Away3D 4 Object3D.
	 * 
	 * <p>This initializer has a priority of -10 to ensure that it is applied after 
	 * the ImageInit classes which define the image object.</p>
	 */
	public class A3D4ApplyMaterial extends InitializerBase
	{
		private var _material:MaterialBase;
		
		/**
		 * The constructor creates an A3D4ApplyMaterial initializer for use by 
		 * an emitter. To add an A3D4ApplyMaterial to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param material The material to use for the particle.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function A3D4ApplyMaterial( material:MaterialBase )
		{
			priority = -10;
			_material = material;
		}
		
		/**
		 * The material to apply to the particles.
		 */
		public function get material():MaterialBase
		{
			return _material;
		}
		public function set material( value:MaterialBase ):void
		{
			_material = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			if( particle.image && particle.image is Object3D )
			{
				if( Object3D( particle.image ).hasOwnProperty( "material" ) )
				{
					Object3D( particle.image )["material"] = _material;
				}
			}
		}
	}
}
