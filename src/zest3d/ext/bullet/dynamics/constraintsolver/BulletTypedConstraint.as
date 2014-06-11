package zest3d.ext.bullet.dynamics.constraintsolver 
{
	import AWPC_Run.disposeConstraintInC;
	import zest3d.ext.bullet.BulletBase;
	import zest3d.ext.bullet.dynamics.BulletRigidBody;
	
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletTypedConstraint extends BulletBase 
	{
		
		protected var m_rbA : BulletRigidBody;
		protected var m_rbB : BulletRigidBody;
		
		protected var m_constraintType:int;
		
		public function BulletTypedConstraint(type:int) 
		{
			m_constraintType = type;
		}
		
		public function get rigidBodyA() : BulletRigidBody {
			return m_rbA;
		}
		
		public function get rigidBodyB() : BulletRigidBody {
			return m_rbB;
		}
		
		public function get constraintType():int {
			return m_constraintType;
		}
		
		public function dispose():void {
			if (!_cleanup) {
				_cleanup = true;
				disposeConstraintInC(pointer);
			}
		}
	}

}