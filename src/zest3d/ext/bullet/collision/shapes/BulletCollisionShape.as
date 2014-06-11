package zest3d.ext.bullet.collision.shapes 
{
	import AWPC_Run.CModule;
	import AWPC_Run.setShapeScalingInC;
	import AWPC_Run.disposeCollisionShapeInC;
	
	import io.plugin.math.algebra.AVector;
	import zest3d.ext.bullet.BulletBase;
	import zest3d.ext.bullet.math.BulletVector3;
	
	/**
	 * ...
	 * @author Gary Paluk - http://www.plugin.io
	 */
	public class BulletCollisionShape extends BulletBase 
	{
		
		protected var m_shapeType:int;
		protected var m_localScaling:AVector;
		
		protected var m_counter:int = 0;
		
		public function BulletCollisionShape(ptr:uint, type:int) 
		{
			pointer = ptr;
			m_shapeType = type;
			
			m_localScaling = new AVector(1, 1, 1);
		}
		
		public function get shapeType():int {
			return m_shapeType;
		}

		public function get localScaling():AVector {
			return m_localScaling;
		}

		public function set localScaling(scale:AVector):void {
			m_localScaling.set(scale.x, scale.y, scale.z);
			if(scale.w == 0){
				var vec:BulletVector3 = new BulletVector3();
				vec.v3d = scale;
				setShapeScalingInC(pointer, vec.pointer);
				CModule.free(vec.pointer);
			}
		}
		
		public function retain():void {
			m_counter++;
		}
		
		public function dispose():void {
			m_counter--;
			if (m_counter > 0) {
				return;
			}else {
				m_counter = 0;
			}
			if (!_cleanup) {
				_cleanup  = true;
				disposeCollisionShapeInC(pointer);
			}
		}
	}

}