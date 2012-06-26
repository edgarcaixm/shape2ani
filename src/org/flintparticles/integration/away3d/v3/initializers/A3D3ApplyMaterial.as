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
package org.flintparticles.integration.away3d.v3.initializers
{
	import away3d.core.base.Object3D;
	
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.utils.construct;	

	/**
	 * The ApplyMaterial initializer sets a material to apply to the Away3D
	 * object that is used when rendering the particle. To use this initializer,
	 * the particle's image object must be an Away3D Object3D.
	 * 
	 * <p>This initializer has a priority of -10 to ensure that it is applied after 
	 * the ImageInit classes which define the image object.</p>
	 */
	public class A3D3ApplyMaterial extends InitializerBase
	{
		private var _materialClass:Class;
		private var _parameters:Array;
		
		/**
		 * The constructor creates an ApplyMaterial initializer for use by 
		 * an emitter. To add an ApplyMaterial to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param materialClass The class to use when creating
		 * the particles' material.
		 * @param parameters The parameters to pass to the constructor
		 * for the material class.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function A3D3ApplyMaterial( materialClass:Class, ...parameters )
		{
			priority = -10;
			_materialClass = materialClass;
			_parameters = parameters;
		}
		
		/**
		 * The class to use when creating the particles' material.
		 */
		public function get materialClass():Class
		{
			return _materialClass;
		}
		public function set materialClass( value:Class ):void
		{
			_materialClass = value;
		}
		
		/**
		 * The parameters to pass to the constructor
		 * for the material class.
		 */
		public function get parameters():Array
		{
			return _parameters;
		}
		public function set parameters( value:Array ):void
		{
			_parameters = value;
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
					Object3D( particle.image )["material"] = construct( _materialClass, _parameters );
				}
			}
		}
	}
}
