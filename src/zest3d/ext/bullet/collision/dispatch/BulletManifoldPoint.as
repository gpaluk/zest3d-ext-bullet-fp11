package zest3d.ext.bullet.collision.dispatch 
{
	import AWPC_Run.CModule;
	import io.plugin.math.algebra.AVector;
	import zest3d.ext.bullet.BulletBase;
	import zest3d.ext.bullet.math.BulletVector3;
	
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletManifoldPoint extends BulletBase 
	{
		
		private var m_localPointA : BulletVector3;
		private var m_localPointB : BulletVector3;
		private var m_normalWorldOnB : BulletVector3;
		
		public function BulletManifoldPoint(ptr : uint) 
		{
			pointer = ptr;
			m_localPointA = new BulletVector3(ptr + 0);
			m_localPointB = new BulletVector3(ptr + 16);
			m_normalWorldOnB = new BulletVector3(ptr + 64);
		}
		
		/**
		 *get the collision position in objectA's local coordinates
		 */
		public function get localPointA() : AVector {
			return m_localPointA.sv3d;
		}
		
		/**
		 *get the collision position in objectB's local coordinates
		 */
		public function get localPointB() : AVector {
			return m_localPointB.sv3d;
		}
		
		/**
		 *get the collision normal in world coordinates
		 */
		public function get normalWorldOnB() : AVector {
			return m_normalWorldOnB.v3d;
		}
		
		/**
		 *get the value of collision impulse
		 */
		public function get appliedImpulse() : Number {
			return CModule.readFloat(pointer + 120);
		}
	}

}