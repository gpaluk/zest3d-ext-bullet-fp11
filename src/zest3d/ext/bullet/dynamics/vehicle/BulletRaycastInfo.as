package zest3d.ext.bullet.dynamics.vehicle 
{
	import AWPC_Run.CModule;
	import io.plugin.math.algebra.AVector;
	import zest3d.ext.bullet.BulletBase;
	import zest3d.ext.bullet.math.BulletVector3;
	
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletRaycastInfo extends BulletBase 
	{
		private var m_contactNormalWS : BulletVector3;
		private var m_contactPointWS : BulletVector3;
		private var m_hardPointWS : BulletVector3;
		private var m_wheelDirectionWS : BulletVector3;
		private var m_wheelAxleWS : BulletVector3;
		
		public function BulletRaycastInfo(ptr : uint) 
		{
			pointer = ptr;
			
			m_contactNormalWS = new BulletVector3(ptr + 0);
			m_contactPointWS = new BulletVector3(ptr + 16);
			m_hardPointWS = new BulletVector3(ptr + 36);
			m_wheelDirectionWS = new BulletVector3(ptr + 52);
			m_wheelAxleWS = new BulletVector3(ptr + 68);
		}
		
		public function get contactNormalWS() : AVector {
			return m_contactNormalWS.v3d;
		}
		
		public function get contactPointWS() : AVector {
			return m_contactPointWS.sv3d;
		}
		
		public function get hardPointWS() : AVector {
			return m_hardPointWS.sv3d;
		}
		
		public function get wheelDirectionWS() : AVector {
			return m_wheelDirectionWS.v3d;
		}
		
		public function get wheelAxleWS() : AVector {
			return m_wheelAxleWS.v3d;
		}
		
		public function get suspensionLength() : Number {
			return CModule.readFloat(pointer + 32) * _scaling;
		}
		
		public function get isInContact() : Boolean {
			return CModule.read8(pointer + 84) == 1;
		}
	}

}