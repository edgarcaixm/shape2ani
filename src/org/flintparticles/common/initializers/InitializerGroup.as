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

package org.flintparticles.common.initializers 
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;	

	[DefaultProperty("initializers")]
	
	/**
	 * The InitializerGroup initializer collects a number of initializers into a single 
	 * larger initializer that applies all the grouped initializers to a particle. It is
	 * commonly used with the ChooseInitializer initializer to choose from different
	 * groups of initializers when initializing a particle.
	 * 
	 * @see org.flintparticles.common.initializers.ChooseInitializer
	 */

	public class InitializerGroup extends InitializerBase
	{
		private var _initializers:Vector.<Initializer>;
		private var _emitter:Emitter;
		
		/**
		 * The constructor creates an InitializerGroup.
		 * 
		 * @param initializers Initializers that should be added to the group.
		 */
		public function InitializerGroup( ...initializers )
		{
			_initializers = new Vector.<Initializer>();
			for each( var i:Initializer in initializers )
			{
				addInitializer( i );
			}
		}
		
		public function get initializers():Vector.<Initializer>
		{
			return _initializers;
		}
		public function set initializers( value:Vector.<Initializer> ):void
		{
			var initializer:Initializer;
			if( _emitter )
			{
				for each( initializer in _initializers )
				{
					initializer.removedFromEmitter( _emitter );
				}
			}
			_initializers = value.slice( );
			_initializers.sort( prioritySort );
			if( _emitter )
			{
				for each( initializer in _initializers )
				{
					initializer.addedToEmitter( _emitter );
				}
			}
		}

		public function addInitializer( initializer:Initializer ):void
		{
			var len:uint = _initializers.length;
			for( var i:uint = 0; i < len; ++i )
			{
				if( _initializers[i].priority < initializer.priority )
				{
					break;
				}
			}
			_initializers.splice( i, 0, initializer );
			if( _emitter )
			{
				initializer.addedToEmitter( _emitter );
			}
		}
		
		public function removeInitializer( initializer:Initializer ):void
		{
			var index:int = _initializers.indexOf( initializer );
			if( index != -1 )
			{
				_initializers.splice( index, 1 );
				if( _emitter )
				{
					initializer.removedFromEmitter( _emitter );
				}
			}
		}
		
		override public function addedToEmitter( emitter:Emitter ):void
		{
			_emitter = emitter;
			var len:uint = _initializers.length;
			for( var i:uint = 0; i < len; ++i )
			{
				_initializers[i].addedToEmitter( emitter );
			}
		}

		override public function removedFromEmitter( emitter:Emitter ):void
		{
			var len:uint = _initializers.length;
			for( var i:uint = 0; i < len; ++i )
			{
				_initializers[i].removedFromEmitter( emitter );
			}
			_emitter = null;
		}

		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			var len:uint = _initializers.length;
			for( var i:uint = 0; i < len; ++i )
			{
				_initializers[i].initialize( emitter, particle );
			}
		}
		
		private function prioritySort( b1:Initializer, b2:Initializer ):Number
		{
			return b1.priority - b2.priority;
		}
	}
}
